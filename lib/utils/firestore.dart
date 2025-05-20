import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadVideo(File videoFile, String? email, bool trainingVideo) async {
  try {
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String fileName = '$email/$timestamp.mp4';
    if (trainingVideo) {
      fileName = '$email/$timestamp' + '_training.mp4';
    }
    Reference storageRef = FirebaseStorage.instance.ref().child(fileName);

    await storageRef.putFile(videoFile);
    return await storageRef.getDownloadURL();
  } catch (error) {
    return '';
  }
}
