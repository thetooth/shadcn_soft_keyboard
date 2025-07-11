import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shadcn_soft_keyboard/shadcn_soft_keyboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Center(
              child: TextField(
                controller: _controller,
                readOnly: true,
              ),
            ),
          ),
          AlphanumericKeyboard(
            controller: _controller,
            onEnterTapped: () {
              log("hide keyboard");
            },
            height: 260,
            backgroundColor: Colors.black,
            backspaceKeyIcon: Icons.backspace,
            enterKeyIcon: Icons.keyboard_return,
          ),
          NumericKeyboard(
            controller: _controller,
            onEnterTapped: () {
              log("hide keyboard");
            },
            backgroundColor: Colors.black,
            backspaceKeyIcon: Icons.backspace,
            enterKeyIcon: Icons.keyboard_return,
          ),
        ],
      ),
    );
  }
}
