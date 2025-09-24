import 'package:flutter/material.dart';

class ReportFormFields extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String selectedScamType;
  final TextEditingController descriptionController;
  final TextEditingController phoneNumberController;
  final Function(String?) onScamTypeChanged;

  const ReportFormFields({
    super.key,
    required this.formKey,
    required this.selectedScamType,
    required this.descriptionController,
    required this.phoneNumberController,
    required this.onScamTypeChanged,
  });

  static const List<String> scamTypes = [
    'Phone Call Scam',
    'Text Message Scam',
    'Email Scam',
    'Online/Website Scam',
    'Social Media Scam',
    'In-Person Scam',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Scam Type',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: selectedScamType.isEmpty ? null : selectedScamType,
            decoration: InputDecoration(
              hintText: 'Select scam type',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            items: scamTypes.map((type) {
              return DropdownMenuItem<String>(value: type, child: Text(type));
            }).toList(),
            onChanged: onScamTypeChanged,
            validator: (value) => value == null || value.isEmpty
                ? 'Please select a scam type'
                : null,
          ),
          const SizedBox(height: 24),
          Text(
            'Description',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(
              hintText:
                  'Describe what happened, including dates, times, and any details you remember...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            maxLines: 6,
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Please describe the scam incident'
                : null,
          ),
          const SizedBox(height: 24),
          Text(
            'Phone Number (Optional)',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: phoneNumberController,
            decoration: InputDecoration(
              hintText: 'Phone number used in the scam (if applicable)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }
}
