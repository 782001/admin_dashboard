import 'package:equatable/equatable.dart';
import '../../domain/entities/education_entity.dart';

abstract class EducationState extends Equatable {
  const EducationState();

  @override
  List<Object?> get props => [];
}

class EducationInitial extends EducationState {}

class EducationLoading extends EducationState {}

class EducationLoaded extends EducationState {
  final List<EducationEntity> educations;
  const EducationLoaded(this.educations);

  @override
  List<Object?> get props => [educations];
}

class EducationActionInProgress extends EducationState {}

class EducationActionSuccess extends EducationState {
  final String message;
  const EducationActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class EducationError extends EducationState {
  final String message;
  const EducationError(this.message);

  @override
  List<Object?> get props => [message];
}
