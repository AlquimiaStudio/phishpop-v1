import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class ScanUrlInput extends StatefulWidget {
  final TextEditingController controller;

  const ScanUrlInput({super.key, required this.controller});

  @override
  State<ScanUrlInput> createState() => ScanUrlInputState();
}

class ScanUrlInputState extends State<ScanUrlInput> {
  late FocusNode focusNode;
  bool showClearButton = false;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    showClearButton = widget.controller.text.isNotEmpty;
    widget.controller.addListener(onTextChanged);
    focusNode.addListener(moveScrollBotton);
  }

  void moveScrollBotton() {
    if (focusNode.hasFocus) {
      Scrollable.ensureVisible(
        context,
        duration: Duration(milliseconds: 100),
        curve: Curves.ease,
      );
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(onTextChanged);
    focusNode.removeListener(moveScrollBotton);
    focusNode.dispose();
    super.dispose();
  }

  void onTextChanged() {
    final hasText = widget.controller.text.isNotEmpty;
    if (hasText != showClearButton) {
      setState(() {
        showClearButton = hasText;
      });
    }
  }

  void clearText() {
    widget.controller.clear();
    setState(() {
      showClearButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: 'https://suspicious-website.com',
        hintStyle: TextStyle(color: Colors.grey[500]),
        filled: true,
        fillColor: Colors.white,
        border: AppComponents.inputBorder,
        enabledBorder: AppComponents.inputBorder,
        focusedBorder: AppComponents.inputFocusBorder,
        prefixIcon: const PrefixIcon(),
        suffixIcon: showClearButton
            ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey, size: 18),
                onPressed: clearText,
                splashRadius: 15,
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              )
            : null,
        contentPadding: const EdgeInsets.all(15),
      ),
      style: const TextStyle(fontSize: 16),
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.done,
      onTapOutside: (_) => focusNode.unfocus(),
    );
  }
}

class PrefixIcon extends StatelessWidget {
  const PrefixIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 10),
      child: Icon(Icons.language, color: Colors.grey[400]),
    );
  }
}
