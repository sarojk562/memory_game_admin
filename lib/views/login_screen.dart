import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_memory_game/providers/user_data.dart';
import 'package:flutter_memory_game/utils/validators.dart';
import 'package:flutter_memory_game/views/mode_selection_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class StartGameScreen extends StatefulWidget {
  const StartGameScreen({Key? key}) : super(key: key);

  @override
  State<StartGameScreen> createState() => _StartGameScreenState();
}

class _StartGameScreenState extends State<StartGameScreen> {
  final TextEditingController _emailController = TextEditingController();

  void _handleEnter() {
    if (validateEmail(_emailController.text)) {
      Provider.of<UserData>(context, listen: false)
          .setUserEmail(_emailController.text);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ModeSelectionScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double maxWidth = screenSize.width * 0.6;
    final double maxHeight = screenSize.height * 0.5;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Memory Game"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(25),
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: LottieBuilder.asset("assets/brain_animation.json"),
            ),
          ),
          const SizedBox(height: 25),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(
                color: Color(0xFF755DC1),
                fontSize: 15,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  width: 1,
                  color: Color(0xFF837E93),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  width: 1,
                  color: Color(0xFF9F7BFF),
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: _handleEnter,
            child: const Text("Enter"),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
