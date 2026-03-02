import 'package:equatable/equatable.dart';

class ExperienceEntity extends Equatable {
  final String id;
  final String companyText;
  final String role;
  final String startDate;
  final String? endDate;

  const ExperienceEntity({
    required this.id,
    required this.companyText,
    required this.role,
    required this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [id, companyText, role, startDate, endDate];
}
