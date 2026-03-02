import '../entities/education_entity.dart';

abstract class EducationRepository {
  Future<List<EducationEntity>> getEducations();
  Future<void> addEducation(EducationEntity education);
  Future<void> updateEducation(EducationEntity education);
  Future<void> deleteEducation(String id);
}
