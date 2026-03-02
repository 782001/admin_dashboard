import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/education_entity.dart';
import '../../domain/usecases/education_usecases.dart';
import 'education_state.dart';

class EducationCubit extends Cubit<EducationState> {
  final GetEducationsUseCase getEducationsUseCase;
  final AddEducationUseCase addEducationUseCase;
  final UpdateEducationUseCase updateEducationUseCase;
  final DeleteEducationUseCase deleteEducationUseCase;

  EducationCubit({
    required this.getEducationsUseCase,
    required this.addEducationUseCase,
    required this.updateEducationUseCase,
    required this.deleteEducationUseCase,
  }) : super(EducationInitial());

  Future<void> loadEducations() async {
    emit(EducationLoading());
    try {
      final data = await getEducationsUseCase();
      emit(EducationLoaded(data));
    } catch (e) {
      emit(EducationError(e.toString()));
    }
  }

  Future<void> addEducation(EducationEntity edu) async {
    emit(EducationActionInProgress());
    try {
      await addEducationUseCase(edu);
      emit(const EducationActionSuccess('Education added successfully'));
      loadEducations();
    } catch (e) {
      emit(EducationError(e.toString()));
      loadEducations();
    }
  }

  Future<void> updateEducation(EducationEntity edu) async {
    emit(EducationActionInProgress());
    try {
      await updateEducationUseCase(edu);
      emit(const EducationActionSuccess('Education updated successfully'));
      loadEducations();
    } catch (e) {
      emit(EducationError(e.toString()));
      loadEducations();
    }
  }

  Future<void> deleteEducation(String id) async {
    emit(EducationActionInProgress());
    try {
      await deleteEducationUseCase(id);
      emit(const EducationActionSuccess('Education deleted successfully'));
      loadEducations();
    } catch (e) {
      emit(EducationError(e.toString()));
      loadEducations();
    }
  }
}
