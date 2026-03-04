import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SupabaseClient supabaseClient;

  SettingsRepositoryImpl({required this.supabaseClient});

  @override
  Future<SettingsEntity> getSettings() async {
    final response = await supabaseClient
        .from('settings')
        .select()
        .limit(1)
        .maybeSingle();

    if (response == null) {
      throw Exception('Settings not found');
    }

    return SettingsEntity(
      id: response['id'],
      fullName: response['full_name'],
      title: response['title'],
      summary: response['summary'],
      location: response['location'],
      profileImageUrl: response['profile_image_url'],
      cvUrl: response['cv_url'],
    );
  }

  @override
  Future<void> updateSettings(SettingsEntity settings) async {
    await supabaseClient
        .from('settings')
        .update({
          'full_name': settings.fullName,
          'title': settings.title,
          'summary': settings.summary,
          'location': settings.location,
          'profile_image_url': settings.profileImageUrl,
          'cv_url': settings.cvUrl,
        })
        .eq('id', settings.id);
  }
}
