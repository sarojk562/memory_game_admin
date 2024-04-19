import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadVideo(File videoFile, String? email) async {
  try {
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String fileName = '$email/$timestamp.mp4';
    Reference storageRef = FirebaseStorage.instance.ref().child(fileName);

    await storageRef.putFile(videoFile);
    return await storageRef.getDownloadURL();
  } catch (error) {
    return '';
  }
}
