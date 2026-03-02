import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/skill_entity.dart';
import '../../domain/repositories/skills_repository.dart';

class SkillsRepositoryImpl implements SkillsRepository {
  final SupabaseClient supabaseClient;

  SkillsRepositoryImpl({required this.supabaseClient});

  @override
  Future<List<SkillEntity>> getSkills() async {
    final response = await supabaseClient.from('skills').select().order('name');
    return response
        .map<SkillEntity>((e) => SkillEntity(id: e['id'], name: e['name']))
        .toList();
  }

  @override
  Future<void> addSkill(SkillEntity skill) async {
    await supabaseClient.from('skills').insert({'name': skill.name});
  }

  @override
  Future<void> updateSkill(SkillEntity skill) async {
    await supabaseClient
        .from('skills')
        .update({'name': skill.name})
        .eq('id', skill.id);
  }

  @override
  Future<void> deleteSkill(String id) async {
    await supabaseClient.from('skills').delete().eq('id', id);
  }
}
