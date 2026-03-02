import 'package:equatable/equatable.dart';

class EducationEntity extends Equatable {
  final String id;
  final String degree;
  final String institution;
  final String startDate;
  final String? endDate;
  final int orderIndex;

  const EducationEntity({
    required this.id,
    required this.degree,
    required this.institution,
    required this.startDate,
    this.endDate,
    required this.orderIndex,
  });

  @override
  List<Object?> get props => [
    id,
    degree,
    institution,
    startDate,
    endDate,
    orderIndex,
  ];
}
