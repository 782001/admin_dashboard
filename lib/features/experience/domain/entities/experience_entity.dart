import 'package:equatable/equatable.dart';

class ExperienceEntity extends Equatable {
  final String id;
  final String companyText;
  final String role;
  final String startDate;
  final String? endDate;
  final String? description;

  const ExperienceEntity({
    required this.id,
    required this.companyText,
    required this.role,
    required this.startDate,
    this.endDate,
    this.description,
  });

  @override
  List<Object?> get props => [
    id,
    companyText,
    role,
    startDate,
    endDate,
    description,
  ];
}
