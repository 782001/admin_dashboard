import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart' as di;
import '../cubit/projects_cubit.dart';
import '../cubit/projects_state.dart';
import '../widgets/project_form_dialog.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<ProjectsCubit>()..loadProjects(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Projects Management')),
        body: BlocBuilder<ProjectsCubit, ProjectsState>(
          builder: (context, state) {
            if (state is ProjectsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProjectsError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is ProjectsLoaded) {
              final projects = state.projects;
              if (projects.isEmpty) {
                return const Center(child: Text('No projects found.'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      title: Text(
                        project.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(project.description ?? 'No description'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => BlocProvider.value(
                                  value: context.read<ProjectsCubit>(),
                                  child: ProjectFormDialog(project: project),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              context.read<ProjectsCubit>().deleteProject(
                                project.id,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(child: Text('Initialize'));
          },
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: context.read<ProjectsCubit>(),
                    child: const ProjectFormDialog(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
