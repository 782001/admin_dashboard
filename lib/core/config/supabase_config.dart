import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = String.fromEnvironment(
    'https://lezgzwhoqdpqhnljobsm.supabase.co',
    defaultValue: 'https://lezgzwhoqdpqhnljobsm.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imxlemd6d2hvcWRwcWhubGpvYnNtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIzMDAyMDYsImV4cCI6MjA4Nzg3NjIwNn0.kDWqBeDgpFkgCUPbAa7_wuXZtxvW0Go7qkru4dT90pk',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imxlemd6d2hvcWRwcWhubGpvYnNtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIzMDAyMDYsImV4cCI6MjA4Nzg3NjIwNn0.kDWqBeDgpFkgCUPbAa7_wuXZtxvW0Go7qkru4dT90pk',
  );

  static Future<void> initialize() async {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  }

  static SupabaseClient get client => Supabase.instance.client;
}
