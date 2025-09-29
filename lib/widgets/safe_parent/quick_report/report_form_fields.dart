import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
import '../../../theme/theme.dart';

class ReportFormFields extends StatefulWidget {
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
  State<ReportFormFields> createState() => _ReportFormFieldsState();
}

class _ReportFormFieldsState extends State<ReportFormFields> {
  final FocusNode dropdownFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode phoneNumberFocusNode = FocusNode();

  @override
  void dispose() {
    dropdownFocusNode.dispose();
    descriptionFocusNode.dispose();
    phoneNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        dropdownFocusNode.unfocus();
        descriptionFocusNode.unfocus();
        phoneNumberFocusNode.unfocus();
      },
      child: Container(
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
          key: widget.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                initialValue: widget.selectedScamType.isEmpty
                    ? null
                    : widget.selectedScamType,
                decoration: AppComponents.getReportBorders('Select scam type'),
                focusNode: dropdownFocusNode,
                items: scamTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: widget.onScamTypeChanged,
                validator: Validators.validateScamType,
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
                controller: widget.descriptionController,
                focusNode: descriptionFocusNode,
                decoration: AppComponents.getReportBorders(
                  'Describe what happened, including dates, times, and any details you remember...',
                ),
                maxLines: 6,
                validator: Validators.validateDescription,
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
                controller: widget.phoneNumberController,
                focusNode: phoneNumberFocusNode,
                decoration: AppComponents.getReportBorders(
                  'Phone number used in the scam (if applicable)',
                ),
                keyboardType: TextInputType.phone,
                validator: Validators.validatePhone,
              ),
              const SizedBox(height: 12),
            ],
          ),
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
}
