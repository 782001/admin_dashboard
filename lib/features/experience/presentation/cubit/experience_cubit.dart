import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/experience_entity.dart';
import '../../domain/usecases/experience_usecases.dart';
import 'experience_state.dart';

class ExperienceCubit extends Cubit<ExperienceState> {
  final GetExperiencesUseCase getExperiencesUseCase;
  final AddExperienceUseCase addExperienceUseCase;
  final UpdateExperienceUseCase updateExperienceUseCase;
  final DeleteExperienceUseCase deleteExperienceUseCase;

  ExperienceCubit({
    required this.getExperiencesUseCase,
    required this.addExperienceUseCase,
    required this.updateExperienceUseCase,
    required this.deleteExperienceUseCase,
  }) : super(ExperienceInitial());

  Future<void> loadExperiences() async {
    emit(ExperienceLoading());
    try {
      final data = await getExperiencesUseCase();
      emit(ExperienceLoaded(data));
    } catch (e) {
      emit(ExperienceError(e.toString()));
    }
  }

  Future<void> addExperience(ExperienceEntity exp) async {
    emit(ExperienceActionInProgress());
    try {
      await addExperienceUseCase(exp);
      emit(const ExperienceActionSuccess('Experience added successfully'));
      loadExperiences();
    } catch (e) {
      emit(ExperienceError(e.toString()));
      loadExperiences();
    }
  }

  Future<void> updateExperience(ExperienceEntity exp) async {
    emit(ExperienceActionInProgress());
    try {
      await updateExperienceUseCase(exp);
      emit(const ExperienceActionSuccess('Experience updated successfully'));
      loadExperiences();
    } catch (e) {
      emit(ExperienceError(e.toString()));
      loadExperiences();
    }
  }

  Future<void> deleteExperience(String id) async {
    emit(ExperienceActionInProgress());
    try {
      await deleteExperienceUseCase(id);
      emit(const ExperienceActionSuccess('Experience deleted successfully'));
      loadExperiences();
    } catch (e) {
      emit(ExperienceError(e.toString()));
      loadExperiences();
    }
  }
}
