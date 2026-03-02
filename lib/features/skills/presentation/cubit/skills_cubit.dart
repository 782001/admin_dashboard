import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/skill_entity.dart';
import '../../domain/usecases/skills_usecases.dart';
import 'skills_state.dart';

class SkillsCubit extends Cubit<SkillsState> {
  final GetSkillsUseCase getSkillsUseCase;
  final AddSkillUseCase addSkillUseCase;
  final UpdateSkillUseCase updateSkillUseCase;
  final DeleteSkillUseCase deleteSkillUseCase;

  SkillsCubit({
    required this.getSkillsUseCase,
    required this.addSkillUseCase,
    required this.updateSkillUseCase,
    required this.deleteSkillUseCase,
  }) : super(SkillsInitial());

  Future<void> loadSkills() async {
    emit(SkillsLoading());
    try {
      final skills = await getSkillsUseCase();
      emit(SkillsLoaded(skills));
    } catch (e) {
      emit(SkillsError(e.toString()));
    }
  }

  Future<void> addSkill(SkillEntity skill) async {
    emit(SkillsActionInProgress());
    try {
      await addSkillUseCase(skill);
      emit(const SkillsActionSuccess('Skill added successfully'));
      loadSkills();
    } catch (e) {
      emit(SkillsError(e.toString()));
      loadSkills();
    }
  }

  Future<void> updateSkill(SkillEntity skill) async {
    emit(SkillsActionInProgress());
    try {
      await updateSkillUseCase(skill);
      emit(const SkillsActionSuccess('Skill updated successfully'));
      loadSkills();
    } catch (e) {
      emit(SkillsError(e.toString()));
      loadSkills();
    }
  }

  Future<void> deleteSkill(String id) async {
    emit(SkillsActionInProgress());
    try {
      await deleteSkillUseCase(id);
      emit(const SkillsActionSuccess('Skill deleted successfully'));
      loadSkills();
    } catch (e) {
      emit(SkillsError(e.toString()));
      loadSkills();
    }
  }
}
