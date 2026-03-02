import '../entities/skill_entity.dart';

abstract class SkillsRepository {
  Future<List<SkillEntity>> getSkills();
  Future<void> addSkill(SkillEntity skill);
  Future<void> updateSkill(SkillEntity skill);
  Future<void> deleteSkill(String id);
}
