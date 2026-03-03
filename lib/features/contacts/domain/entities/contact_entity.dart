import 'package:equatable/equatable.dart';

class ContactEntity extends Equatable {
  final String id;
  final String platform;
  final String value;
  final String? url;
  final int orderIndex;

  const ContactEntity({
    required this.id,
    required this.platform,
    required this.value,
    this.url,
    required this.orderIndex,
  });

  @override
  List<Object?> get props => [id, platform, value, url, orderIndex];
}
