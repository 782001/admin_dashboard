import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/contact_entity.dart';
import '../../domain/usecases/contact_usecases.dart';
import 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  final GetContactsUseCase getContactsUseCase;
  final AddContactUseCase addContactUseCase;
  final UpdateContactUseCase updateContactUseCase;
  final DeleteContactUseCase deleteContactUseCase;

  ContactsCubit({
    required this.getContactsUseCase,
    required this.addContactUseCase,
    required this.updateContactUseCase,
    required this.deleteContactUseCase,
  }) : super(ContactsInitial());

  Future<void> loadContacts() async {
    emit(ContactsLoading());
    try {
      final contacts = await getContactsUseCase();
      emit(ContactsLoaded(contacts));
    } catch (e) {
      emit(ContactsError(e.toString()));
    }
  }

  Future<void> addContact(ContactEntity contact) async {
    emit(ContactsActionInProgress());
    try {
      await addContactUseCase(contact);
      emit(const ContactsActionSuccess('Contact added successfully'));
      await loadContacts();
    } catch (e) {
      emit(ContactsError(e.toString()));
    }
  }

  Future<void> updateContact(ContactEntity contact) async {
    emit(ContactsActionInProgress());
    try {
      await updateContactUseCase(contact);
      emit(const ContactsActionSuccess('Contact updated successfully'));
      await loadContacts();
    } catch (e) {
      emit(ContactsError(e.toString()));
    }
  }

  Future<void> deleteContact(String id) async {
    emit(ContactsActionInProgress());
    try {
      await deleteContactUseCase(id);
      emit(const ContactsActionSuccess('Contact deleted successfully'));
      await loadContacts();
    } catch (e) {
      emit(ContactsError(e.toString()));
    }
  }
}
