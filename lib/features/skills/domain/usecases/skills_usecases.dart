import '../entities/skill_entity.dart';
import '../repositories/skills_repository.dart';

class GetSkillsUseCase {
  final SkillsRepository repository;
  GetSkillsUseCase(this.repository);
  Future<List<SkillEntity>> call() => repository.getSkills();
}

class AddSkillUseCase {
  final SkillsRepository repository;
  AddSkillUseCase(this.repository);
  Future<void> call(SkillEntity skill) => repository.addSkill(skill);
}

class UpdateSkillUseCase {
  final SkillsRepository repository;
  UpdateSkillUseCase(this.repository);
  Future<void> call(SkillEntity skill) => repository.updateSkill(skill);
}

class DeleteSkillUseCase {
  final SkillsRepository repository;
  DeleteSkillUseCase(this.repository);
  Future<void> call(String id) => repository.deleteSkill(id);
}
