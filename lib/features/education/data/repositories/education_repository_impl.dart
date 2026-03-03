import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/education_entity.dart';
import '../../domain/repositories/education_repository.dart';

class EducationRepositoryImpl implements EducationRepository {
  final SupabaseClient supabaseClient;

  EducationRepositoryImpl({required this.supabaseClient});

  @override
  Future<List<EducationEntity>> getEducations() async {
    final response = await supabaseClient
        .from('education')
        .select()
        .order('order_index');
    return response
        .map<EducationEntity>(
          (e) => EducationEntity(
            id: e['id']?.toString() ?? '',
            degree: e['degree']?.toString() ?? '',
            institution: e['institution']?.toString() ?? '',
            startDate: e['start_year']?.toString() ?? '',
            endDate: e['end_year']?.toString(),
            orderIndex: e['order_index'] ?? 0,
          ),
        )
        .toList();
  }

  @override
  Future<void> addEducation(EducationEntity edu) async {
    await supabaseClient.from('education').insert({
      'degree': edu.degree,
      'institution': edu.institution,
      'start_year': edu.startDate,
      'end_year': edu.endDate,
      'order_index': edu.orderIndex,
    });
  }

  @override
  Future<void> updateEducation(EducationEntity edu) async {
    await supabaseClient
        .from('education')
        .update({
          'degree': edu.degree,
          'institution': edu.institution,
          'start_year': edu.startDate,
          'end_year': edu.endDate,
          'order_index': edu.orderIndex,
        })
        .eq('id', edu.id);
  }

  @override
  Future<void> deleteEducation(String id) async {
    await supabaseClient.from('education').delete().eq('id', id);
  }
}
