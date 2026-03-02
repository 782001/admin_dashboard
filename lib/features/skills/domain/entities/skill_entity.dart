import 'package:equatable/equatable.dart';

class SkillEntity extends Equatable {
  final String id;
  final String name;

  const SkillEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
