import '../entities/contact_entity.dart';
import '../repositories/contact_repository.dart';

class GetContactsUseCase {
  final ContactRepository repository;
  GetContactsUseCase(this.repository);
  Future<List<ContactEntity>> call() => repository.getContacts();
}

class AddContactUseCase {
  final ContactRepository repository;
  AddContactUseCase(this.repository);
  Future<void> call(ContactEntity contact) => repository.addContact(contact);
}

class UpdateContactUseCase {
  final ContactRepository repository;
  UpdateContactUseCase(this.repository);
  Future<void> call(ContactEntity contact) => repository.updateContact(contact);
}

class DeleteContactUseCase {
  final ContactRepository repository;
  DeleteContactUseCase(this.repository);
  Future<void> call(String id) => repository.deleteContact(id);
}
