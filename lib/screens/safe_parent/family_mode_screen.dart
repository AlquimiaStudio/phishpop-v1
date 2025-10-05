import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class FamilyModeScreen extends StatefulWidget {
  const FamilyModeScreen({super.key});

  @override
  State<FamilyModeScreen> createState() => _FamilyModeScreenState();
}

class _FamilyModeScreenState extends State<FamilyModeScreen> {
  final List<TrustedContact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final contacts = await loadTrustedContacts();
    setState(() {
      _contacts.clear();
      _contacts.addAll(contacts);
    });
  }

  Future<void> _saveContacts() async {
    await saveTrustedContacts(_contacts);
  }

  Future<void> _addOrEditContact({TrustedContact? contact, int? index}) async {
    await showDialog(
      context: context,
      builder: (context) => TrustedContactDialog(
        contact: contact,
        maxContacts: 3,
        currentCount: _contacts.length,
        onSave: (newContact) {
          setState(() {
            if (index != null) {
              _contacts[index] = newContact;
            } else {
              _contacts.add(newContact);
            }
          });
          _saveContacts();
        },
      ),
    );
  }

  Future<void> _deleteContact(int index) async {
    final confirmed = await DeleteConfirmationDialog.show(
      context,
      _contacts[index].name,
    );

    if (confirmed) {
      await deleteTrustedContact(_contacts, index);
      setState(() {});
    }
  }

  Future<void> _sendCallMeMessage(TrustedContact contact) async {
    await sendCallMeMessage(context, contact);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: getAppBackground(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: SecondaryAppbar(
          title: 'Family Mode',
          icon: Icons.family_restroom,
          returnScreen: HomeScreen(initialIndex: 3),
        ),
        body: Container(
          decoration: getBordersScreen(context),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  InfoHeaderMessage(
                    message:
                        'Add trusted contacts to quickly send "Call Me" messages when you need help.',
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _contacts.isEmpty
                        ? const EmptyContactsWidget()
                        : ListView.separated(
                            itemCount: _contacts.length,
                            separatorBuilder: (_, __) => Divider(
                              color: theme.colorScheme.outline.withValues(
                                alpha: 0.2,
                              ),
                            ),
                            itemBuilder: (context, index) {
                              final contact = _contacts[index];
                              return TrustedContactListItem(
                                contact: contact,
                                onEdit: () => _addOrEditContact(
                                  contact: contact,
                                  index: index,
                                ),
                                onDelete: () => _deleteContact(index),
                                onSendMessage: () =>
                                    _sendCallMeMessage(contact),
                              );
                            },
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add_circle_outline, size: 20),
                        label: const Text('Add Trusted Contact'),
                        onPressed: _contacts.length >= 3
                            ? null
                            : () => _addOrEditContact(),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
