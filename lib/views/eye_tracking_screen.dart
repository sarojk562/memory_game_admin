import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_memory_game/providers/user_data.dart';
import 'package:flutter_memory_game/utils/firestore.dart';

class EyeTrackingScreen extends StatefulWidget {
  const EyeTrackingScreen({Key? key}) : super(key: key);

  @override
  State<EyeTrackingScreen> createState() => _EyeTrackingScreenState();
}

class _EyeTrackingScreenState extends State<EyeTrackingScreen> {
  late CameraController _cameraController;
  bool _cameraReady = false;
  bool _isRecording = false;

  Timer? _focusTimer;
  int _step = 0;
  int _currentIndex = -1;

  /// The 5 positions: TL, TR, C, BL, BR
  final List<Alignment> _positions = const [
    Alignment(-0.9, -0.9), // 0: top-left
    Alignment( 0.9, -0.9), // 1: top-right
    Alignment( 0.0,  0.0), // 2: center
    Alignment(-0.9,  0.9), // 3: bottom-left
    Alignment( 0.9,  0.9), // 4: bottom-right
  ];

  /// Horizontal sequence: TL → TR → C → BL → BR
  final List<int> _horizontalSeq = [0, 1, 2, 3, 4];

  @override
  void initState() {
    super.initState();
    _initCamera().then((_) {
      // once camera is ready, kick off recording & focus sequence
      _handleRecording();
      _startFocusSequence();
    });
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        log('No cameras available');
        return;
      }
      final front = cameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      _cameraController = CameraController(front, ResolutionPreset.medium);
      await _cameraController.initialize();
      if (!mounted) return;
      setState(() => _cameraReady = true);
    } catch (e) {
      log('Camera init error: $e');
    }
  }

  void _startFocusSequence() {
    _focusTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (!mounted) return;
      if (_step < _horizontalSeq.length) {
        setState(() => _currentIndex = _horizontalSeq[_step]);
        _step++;
      } else {
        // end of sequence: stop & upload, then pop
        await _handleRecording();
        _focusTimer?.cancel();
        if (mounted) Navigator.of(context).pop();
      }
    });
  }

  Future<void> _handleRecording() async {
    try {
      final email = context.read<UserData>().playerEmail;
      if (_isRecording) {
        // stop & upload
        final XFile xFile = await _cameraController.stopVideoRecording();
        final file = File(xFile.path);
        final serverURL = await uploadVideo(file, email);
        log('Uploaded video to: $serverURL');
        setState(() => _isRecording = false);
      } else {
        // prepare & start
        await _cameraController.prepareForVideoRecording();
        await _cameraController.startVideoRecording();
        setState(() => _isRecording = true);
        log('Started recording eye-tracking');
      }
    } catch (e) {
      log('Recording error: $e');
    }
  }

  @override
  void dispose() {
    _focusTimer?.cancel();
    if (_cameraReady) {
      _cameraController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Eye-Tracking Training")),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Look at the red circle till it moves to the next one till the end.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Focus-point grid
                  Expanded(
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: Stack(
                          children: List.generate(_positions.length, (i) {
                            return Align(
                              alignment: _positions[i],
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border: i == _currentIndex
                                      ? Border.all(color: Colors.red, width: 3)
                                      : null,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                  // Camera preview
                  Expanded(
                    child: _cameraReady
                        ? CameraPreview(_cameraController)
                        : const Center(child: CircularProgressIndicator()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ElevatedButton(
            onPressed: () async {
              // if they hit close early, make sure we stop & upload
              if (_isRecording) await _handleRecording();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            child: const Text('Close'),
          ),
        ),
      ),
    );
  }
}
