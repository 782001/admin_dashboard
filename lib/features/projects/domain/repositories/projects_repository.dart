import '../entities/project_entity.dart';

abstract class ProjectsRepository {
  Future<List<ProjectEntity>> getProjects();
  Future<ProjectEntity> addProject(ProjectEntity project);
  Future<void> updateProject(ProjectEntity project);
  Future<void> deleteProject(String id);
  Future<ProjectImageEntity> uploadProjectImage(
    String projectId,
    String fileName,
    List<int> fileBytes,
    bool isPrimary,
  );
  Future<void> deleteProjectImage(String imageId, String imageUrl);
  Future<String> uploadProjectLogo(String fileName, List<int> fileBytes);
}
