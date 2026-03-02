import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart' as di;
import '../../domain/entities/experience_entity.dart';
import '../cubit/experience_cubit.dart';
import '../cubit/experience_state.dart';
import '../widgets/experience_form_dialog.dart';

class ExperiencePage extends StatelessWidget {
  const ExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ExperienceCubit>()..loadExperiences(),
      child: const ExperienceView(),
    );
  }
}

class ExperienceView extends StatelessWidget {
  const ExperienceView({super.key});

  void _showExpDialog(BuildContext context, [ExperienceEntity? exp]) async {
    final cubit = context.read<ExperienceCubit>();
    final result = await showDialog<ExperienceEntity>(
      context: context,
      builder: (context) => ExperienceFormDialog(experience: exp),
    );

    if (result != null) {
      if (exp == null) {
        cubit.addExperience(result);
      } else {
        cubit.updateExperience(result);
      }
    }
  }

  void _confirmDelete(BuildContext context, ExperienceEntity exp) {
    final cubit = context.read<ExperienceCubit>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Experience'),
        content: Text(
          'Are you sure you want to delete ${exp.role} at ${exp.companyText}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              cubit.deleteExperience(exp.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Experience Management')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showExpDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Experience'),
      ),
      body: BlocConsumer<ExperienceCubit, ExperienceState>(
        listener: (context, state) {
          if (state is ExperienceActionSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is ExperienceError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ExperienceLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ExperienceLoaded) {
            final experiences = state.experiences;
            if (experiences.isEmpty) {
              return const Center(child: Text('No experience found.'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Work Experience',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 24),
                      DataTable(
                        columns: const [
                          DataColumn(label: Text('Company')),
                          DataColumn(label: Text('Role')),
                          DataColumn(label: Text('Dates')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: experiences
                            .map(
                              (exp) => DataRow(
                                cells: [
                                  DataCell(Text(exp.companyText)),
                                  DataCell(Text(exp.role)),
                                  DataCell(
                                    Text(
                                      '${exp.startDate} - ${exp.endDate ?? "Present"}',
                                    ),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                          ),
                                          onPressed: () =>
                                              _showExpDialog(context, exp),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () =>
                                              _confirmDelete(context, exp),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(child: Text('Failed to load experience'));
        },
      ),
    );
  }
}
