import '../../domain/entities/project_entity.dart';

class ProjectModel extends ProjectEntity {
  const ProjectModel({
    required super.id,
    required super.title,
    super.description,
    super.technologies,
    super.playStoreUrl,
    super.githubUrl,
    super.driveUrl,
    super.logoUrl,
    super.orderIndex,
    super.images,
  });

  factory ProjectModel.fromJson(
    Map<String, dynamic> json, {
    List<ProjectImageModel>? images,
  }) {
    return ProjectModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      technologies: json['technologies'] != null
          ? List<String>.from(json['technologies'])
          : [],
      playStoreUrl: json['play_store_url'],
      githubUrl: json['github_url'],
      driveUrl: json['drive_url'],
      logoUrl: json['logo_url'],
      orderIndex: json['order_index'] ?? 0,
      images: images ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'title': title,
      'description': description,
      'technologies': technologies,
      'play_store_url': playStoreUrl,
      'github_url': githubUrl,
      'drive_url': driveUrl,
      'logo_url': logoUrl,
      'order_index': orderIndex,
    };
  }
}

class ProjectImageModel extends ProjectImageEntity {
  const ProjectImageModel({
    required super.id,
    required super.projectId,
    required super.imageUrl,
    super.isPrimary,
  });

  factory ProjectImageModel.fromJson(Map<String, dynamic> json) {
    return ProjectImageModel(
      id: json['id'],
      projectId: json['project_id'],
      imageUrl: json['image_url'],
      isPrimary: json['is_primary'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'project_id': projectId,
      'image_url': imageUrl,
      'is_primary': isPrimary,
    };
  }
}
