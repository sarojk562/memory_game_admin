import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_memory_game/model/data.dart';
import 'package:flutter_memory_game/providers/user_data.dart';
import 'package:flutter_memory_game/services/get_user_data.dart';
import 'package:flutter_memory_game/utils/firestore.dart';
import 'package:flutter_memory_game/views/game_over_screen.dart';
import 'package:provider/provider.dart';

class MyFlipCardGame extends StatefulWidget {
  const MyFlipCardGame({super.key});

  @override
  State<MyFlipCardGame> createState() => _MyFlipCardGameState();
}

class _MyFlipCardGameState extends State<MyFlipCardGame> {
  int _previousIndex = -1;
  int _time = 3;
  int gameDuration = -3;
  bool _flip = false;
  bool _start = false;
  bool _wait = false;
  bool _isFinished = false;
  Timer _timer = Timer(Duration.zero, () {});
  Timer _durationTimer = Timer(Duration.zero, () {});
  int _left = 0;
  Map<String, dynamic>? userData = {};
  List _data = [];
  List<bool> _cardFlips = [];
  List<GlobalKey<FlipCardState>> _cardStateKeys = [];

  //Camera
  bool _isLoading = true;
  bool _isRecording = false;

  late CameraController _cameraController;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        _time = (_time - 1);
      });
    });
  }

  void startDuration() {
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        gameDuration = (gameDuration + 1);
      });
    });
  }

  void startGameAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _start = true;
        _timer.cancel();
      });
    });
  }

  void initializeGameData(Map<String, dynamic>? userData) {
    if (userData != null) {
      log('${userData["user_level"]}');

      switch (userData['user_level']) {
        case 1:
          // Code for level 1
          imagePath = levelOneImagePath;
          _data = level1Images;
          break;
        case 2:
          // Code for level 2
          imagePath = levelTwoImagePath;
          _data = level2Images;
          break;
        case 3:
          // Code for level 3
          imagePath = levelThreeImagePath;
          _data = level3Images;
          break;
        default:
          // Code for other levels
          break;
      }
    } else {
      imagePath = levelOneImagePath;
      _data = createShuffledListFromImageSource();
    }

    _cardFlips = getInitialItemStateList();
    _cardStateKeys = createFlipCardStateKeysList();
    _time = 3;
    _left = (_data.length ~/ 2);
    _isFinished = false;
  }

  @override
  void initState() {
    super.initState();
    fetchUserDataAndInitializeGame();
  }

  Future<void> fetchUserDataAndInitializeGame() async {
    userData = await getUserData();
    log('Fetched userData: $userData');
    initializeGameData(userData);
    _initCamera();
    startTimer();
    startDuration();
    startGameAfterDelay();
  }

  @override
  void dispose() {
    super.dispose();
    _cameraController.dispose();
    _timer.cancel();
    _durationTimer.cancel();
  }

  _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);
    _cameraController = CameraController(front, ResolutionPreset.max);
    await _cameraController.initialize();
    setState(() => _isLoading = false);
    _handleRecording();
  }

  void _recordVideo() async {
    log('_recordVideo');
    try {
      final String? email = context.read<UserData>().playerEmail;
      log('$email');
      if (_isRecording) {
        log('_recordVideo email');
        final XFile xFile = await _cameraController.stopVideoRecording();
        final File file = File(xFile.path);
        final serverURL = await uploadVideo(file, email);
        log('serverURL');
        log(serverURL);
        setState(() => _isRecording = false);
      } else {
        log('_recordVideo else');

        await _cameraController.prepareForVideoRecording();
        await _cameraController.startVideoRecording();
        setState(() => _isRecording = true);
      }
    } catch (e) {
      log('$e');
    }
  }

  void _handleFlip(int index) {
    if (!_flip) {
      _flip = true;
      _previousIndex = index;
    } else {
      _flip = false;
      if (_previousIndex != index) {
        if (_data[_previousIndex] != _data[index]) {
          _wait = true;

          Future.delayed(const Duration(milliseconds: 1500), () {
            _cardStateKeys[_previousIndex].currentState!.toggleCard();
            _previousIndex = index;
            _cardStateKeys[_previousIndex].currentState!.toggleCard();

            Future.delayed(const Duration(milliseconds: 160), () {
              setState(() {
                _wait = false;
              });
            });
          });
        } else {
          _cardFlips[_previousIndex] = false;
          _cardFlips[index] = false;
          debugPrint("$_cardFlips");
          setState(() {
            _left -= 1;
          });
          if (_cardFlips.every((t) => t == false)) {
            _handleRecording();
            debugPrint("Won");
            Future.delayed(const Duration(milliseconds: 160), () {
              setState(() {
                _isFinished = true;
                _start = false;
              });
              _durationTimer.cancel();
            });
          }
        }
      }
    }
    setState(() {});
  }

  Future<void> _handleRecording() async {
    try {
      _recordVideo();
    } catch (error) {
      log("Error recording video: $error");
    }
  }

  Widget getItem(int index) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(_data[index])),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final level = userData?['user_level'] ?? 1;

    return _isFinished
        ? GameOverScreen(
            duration: gameDuration,
          )
        : Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              text: "level: $level",
                              style: theme.bodyLarge,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: [
                                Text(
                                  'Remaining: $_left',
                                  style: theme.bodyMedium,
                                ),
                                Text(
                                  'Duration: ${gameDuration}s',
                                  style: theme.bodyMedium,
                                ),
                                Text(
                                  'Countdown: $_time',
                                  style: theme.bodyMedium,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          GridView.builder(
                            padding: const EdgeInsets.all(8),
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                            ),
                            itemBuilder: (context, index) => _start
                                ? FlipCard(
                                    key: _cardStateKeys[index],
                                    onFlip: () {
                                      _handleFlip(index);
                                    },
                                    flipOnTouch:
                                        _wait ? false : _cardFlips[index],
                                    direction: FlipDirection.HORIZONTAL,
                                    front: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        image: const DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                            "assets/images/image_cover.jpg",
                                          ),
                                        ),
                                      ),
                                      margin: const EdgeInsets.all(4.0),
                                    ),
                                    back: getItem(index))
                                : getItem(index),
                            itemCount: _data.length,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            _isLoading
                                ? Container(
                                    color: Colors.white,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : CameraPreview(_cameraController),
                          ]),
                    )),
                  ],
                ),
              ),
            ),
          );
  }
}
