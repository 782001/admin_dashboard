import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/supabase_config.dart';

import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/auth_usecases.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

import 'features/projects/data/repositories/projects_repository_impl.dart';
import 'features/projects/domain/repositories/projects_repository.dart';
import 'features/projects/domain/usecases/projects_usecases.dart';
import 'features/projects/presentation/cubit/projects_cubit.dart';

import 'features/settings/data/repositories/settings_repository_impl.dart';
import 'features/settings/domain/repositories/settings_repository.dart';
import 'features/settings/domain/usecases/settings_usecases.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';

import 'features/skills/data/repositories/skills_repository_impl.dart';
import 'features/skills/domain/repositories/skills_repository.dart';
import 'features/skills/domain/usecases/skills_usecases.dart';
import 'features/skills/presentation/cubit/skills_cubit.dart';

import 'features/experience/data/repositories/experience_repository_impl.dart';
import 'features/experience/domain/repositories/experience_repository.dart';
import 'features/experience/domain/usecases/experience_usecases.dart';
import 'features/experience/presentation/cubit/experience_cubit.dart';

import 'features/education/data/repositories/education_repository_impl.dart';
import 'features/education/domain/repositories/education_repository.dart';
import 'features/education/domain/usecases/education_usecases.dart';
import 'features/education/presentation/cubit/education_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton<SupabaseClient>(() => SupabaseConfig.client);

  // Features - Auth
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(supabaseClient: sl()),
  );
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerFactory(
    () => AuthCubit(
      getCurrentUserUseCase: sl(),
      signInUseCase: sl(),
      signOutUseCase: sl(),
    ),
  );

  // Features - Projects
  sl.registerLazySingleton<ProjectsRepository>(
    () => ProjectsRepositoryImpl(supabaseClient: sl()),
  );
  sl.registerLazySingleton(() => GetProjectsUseCase(sl()));
  sl.registerLazySingleton(() => AddProjectUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProjectUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProjectUseCase(sl()));
  sl.registerLazySingleton(() => UploadProjectImageUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProjectImageUseCase(sl()));
  sl.registerLazySingleton(() => UploadProjectLogoUseCase(sl()));

  sl.registerFactory(
    () => ProjectsCubit(
      getProjectsUseCase: sl(),
      addProjectUseCase: sl(),
      updateProjectUseCase: sl(),
      deleteProjectUseCase: sl(),
      uploadImageUseCase: sl(),
      deleteImageUseCase: sl(),
      uploadLogoUseCase: sl(),
    ),
  );

  // Features - Settings
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(supabaseClient: sl()),
  );
  sl.registerLazySingleton(() => GetSettingsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateSettingsUseCase(sl()));

  sl.registerFactory(
    () => SettingsCubit(getSettingsUseCase: sl(), updateSettingsUseCase: sl()),
  );

  // Features - Skills
  sl.registerLazySingleton<SkillsRepository>(
    () => SkillsRepositoryImpl(supabaseClient: sl()),
  );
  sl.registerLazySingleton(() => GetSkillsUseCase(sl()));
  sl.registerLazySingleton(() => AddSkillUseCase(sl()));
  sl.registerLazySingleton(() => UpdateSkillUseCase(sl()));
  sl.registerLazySingleton(() => DeleteSkillUseCase(sl()));

  sl.registerFactory(
    () => SkillsCubit(
      getSkillsUseCase: sl(),
      addSkillUseCase: sl(),
      updateSkillUseCase: sl(),
      deleteSkillUseCase: sl(),
    ),
  );

  // Features - Experience
  sl.registerLazySingleton<ExperienceRepository>(
    () => ExperienceRepositoryImpl(supabaseClient: sl()),
  );
  sl.registerLazySingleton(() => GetExperiencesUseCase(sl()));
  sl.registerLazySingleton(() => AddExperienceUseCase(sl()));
  sl.registerLazySingleton(() => UpdateExperienceUseCase(sl()));
  sl.registerLazySingleton(() => DeleteExperienceUseCase(sl()));

  sl.registerFactory(
    () => ExperienceCubit(
      getExperiencesUseCase: sl(),
      addExperienceUseCase: sl(),
      updateExperienceUseCase: sl(),
      deleteExperienceUseCase: sl(),
    ),
  );

  // Features - Education
  sl.registerLazySingleton<EducationRepository>(
    () => EducationRepositoryImpl(supabaseClient: sl()),
  );
  sl.registerLazySingleton(() => GetEducationsUseCase(sl()));
  sl.registerLazySingleton(() => AddEducationUseCase(sl()));
  sl.registerLazySingleton(() => UpdateEducationUseCase(sl()));
  sl.registerLazySingleton(() => DeleteEducationUseCase(sl()));

  sl.registerFactory(
    () => EducationCubit(
      getEducationsUseCase: sl(),
      addEducationUseCase: sl(),
      updateEducationUseCase: sl(),
      deleteEducationUseCase: sl(),
    ),
  );
}
