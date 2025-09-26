import 'package:flutter/material.dart';
import '../../../theme/theme.dart';

class ScanTextInput extends StatefulWidget {
  final TextEditingController controller;

  const ScanTextInput({super.key, required this.controller});

  @override
  State<ScanTextInput> createState() => ScanTextInputState();
}

class ScanTextInputState extends State<ScanTextInput> {
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

  @override
  void dispose() {
    widget.controller.removeListener(onTextChanged);
    focusNode.removeListener(moveScrollBotton);
    focusNode.dispose();
    super.dispose();
  }

  void moveScrollBotton() {
    if (focusNode.hasFocus) {
      Scrollable.ensureVisible(
        context,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
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
    return Stack(
      alignment: Alignment.topRight,
      children: [
        TextFormField(
          controller: widget.controller,
          focusNode: focusNode,
          maxLines: 4,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Paste suspicious message here...',
            hintStyle: TextStyle(color: Colors.grey[500]),
            filled: true,
            fillColor: Colors.white,
            border: AppComponents.inputBorder,
            enabledBorder: AppComponents.inputBorder,
            focusedBorder: AppComponents.inputFocusBorder,
            contentPadding: const EdgeInsets.fromLTRB(20, 20, 50, 20),
            suffixIcon: showClearButton
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey, size: 18),
                    onPressed: clearText,
                    splashRadius: 15,
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                  )
                : null,
          ),
          style: const TextStyle(fontSize: 16),
          textInputAction: TextInputAction.newline,
          onTapOutside: (_) => focusNode.unfocus(),
        ),
      ],
    );
  }
}
