import 'package:equatable/equatable.dart';

class SettingsEntity extends Equatable {
  final String id;
  final String fullName;
  final String title;
  final String summary;
  final String location;
  final String? profileImageUrl;
  final String? cvUrl;

  const SettingsEntity({
    required this.id,
    required this.fullName,
    required this.title,
    required this.summary,
    required this.location,
    this.profileImageUrl,
    this.cvUrl,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    title,
    summary,
    location,
    profileImageUrl,
    cvUrl,
  ];
}
