import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/providers.dart';

class AuthEmailInput extends StatelessWidget {
  final FocusNode focusNode = FocusNode();
  AuthEmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    final inputEmailProvider = context.watch<EmailInputProvider>();

    return TextFormField(
      controller: inputEmailProvider.emailController,
      focusNode: focusNode,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => inputEmailProvider.emailValidation(value),
      onChanged: (_) => inputEmailProvider.onEmailchanged(),
      onTapOutside: (_) => focusNode.unfocus(),
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email address',
        prefixIcon: const Icon(Icons.email_outlined),
        suffixIcon: inputEmailProvider.showClearButton
            ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey, size: 18),
                onPressed: () => inputEmailProvider.clearEmail(),
                splashRadius: 15,
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              )
            : null,
        filled: true,
        fillColor: Colors.grey[100],
        border: inputEmailProvider.getBorder(),
        errorText: inputEmailProvider.emailErrorMessage,
      ),
    );
  }
}
