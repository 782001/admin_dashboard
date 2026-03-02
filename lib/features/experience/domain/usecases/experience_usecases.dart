import '../entities/experience_entity.dart';
import '../repositories/experience_repository.dart';

class GetExperiencesUseCase {
  final ExperienceRepository repository;
  GetExperiencesUseCase(this.repository);
  Future<List<ExperienceEntity>> call() => repository.getExperiences();
}

class AddExperienceUseCase {
  final ExperienceRepository repository;
  AddExperienceUseCase(this.repository);
  Future<void> call(ExperienceEntity experience) =>
      repository.addExperience(experience);
}

class UpdateExperienceUseCase {
  final ExperienceRepository repository;
  UpdateExperienceUseCase(this.repository);
  Future<void> call(ExperienceEntity experience) =>
      repository.updateExperience(experience);
}

class DeleteExperienceUseCase {
  final ExperienceRepository repository;
  DeleteExperienceUseCase(this.repository);
  Future<void> call(String id) => repository.deleteExperience(id);
}
