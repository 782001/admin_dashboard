import '../entities/experience_entity.dart';

abstract class ExperienceRepository {
  Future<List<ExperienceEntity>> getExperiences();
  Future<void> addExperience(ExperienceEntity experience);
  Future<void> updateExperience(ExperienceEntity experience);
  Future<void> deleteExperience(String id);
}
