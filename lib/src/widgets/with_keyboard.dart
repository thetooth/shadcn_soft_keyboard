import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shadcn_soft_keyboard/shadcn_soft_keyboard.dart';

class KeyboardController extends ChangeNotifier {
  late bool _isVisible = false;
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late bool _isNumeric = false;

  bool get isVisible => _isVisible;
  bool get isNumeric => _isNumeric;

  void show({
    required TextEditingController controller,
    required FocusNode focusNode,
    bool isNumeric = false,
  }) {
    _isVisible = true;
    _controller = controller;
    _focusNode = focusNode;
    _isNumeric = isNumeric;
    notifyListeners();
  }

  void hide() {
    _isVisible = false;
    _focusNode.unfocus();
    notifyListeners();
  }
}

class KeyboardControllerProvider extends InheritedWidget {
  final KeyboardController controller;

  const KeyboardControllerProvider({
    super.key,
    required this.controller,
    required super.child,
  });

  static KeyboardController of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<KeyboardControllerProvider>();
    assert(provider != null, 'No KeyboardControllerProvider found in context');
    return provider!.controller;
  }

  @override
  bool updateShouldNotify(KeyboardControllerProvider oldWidget) =>
      controller != oldWidget.controller;
}

class WithKeyboard extends StatefulWidget {
  const WithKeyboard({
    super.key,
    required this.controller,
    required this.child,
  });

  final KeyboardController controller;
  final Widget child;

  @override
  State<WithKeyboard> createState() => _WithKeyboardState();

  /// Use this to access the controller from context
  static KeyboardController of(BuildContext context) {
    return KeyboardControllerProvider.of(context);
  }
}

class _WithKeyboardState extends State<WithKeyboard> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerUpdate);
  }

  @override
  void didUpdateWidget(covariant WithKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerUpdate);
      widget.controller.addListener(_onControllerUpdate);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerUpdate);
    super.dispose();
  }

  void _onControllerUpdate() {
    if (widget.controller.isVisible) {
      widget.controller._focusNode.requestFocus();
    } else {
      widget.controller._focusNode.unfocus();
    }
    setState(() {}); // Trigger rebuild on change
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardControllerProvider(
      controller: widget.controller,
      child: Stack(
        children: [
          widget.child,
          if (widget.controller.isVisible) buildKeyboard(),
        ],
      ),
    );
  }

  Widget buildKeyboard() {
    return Container(
      color: ShadTheme.of(context).colorScheme.background,
      child: Column(
        children: [
          ShadInput(
            controller: widget.controller._controller,
            focusNode: widget.controller._focusNode,
            readOnly: true,
          ),
          const SizedBox(height: 5),
          Expanded(
            child: widget.controller._isNumeric
                ? buildNumericKeyboard(context)
                : buildAlphaNumericKeyboard(context),
          ),
        ],
      ),
    );
  }

  Widget buildNumericKeyboard(BuildContext context) {
    return NumericKeyboard(
      controller: widget.controller._controller,
      onEnterTapped: () {
        widget.controller.hide();
      },
      backgroundColor: ShadTheme.of(context).colorScheme.background,
      backspaceKeyIcon: LucideIcons.delete,
      enterKeyIcon: LucideIcons.cornerDownLeft,
    );
  }

  Widget buildAlphaNumericKeyboard(BuildContext context) {
    return AlphanumericKeyboard(
      controller: widget.controller._controller,
      onEnterTapped: () {
        widget.controller.hide();
      },
      backgroundColor: ShadTheme.of(context).colorScheme.background,
      backspaceKeyIcon: LucideIcons.delete,
      enterKeyIcon: LucideIcons.cornerDownLeft,
      capsLockKeyIcon: LucideIcons.arrowBigUp,
      capsUnlockKeyIcon: LucideIcons.arrowBigUp,
      symbolsKeyIcon: LucideIcons.atSign,
      alphabetKeyIcon: LucideIcons.aLargeSmall,
    );
  }
}
