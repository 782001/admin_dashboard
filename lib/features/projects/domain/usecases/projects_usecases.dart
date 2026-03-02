import '../entities/project_entity.dart';
import '../repositories/projects_repository.dart';

class GetProjectsUseCase {
  final ProjectsRepository repository;
  GetProjectsUseCase(this.repository);

  Future<List<ProjectEntity>> call() => repository.getProjects();
}

class AddProjectUseCase {
  final ProjectsRepository repository;
  AddProjectUseCase(this.repository);

  Future<ProjectEntity> call(ProjectEntity project) =>
      repository.addProject(project);
}

class UpdateProjectUseCase {
  final ProjectsRepository repository;
  UpdateProjectUseCase(this.repository);

  Future<void> call(ProjectEntity project) => repository.updateProject(project);
}

class DeleteProjectUseCase {
  final ProjectsRepository repository;
  DeleteProjectUseCase(this.repository);

  Future<void> call(String id) => repository.deleteProject(id);
}

class UploadProjectImageUseCase {
  final ProjectsRepository repository;
  UploadProjectImageUseCase(this.repository);

  Future<ProjectImageEntity> call(
    String projectId,
    String fileName,
    List<int> bytes,
    bool isPrimary,
  ) => repository.uploadProjectImage(projectId, fileName, bytes, isPrimary);
}

class DeleteProjectImageUseCase {
  final ProjectsRepository repository;
  DeleteProjectImageUseCase(this.repository);

  Future<void> call(String imageId, String imageUrl) =>
      repository.deleteProjectImage(imageId, imageUrl);
}

class UploadProjectLogoUseCase {
  final ProjectsRepository repository;
  UploadProjectLogoUseCase(this.repository);

  Future<String> call(String fileName, List<int> bytes) =>
      repository.uploadProjectLogo(fileName, bytes);
}
