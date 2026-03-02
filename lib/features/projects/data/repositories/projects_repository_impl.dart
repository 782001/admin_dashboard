import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/repositories/projects_repository.dart';
import '../models/project_model.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  final SupabaseClient supabaseClient;

  ProjectsRepositoryImpl({required this.supabaseClient});

  @override
  Future<List<ProjectEntity>> getProjects() async {
    final response = await supabaseClient
        .from('projects')
        .select('*, project_images(*)')
        .order('order_index', ascending: true);

    return (response as List).map((json) {
      final imagesJson = json['project_images'] as List?;
      final images = (imagesJson ?? [])
          .map((img) => ProjectImageModel.fromJson(img))
          .toList();
      return ProjectModel.fromJson(json, images: images);
    }).toList();
  }

  @override
  Future<ProjectEntity> addProject(ProjectEntity project) async {
    final model = ProjectModel(
      id: '',
      title: project.title,
      description: project.description,
      technologies: project.technologies,
      playStoreUrl: project.playStoreUrl,
      githubUrl: project.githubUrl,
      driveUrl: project.driveUrl,
      logoUrl: project.logoUrl,
      orderIndex: project.orderIndex,
    );

    final response = await supabaseClient
        .from('projects')
        .insert(model.toJson())
        .select()
        .single();
    return ProjectModel.fromJson(response);
  }

  @override
  Future<void> updateProject(ProjectEntity project) async {
    final model = ProjectModel(
      id: project.id,
      title: project.title,
      description: project.description,
      technologies: project.technologies,
      playStoreUrl: project.playStoreUrl,
      githubUrl: project.githubUrl,
      driveUrl: project.driveUrl,
      logoUrl: project.logoUrl,
      orderIndex: project.orderIndex,
    );
    await supabaseClient
        .from('projects')
        .update(model.toJson())
        .eq('id', project.id);
  }

  @override
  Future<void> deleteProject(String id) async {
    // Relying on ON DELETE CASCADE for project_images
    await supabaseClient.from('projects').delete().eq('id', id);
  }

  @override
  Future<ProjectImageEntity> uploadProjectImage(
    String projectId,
    String fileName,
    List<int> fileBytes,
    bool isPrimary,
  ) async {
    final path =
        '$projectId/${DateTime.now().millisecondsSinceEpoch}_$fileName';
    await supabaseClient.storage
        .from('projects')
        .uploadBinary(path, Uint8List.fromList(fileBytes));

    final imageUrl = supabaseClient.storage.from('projects').getPublicUrl(path);

    final response = await supabaseClient
        .from('project_images')
        .insert({
          'project_id': projectId,
          'image_url': imageUrl,
          'is_primary': isPrimary,
        })
        .select()
        .single();

    return ProjectImageModel.fromJson(response);
  }

  @override
  Future<void> deleteProjectImage(String imageId, String imageUrl) async {
    // Delete from DB
    await supabaseClient.from('project_images').delete().eq('id', imageId);

    // Attempt to delete from storage. Parse path from URL
    try {
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;
      final bucketIndex = pathSegments.indexOf('projects');
      if (bucketIndex != -1 && bucketIndex < pathSegments.length - 1) {
        final filePath = pathSegments.sublist(bucketIndex + 1).join('/');
        await supabaseClient.storage.from('projects').remove([filePath]);
      }
    } catch (e) {
      // ignore
    }
  }

  @override
  Future<String> uploadProjectLogo(String fileName, List<int> fileBytes) async {
    final path = 'logos/${DateTime.now().millisecondsSinceEpoch}_$fileName';
    await supabaseClient.storage
        .from('projects')
        .uploadBinary(path, Uint8List.fromList(fileBytes));

    return supabaseClient.storage.from('projects').getPublicUrl(path);
  }
}
