import '../entities/education_entity.dart';
import '../repositories/education_repository.dart';

class GetEducationsUseCase {
  final EducationRepository repository;
  GetEducationsUseCase(this.repository);
  Future<List<EducationEntity>> call() => repository.getEducations();
}

class AddEducationUseCase {
  final EducationRepository repository;
  AddEducationUseCase(this.repository);
  Future<void> call(EducationEntity education) =>
      repository.addEducation(education);
}

class UpdateEducationUseCase {
  final EducationRepository repository;
  UpdateEducationUseCase(this.repository);
  Future<void> call(EducationEntity education) =>
      repository.updateEducation(education);
}

class DeleteEducationUseCase {
  final EducationRepository repository;
  DeleteEducationUseCase(this.repository);
  Future<void> call(String id) => repository.deleteEducation(id);
}
