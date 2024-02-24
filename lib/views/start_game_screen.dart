import 'package:flutter/material.dart';
import 'package:flutter_memory_game/constants/values/strings.dart';
import 'package:flutter_memory_game/providers/user_data.dart';
import 'package:flutter_memory_game/utils/validators.dart';
import 'package:flutter_memory_game/views/game_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class StartGameScreen extends StatefulWidget {
  const StartGameScreen({Key? key}) : super(key: key);

  @override
  State<StartGameScreen> createState() => _StartGameScreenState();
}

class _StartGameScreenState extends State<StartGameScreen> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> handleStartGame() async {
    try {
      if (validateEmail(_emailController.text)) {
        Provider.of<UserData>(context, listen: false)
            .setUserEmail(_emailController.text);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyFlipCardGame(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid email address')),
        );
      }
    } on Exception catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    double maxWidth = screenSize.width * 0.6;
    double maxHeight = screenSize.height * 0.5;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Memory Game",
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(25),
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
              maxHeight: maxHeight,
            ),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: LottieBuilder.asset(
                "assets/brain_animation.json",
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          TextField(
            controller: _emailController,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
              color: Color(0xFF393939),
              fontSize: 13,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
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
          const SizedBox(
            height: 25,
          ),
          ElevatedButton(
            onPressed: () {
              handleStartGame();
            },
            child: const Text("Start Game"),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
