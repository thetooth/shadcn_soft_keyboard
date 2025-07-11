import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../utils/enums.dart';
import '../utils/key_rows.dart';

class AlphanumericKeyboard extends StatefulWidget {
  const AlphanumericKeyboard({
    required this.controller,
    this.height = 260,
    this.backgroundColor = const Color(0xff0a0a0a),
    this.showSpaceKeyIcon = false,
    this.spaceKeyIcon,
    this.enterKeyIcon,
    this.backspaceKeyIcon,
    this.symbolsKeyIcon,
    this.alphabetKeyIcon,
    this.capsLockKeyIcon,
    this.capsUnlockKeyIcon,
    this.firstLetterCapitalizationColor = Colors.blue,
    this.onEnterTapped,
    super.key,
  });

  /// The height of the keyboard
  final double height;

  /// The controller for the text field
  final TextEditingController controller;

  /// The color for the keyboard background
  final Color backgroundColor;

  /// Whether to show the space key icon or not, default is false
  final bool showSpaceKeyIcon;

  /// The icon to show on space key
  final IconData? spaceKeyIcon;

  /// The icon to show on enter key
  final IconData? enterKeyIcon;

  /// The icon to show on backspace key
  final IconData? backspaceKeyIcon;

  /// The icon to show when alphabets tab is opened
  final IconData? symbolsKeyIcon;

  /// The icon to show when symbols tab is opened
  final IconData? alphabetKeyIcon;

  /// The icon to show when all caps is enabled
  final IconData? capsLockKeyIcon;

  /// The icon to show when all caps is disabled [lowerCase, onlyFirstLetter]
  final IconData? capsUnlockKeyIcon;

  /// The icon color when firstLetterCapitalization is enabled
  final Color firstLetterCapitalizationColor;

  /// Callback Function for Enter Key
  final Function()? onEnterTapped;

  @override
  State<AlphanumericKeyboard> createState() => _AlphanumericKeyboardState();
}

class _AlphanumericKeyboardState extends State<AlphanumericKeyboard> {
  Capitalization capitalization = Capitalization.onlyFirstLetter;

  KeyBoardType keyboardType = KeyBoardType.alphanumeric;

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
                    : keys[0] == '1'
                        ? numberKey(e)
                        : alphabetKey(e),
          )
          .toList(),
    );
  }

  // Renders the number keys
  Widget numberKey(String kKey) {
    return ShadButton.secondary(
      onPressed: () {
        widget.controller.text += kKey;
      },
      child: Text(
        kKey,
      ),
    );
  }

  // Renders the alphabet keys
  Widget alphabetKey(String kKey) {
    return ShadButton.secondary(
      onPressed: () {
        widget.controller.text += capitalization == Capitalization.lowerCase
            ? kKey.toLowerCase()
            : kKey;
        if (capitalization == Capitalization.onlyFirstLetter) {
          setState(() {
            capitalization = Capitalization.lowerCase;
          });
        }
      },
      child: Text(
        capitalization == Capitalization.lowerCase ? kKey.toLowerCase() : kKey,
      ),
    );
  }

  // Returns the icon for the action keys
  Widget? getActionKeyIcon(SpecialKey key) {
    IconData iconData;
    Color iconColor = ShadTheme.of(context).colorScheme.primaryForeground;

    if (key == SpecialKey.capsLock) {
      iconData = capitalization == Capitalization.upperCase
          ? widget.capsLockKeyIcon ?? Icons.arrow_circle_up
          : widget.capsUnlockKeyIcon ?? Icons.arrow_upward;

      if (capitalization == Capitalization.onlyFirstLetter) {
        iconColor = widget.firstLetterCapitalizationColor;
      }
    } else if (key == SpecialKey.backspace) {
      iconData = widget.backspaceKeyIcon ?? Icons.backspace_outlined;
    } else if (key == SpecialKey.space) {
      iconData = widget.spaceKeyIcon ?? Icons.space_bar;
      if (widget.showSpaceKeyIcon == false) {
        iconColor = ShadTheme.of(context).colorScheme.primary;
      }
    } else if (key == SpecialKey.enter) {
      iconData = widget.enterKeyIcon ?? Icons.keyboard_return;
    } else {
      iconData = keyboardType == KeyBoardType.alphanumeric
          ? widget.symbolsKeyIcon ?? Icons.emoji_symbols
          : widget.alphabetKeyIcon ?? Icons.abc;
    }

    return Icon(
      iconData,
      color: iconColor,
    );
  }

  // Renders the action keys
  Widget actionKey(SpecialKey kKey) {
    return ShadButton(
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
        } else if (kKey == SpecialKey.space) {
          widget.controller.text += ' ';
        } else if (kKey == SpecialKey.enter) {
          if (widget.onEnterTapped != null) {
            widget.onEnterTapped!();
          } else {
            widget.controller.text += '\n';
          }
        } else if (kKey == SpecialKey.capsLock) {
          setState(() {
            switch (capitalization) {
              case Capitalization.lowerCase:
                capitalization = Capitalization.onlyFirstLetter;
                break;
              case Capitalization.onlyFirstLetter:
                capitalization = Capitalization.upperCase;
                break;
              case Capitalization.upperCase:
                capitalization = Capitalization.lowerCase;
                break;
            }
          });
        } else if (kKey == SpecialKey.symbols) {
          setState(() {
            if (keyboardType == KeyBoardType.alphanumeric) {
              keyboardType = KeyBoardType.symbols;
            } else {
              keyboardType = KeyBoardType.alphanumeric;
            }
          });
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
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          keyboardRow(KeyRows.numbersRow),
          keyboardRow(keyboardType == KeyBoardType.alphanumeric
              ? KeyRows.alphabetsTopRow
              : KeyRows.symbolsTopRow),
          keyboardRow(keyboardType == KeyBoardType.alphanumeric
              ? KeyRows.alphabetsMiddleRow
              : KeyRows.symbolsMiddleRow),
          keyboardRow(keyboardType == KeyBoardType.alphanumeric
              ? KeyRows.alphabetsBottomRow
              : KeyRows.symbolsBottomRow),
          keyboardRow(KeyRows.lastRow),
        ],
      ),
    );
  }
}
