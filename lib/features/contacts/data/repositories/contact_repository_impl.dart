import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/contact_entity.dart';
import '../../domain/repositories/contact_repository.dart';

class ContactRepositoryImpl implements ContactRepository {
  final SupabaseClient supabaseClient;

  ContactRepositoryImpl({required this.supabaseClient});

  @override
  Future<List<ContactEntity>> getContacts() async {
    final response = await supabaseClient
        .from('contacts')
        .select()
        .order('order_index');
    return response
        .map<ContactEntity>(
          (e) => ContactEntity(
            id: e['id'],
            platform: e['platform'],
            value: e['value'],
            url: e['url'],
            orderIndex: e['order_index'] ?? 0,
          ),
        )
        .toList();
  }

  @override
  Future<void> addContact(ContactEntity contact) async {
    await supabaseClient.from('contacts').insert({
      'platform': contact.platform,
      'value': contact.value,
      'url': contact.url,
      'order_index': contact.orderIndex,
    });
  }

  @override
  Future<void> updateContact(ContactEntity contact) async {
    await supabaseClient
        .from('contacts')
        .update({
          'platform': contact.platform,
          'value': contact.value,
          'url': contact.url,
          'order_index': contact.orderIndex,
        })
        .eq('id', contact.id);
  }

  @override
  Future<void> deleteContact(String id) async {
    await supabaseClient.from('contacts').delete().eq('id', id);
  }
}
