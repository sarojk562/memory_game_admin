import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class EyeTrackingScreen extends StatefulWidget {
  const EyeTrackingScreen({Key? key}) : super(key: key);

  @override
  State<EyeTrackingScreen> createState() => _EyeTrackingScreenState();
}

class _EyeTrackingScreenState extends State<EyeTrackingScreen> {
  late CameraController _cameraController;
  bool _cameraReady = false;

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
    _initCamera();
    _startFocusSequence();
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
    _focusTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) return;
      if (_step < _horizontalSeq.length) {
        setState(() => _currentIndex = _horizontalSeq[_step]);
        _step++;
      } else {
        _focusTimer?.cancel();
        Navigator.of(context).pop();
      }
    });
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Look at the red circle till it moves to the next one till the end.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),


          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      width: 300,
                      height: 300,
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

                Expanded(
                  child: _cameraReady
                      ? CameraPreview(_cameraController)
                      : const Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48), // full-width
            ),
            child: const Text('Close'),
          ),
        ),
      ),
    );
  }
}
