import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/experience_entity.dart';
import '../../domain/repositories/experience_repository.dart';

class ExperienceRepositoryImpl implements ExperienceRepository {
  final SupabaseClient supabaseClient;

  ExperienceRepositoryImpl({required this.supabaseClient});

  @override
  Future<List<ExperienceEntity>> getExperiences() async {
    final response = await supabaseClient
        .from('experiences')
        .select()
        .order('start_date', ascending: false);
    return response
        .map<ExperienceEntity>(
          (e) => ExperienceEntity(
            id: e['id'],
            companyText:
                e['company_text'] ?? e['company_id']?.toString() ?? 'Company',
            role: e['role'],
            startDate: e['start_date'],
            endDate: e['end_date'],
          ),
        )
        .toList();
  }

  @override
  Future<void> addExperience(ExperienceEntity exp) async {
    await supabaseClient.from('experiences').insert({
      'company_text': exp.companyText,
      'role': exp.role,
      'start_date': exp.startDate,
      'end_date': exp.endDate,
    });
  }

  @override
  Future<void> updateExperience(ExperienceEntity exp) async {
    await supabaseClient
        .from('experiences')
        .update({
          'company_text': exp.companyText,
          'role': exp.role,
          'start_date': exp.startDate,
          'end_date': exp.endDate,
        })
        .eq('id', exp.id);
  }

  @override
  Future<void> deleteExperience(String id) async {
    await supabaseClient.from('experiences').delete().eq('id', id);
  }
}
