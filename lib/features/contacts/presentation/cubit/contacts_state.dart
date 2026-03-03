import 'package:equatable/equatable.dart';
import '../../domain/entities/contact_entity.dart';

abstract class ContactsState extends Equatable {
  const ContactsState();

  @override
  List<Object?> get props => [];
}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsLoaded extends ContactsState {
  final List<ContactEntity> contacts;
  const ContactsLoaded(this.contacts);

  @override
  List<Object?> get props => [contacts];
}

class ContactsError extends ContactsState {
  final String message;
  const ContactsError(this.message);

  @override
  List<Object?> get props => [message];
}

class ContactsActionInProgress extends ContactsState {}

class ContactsActionSuccess extends ContactsState {
  final String message;
  const ContactsActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
