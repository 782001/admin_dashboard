import 'package:equatable/equatable.dart';
import '../../domain/entities/skill_entity.dart';

abstract class SkillsState extends Equatable {
  const SkillsState();

  @override
  List<Object?> get props => [];
}

class SkillsInitial extends SkillsState {}

class SkillsLoading extends SkillsState {}

class SkillsLoaded extends SkillsState {
  final List<SkillEntity> skills;
  const SkillsLoaded(this.skills);

  @override
  List<Object?> get props => [skills];
}

class SkillsActionInProgress extends SkillsState {}

class SkillsActionSuccess extends SkillsState {
  final String message;
  const SkillsActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class SkillsError extends SkillsState {
  final String message;
  const SkillsError(this.message);

  @override
  List<Object?> get props => [message];
}
