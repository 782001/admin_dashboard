import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart' as di;
import '../../domain/entities/skill_entity.dart';
import '../cubit/skills_cubit.dart';
import '../cubit/skills_state.dart';
import '../widgets/skill_form_dialog.dart';

class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<SkillsCubit>()..loadSkills(),
      child: const SkillsView(),
    );
  }
}

class SkillsView extends StatelessWidget {
  const SkillsView({super.key});

  void _showSkillDialog(BuildContext context, [SkillEntity? skill]) async {
    final cubit = context.read<SkillsCubit>();
    final result = await showDialog<SkillEntity>(
      context: context,
      builder: (context) => SkillFormDialog(skill: skill),
    );

    if (result != null) {
      if (skill == null) {
        cubit.addSkill(result);
      } else {
        cubit.updateSkill(result);
      }
    }
  }

  void _confirmDelete(BuildContext context, SkillEntity skill) {
    final cubit = context.read<SkillsCubit>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Skill'),
        content: Text('Are you sure you want to delete ${skill.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              cubit.deleteSkill(skill.id);
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
      appBar: AppBar(title: const Text('Skills Management')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showSkillDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Skill'),
      ),
      body: BlocConsumer<SkillsCubit, SkillsState>(
        listener: (context, state) {
          if (state is SkillsActionSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is SkillsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is SkillsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SkillsLoaded) {
            final skills = state.skills;
            if (skills.isEmpty) {
              return const Center(child: Text('No skills found.'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('All Skills', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 24),
                      DataTable(
                        columns: const [
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: skills
                            .map(
                              (skill) => DataRow(
                                cells: [
                                  DataCell(Text(skill.name)),
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                          ),
                                          onPressed: () =>
                                              _showSkillDialog(context, skill),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () =>
                                              _confirmDelete(context, skill),
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
          return const Center(child: Text('Failed to load skills'));
        },
      ),
    );
  }
}
