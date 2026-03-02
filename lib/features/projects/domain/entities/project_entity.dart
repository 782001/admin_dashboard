import 'package:equatable/equatable.dart';

class ProjectEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final List<String> technologies;
  final String? playStoreUrl;
  final String? githubUrl;
  final String? driveUrl;
  final String? logoUrl;
  final int orderIndex;
  final List<ProjectImageEntity> images;

  const ProjectEntity({
    required this.id,
    required this.title,
    this.description,
    this.technologies = const [],
    this.playStoreUrl,
    this.githubUrl,
    this.driveUrl,
    this.logoUrl,
    this.orderIndex = 0,
    this.images = const [],
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    technologies,
    playStoreUrl,
    githubUrl,
    driveUrl,
    logoUrl,
    orderIndex,
    images,
  ];
}

class ProjectImageEntity extends Equatable {
  final String id;
  final String projectId;
  final String imageUrl;
  final bool isPrimary;

  const ProjectImageEntity({
    required this.id,
    required this.projectId,
    required this.imageUrl,
    this.isPrimary = false,
  });

  @override
  List<Object?> get props => [id, projectId, imageUrl, isPrimary];
}
