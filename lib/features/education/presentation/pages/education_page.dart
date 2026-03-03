import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart' as di;
import '../../domain/entities/education_entity.dart';
import '../cubit/education_cubit.dart';
import '../cubit/education_state.dart';
import '../widgets/education_form_dialog.dart';

class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<EducationCubit>()..loadEducations(),
      child: const EducationView(),
    );
  }
}

class EducationView extends StatelessWidget {
  const EducationView({super.key});

  void _showEduDialog(BuildContext context, [EducationEntity? edu]) async {
    final cubit = context.read<EducationCubit>();
    final result = await showDialog<EducationEntity>(
      context: context,
      builder: (context) => EducationFormDialog(education: edu),
    );

    if (result != null) {
      if (edu == null) {
        cubit.addEducation(result);
      } else {
        cubit.updateEducation(result);
      }
    }
  }

  void _confirmDelete(BuildContext context, EducationEntity edu) {
    final cubit = context.read<EducationCubit>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Education'),
        content: Text(
          'Are you sure you want to delete ${edu.degree} at ${edu.institution}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              cubit.deleteEducation(edu.id);
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
      appBar: AppBar(title: const Text('Education Management')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showEduDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Education'),
      ),
      body: BlocConsumer<EducationCubit, EducationState>(
        listener: (context, state) {
          if (state is EducationActionSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is EducationError) {
            debugPrint(state.message.toString());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is EducationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EducationLoaded) {
            final educations = state.educations;
            if (educations.isEmpty) {
              return const Center(child: Text('No education found.'));
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
                        'Education History',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 24),
                      DataTable(
                        columns: const [
                          DataColumn(label: Text('Degree')),
                          DataColumn(label: Text('Institution')),
                          DataColumn(label: Text('Duration')),
                          DataColumn(label: Text('Order')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: educations
                            .map(
                              (edu) => DataRow(
                                cells: [
                                  DataCell(Text(edu.degree)),
                                  DataCell(Text(edu.institution)),
                                  DataCell(
                                    Text(
                                      '${edu.startDate} - ${edu.endDate ?? "Present"}',
                                    ),
                                  ),
                                  DataCell(Text(edu.orderIndex.toString())),
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                          ),
                                          onPressed: () =>
                                              _showEduDialog(context, edu),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () =>
                                              _confirmDelete(context, edu),
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
          return const Center(child: Text('Failed to load education'));
        },
      ),
    );
  }
}
