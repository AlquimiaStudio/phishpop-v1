import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
import '../../../theme/theme.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            buildSectionHeader(
              context: context,
              icon: Icons.category_outlined,
              title: 'Scam Type',
              color: AppColors.primaryColor,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: selectedScamType.isEmpty ? null : selectedScamType,
              decoration: getReportBorders('Select scam type'),
              items: scamTypes.map((type) {
                return DropdownMenuItem<String>(value: type, child: Text(type));
              }).toList(),
              onChanged: onScamTypeChanged,
              validator: (value) => value == null || value.isEmpty
                  ? 'Please select a scam type'
                  : null,
            ),
            const SizedBox(height: 24),
            buildSectionHeader(
              context: context,
              icon: Icons.description_outlined,
              title: 'Description',
              color: AppColors.secondaryColor,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: descriptionController,
              decoration: getReportBorders(
                'Describe what happened, including dates, times, and any details you remember...',
              ),
              maxLines: 6,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Please describe the scam incident'
                  : null,
            ),
            const SizedBox(height: 24),
            buildSectionHeader(
              context: context,
              icon: Icons.phone_outlined,
              title: 'Phone Number (Optional)',
              color: AppColors.warningColor,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: phoneNumberController,
              decoration: getReportBorders(
                'Phone number used in the scam (if applicable)',
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget buildSectionHeader({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.darkText,
          ),
        ),
      ],
    );
  }

  InputDecoration getReportBorders(String description) {
    return InputDecoration(
      hintText: description,
      hintStyle: TextStyle(
        color: Colors.grey.shade600,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.primaryColor.withValues(alpha: 0.8),
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.dangerColor.withValues(alpha: 0.7),
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.dangerColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
