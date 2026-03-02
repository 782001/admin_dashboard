import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/usecases/projects_usecases.dart';
import 'projects_state.dart';

class ProjectsCubit extends Cubit<ProjectsState> {
  final GetProjectsUseCase getProjectsUseCase;
  final AddProjectUseCase addProjectUseCase;
  final UpdateProjectUseCase updateProjectUseCase;
  final DeleteProjectUseCase deleteProjectUseCase;
  final UploadProjectImageUseCase uploadImageUseCase;
  final DeleteProjectImageUseCase deleteImageUseCase;
  final UploadProjectLogoUseCase uploadLogoUseCase;

  ProjectsCubit({
    required this.getProjectsUseCase,
    required this.addProjectUseCase,
    required this.updateProjectUseCase,
    required this.deleteProjectUseCase,
    required this.uploadImageUseCase,
    required this.deleteImageUseCase,
    required this.uploadLogoUseCase,
  }) : super(ProjectsInitial());

  Future<void> loadProjects() async {
    emit(ProjectsLoading());
    try {
      final projects = await getProjectsUseCase();
      emit(ProjectsLoaded(projects));
    } catch (e) {
      emit(ProjectsError(e.toString()));
    }
  }

  Future<void> addProject(ProjectEntity project) async {
    try {
      await addProjectUseCase(project);
      await loadProjects();
    } catch (e) {
      emit(ProjectsError(e.toString()));
    }
  }

  Future<ProjectEntity> addProjectAsync(ProjectEntity project) async {
    try {
      return await addProjectUseCase(project);
    } catch (e) {
      emit(ProjectsError(e.toString()));
      rethrow;
    }
  }

  Future<void> uploadImage(
    String projectId,
    String fileName,
    List<int> bytes,
  ) async {
    try {
      await uploadImageUseCase(projectId, fileName, bytes, false);
    } catch (e) {
      emit(ProjectsError(e.toString()));
    }
  }

  Future<String?> uploadLogo(String fileName, List<int> bytes) async {
    try {
      return await uploadLogoUseCase(fileName, bytes);
    } catch (e) {
      emit(ProjectsError(e.toString()));
      return null;
    }
  }

  Future<void> deleteImage(String imageId, String imageUrl) async {
    try {
      await deleteImageUseCase(imageId, imageUrl);
    } catch (e) {
      emit(ProjectsError(e.toString()));
    }
  }

  Future<void> deleteProject(String id) async {
    try {
      await deleteProjectUseCase(id);
      await loadProjects();
    } catch (e) {
      emit(ProjectsError(e.toString()));
    }
  }
}
