import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../../theme/theme.dart';
import 'emergency_contact_item.dart';

class EmergencyContactsSection extends StatefulWidget {
  const EmergencyContactsSection({super.key});

  @override
  State<EmergencyContactsSection> createState() =>
      _EmergencyContactsSectionState();
}

class _EmergencyContactsSectionState extends State<EmergencyContactsSection> {
  List<TrustedContact> contacts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final loadedContacts = await loadTrustedContacts();
    if (mounted) {
      setState(() {
        contacts = loadedContacts;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.secondaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.secondaryColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.warning_amber,
                  color: AppColors.secondaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Emergency Contacts',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Alert your trusted contacts about this threat',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.secondaryColor.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (contacts.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.lightText, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No emergency contacts configured. Add contacts in Family Mode settings.',
                    style: TextStyle(fontSize: 13, color: AppColors.mediumText),
                  ),
                ),
              ],
            ),
          )
        else
          ...contacts.map((contact) => EmergencyContactItem(contact: contact)),
      ],
    );
  }
}
