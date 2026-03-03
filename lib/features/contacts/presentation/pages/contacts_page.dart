import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart' as di;
import '../../domain/entities/contact_entity.dart';
import '../cubit/contacts_cubit.dart';
import '../cubit/contacts_state.dart';
import '../widgets/contact_form_dialog.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ContactsCubit>()..loadContacts(),
      child: const ContactsView(),
    );
  }
}

class ContactsView extends StatelessWidget {
  const ContactsView({super.key});

  void _showContactDialog(
    BuildContext context, [
    ContactEntity? contact,
  ]) async {
    final cubit = context.read<ContactsCubit>();
    final result = await showDialog<ContactEntity>(
      context: context,
      builder: (context) => ContactFormDialog(contact: contact),
    );

    if (result != null) {
      if (contact == null) {
        cubit.addContact(result);
      } else {
        cubit.updateContact(result);
      }
    }
  }

  void _confirmDelete(BuildContext context, ContactEntity contact) {
    final cubit = context.read<ContactsCubit>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Contact'),
        content: Text('Are you sure you want to delete ${contact.platform}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              cubit.deleteContact(contact.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Information')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showContactDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Contact'),
      ),
      body: BlocConsumer<ContactsCubit, ContactsState>(
        listener: (context, state) {
          if (state is ContactsActionSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is ContactsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ContactsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ContactsLoaded) {
            final contacts = state.contacts;
            if (contacts.isEmpty) {
              return const Center(child: Text('No contact info found.'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Contact Details',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 24),
                      DataTable(
                        columns: const [
                          DataColumn(label: Text('Platform')),
                          DataColumn(label: Text('Value')),
                          DataColumn(label: Text('Order')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: contacts
                            .map(
                              (c) => DataRow(
                                cells: [
                                  DataCell(Text(c.platform)),
                                  DataCell(Text(c.value)),
                                  DataCell(Text(c.orderIndex.toString())),
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                          ),
                                          onPressed: () =>
                                              _showContactDialog(context, c),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () =>
                                              _confirmDelete(context, c),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(child: Text('Failed to load contacts'));
        },
      ),
    );
  }
}
