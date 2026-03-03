import '../entities/contact_entity.dart';

abstract class ContactRepository {
  Future<List<ContactEntity>> getContacts();
  Future<void> addContact(ContactEntity contact);
  Future<void> updateContact(ContactEntity contact);
  Future<void> deleteContact(String id);
}
