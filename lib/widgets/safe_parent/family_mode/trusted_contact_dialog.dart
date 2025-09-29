import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
import '../../../theme/theme.dart';
import '../../widgets.dart';

class TrustedContactDialog extends StatefulWidget {
  final TrustedContact? contact;
  final Function(TrustedContact) onSave;
  final int? maxContacts;
  final int? currentCount;

  const TrustedContactDialog({
    super.key,
    this.contact,
    required this.onSave,
    this.maxContacts,
    this.currentCount,
  });

  @override
  State<TrustedContactDialog> createState() => _TrustedContactDialogState();
}

class _TrustedContactDialogState extends State<TrustedContactDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final FocusNode nameFocusNode;
  late final FocusNode phoneFocusNode;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.contact?.name ?? '');
    phoneController = TextEditingController(text: widget.contact?.phone ?? '');
    nameFocusNode = FocusNode();
    phoneFocusNode = FocusNode();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    nameFocusNode.dispose();
    phoneFocusNode.dispose();
    super.dispose();
  }

  void handleSave() {
    if (formKey.currentState?.validate() ?? false) {
      if (widget.contact == null &&
          widget.maxContacts != null &&
          widget.currentCount != null &&
          widget.currentCount! >= widget.maxContacts!) {
        GlobalSnackBar.showError(
          context,
          'Maximum of ${widget.maxContacts} trusted contacts allowed.',
        );
        return;
      }

      final newContact = TrustedContact(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
      );

      widget.onSave(newContact);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.contact != null;
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isEditing
                          ? Icons.edit_outlined
                          : Icons.person_add_outlined,
                      color: AppColors.primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEditing ? 'Edit Contact' : 'Add Trusted Contact',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkText,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isEditing
                              ? 'Update contact information'
                              : 'Add a family member or friend you trust',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Form fields
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    // Name field
                    Text(
                      'Contact Name',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkText,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: nameController,
                      focusNode: nameFocusNode,
                      decoration: AppComponents.getTrustedContactDecoration(
                        'Enter full name',
                        Icons.person_outline,
                        10,
                      ),
                      onTapOutside: (event) => nameFocusNode.unfocus(),
                      validator: Validators.validateName,
                    ),
                    const SizedBox(height: 15),

                    // Phone field
                    Text(
                      'Phone Number',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkText,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: phoneController,
                      focusNode: phoneFocusNode,
                      keyboardType: TextInputType.phone,
                      decoration: AppComponents.getTrustedContactDecoration(
                        'Enter phone number',
                        Icons.phone_outlined,
                        10,
                      ),
                      validator: Validators.validatePhone,
                      onTapOutside: (event) => phoneFocusNode.unfocus(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        isEditing ? 'Save Changes' : 'Add Contact',

                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
