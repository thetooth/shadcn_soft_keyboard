import 'package:flutter/material.dart';
import 'package:shadcn_soft_keyboard/src/utils/key_rows.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../utils/enums.dart';

class NumericKeyboard extends StatefulWidget {
  const NumericKeyboard({
    required this.controller,
    this.height = 260,
    this.backgroundColor = const Color(0xff0a0a0a),
    this.enterKeyIcon,
    this.backspaceKeyIcon,
    this.onEnterTapped,
    super.key,
  });

  /// The height of the keyboard
  final double height;

  /// The controller for the text field
  final TextEditingController controller;

  /// The color for the keyboard background
  final Color backgroundColor;

  /// The icon to show on enter key
  final IconData? enterKeyIcon;

  /// The icon to show on backspace key
  final IconData? backspaceKeyIcon;

  /// Callback Function for Enter Key
  final Function()? onEnterTapped;

  @override
  State<NumericKeyboard> createState() => _NumericKeyboardState();
}

class _NumericKeyboardState extends State<NumericKeyboard> {
  // Renders the keyboard rows
  Widget keyboardRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys
          .map(
            (e) => e == SpecialKey.space.name
                ? Expanded(child: actionKey(SpecialKey.space))
                : e.length > 1
                    ? actionKey(SpecialKey.values
                        .firstWhere((element) => element.name == e))
                    : numberKey(e),
          )
          .toList(),
    );
  }

  // Renders the number keys
  Widget numberKey(String kKey) {
    return ShadButton.secondary(
      width: MediaQuery.of(context).size.width / 4 - 12.5,
      height: 52,
      onPressed: () {
        widget.controller.text += kKey;
      },
      child: Text(
        kKey,
      ),
    );
  }

  // Renders the decimal key conditionally
  Widget decimalKey() {
    return ValueListenableBuilder(
        valueListenable: widget.controller,
        builder: (context, value, child) {
          return ShadButton.secondary(
            width: MediaQuery.of(context).size.width / 4 - 12.5,
            height: 52,
            enabled: (!widget.controller.text.contains(".") &&
                widget.controller.text.isNotEmpty),
            onPressed: () {
              widget.controller.text += '.';
            },
            child: const Text(
              '.',
            ),
          );
        });
  }

  // Returns the icon for the action keys
  Widget? getActionKeyIcon(SpecialKey key) {
    IconData iconData;
    Color iconColor = ShadTheme.of(context).colorScheme.primaryForeground;

    if (key == SpecialKey.backspace) {
      iconData = widget.backspaceKeyIcon ?? Icons.backspace_outlined;
    } else {
      iconData = widget.enterKeyIcon ?? Icons.keyboard_return;
    }

    return Icon(
      iconData,
      color: iconColor,
    );
  }

  // Renders the action keys
  Widget actionKey(SpecialKey kKey) {
    return ShadButton(
      width: MediaQuery.of(context).size.width / 4 - 12.5,
      height: 52,
      onLongPress: () {
        if (kKey == SpecialKey.backspace) {
          widget.controller.text = '';
        }
      },
      onPressed: () {
        if (kKey == SpecialKey.backspace) {
          if (widget.controller.text.isNotEmpty) {
            widget.controller.text = widget.controller.text
                .substring(0, widget.controller.text.length - 1);
          }
        } else if (kKey == SpecialKey.enter) {
          if (widget.onEnterTapped != null) {
            widget.onEnterTapped!();
          } else {
            widget.controller.text += '\n';
          }
        }
      },
      child: getActionKeyIcon(kKey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: widget.height,
      color: widget.backgroundColor,
      child: Wrap(
        children: List.generate(
          KeyRows.numericRow.length,
          (index) {
            // return KeyRows.numericRow[index] == SpecialKey.enter.name
            //     ? actionKey(SpecialKey.enter)
            //     : KeyRows.numericRow[index] == SpecialKey.backspace.name
            //         ? actionKey(SpecialKey.backspace)
            //         : numberKey(KeyRows.numericRow[index]);
            switch (KeyRows.numericRow[index]) {
              case 'enter':
                return actionKey(SpecialKey.enter);
              case 'backspace':
                return actionKey(SpecialKey.backspace);
              case '.':
                return decimalKey();
              default:
                return numberKey(KeyRows.numericRow[index]);
            }
          },
        ),
      ),
    );
  }
}
