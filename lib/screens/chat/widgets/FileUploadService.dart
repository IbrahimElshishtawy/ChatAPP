import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FileUploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  // اختيار صورة أو فيديو
  Future<XFile?> pickImageOrVideo() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    ); // أو استخدم ImageSource.camera للتصوير
    return pickedFile;
  }

  Future<String> uploadFile(File file, String fileName) async {
    try {
      final ref = _storage.ref().child('chat_files/$fileName');
      final uploadTask = await ref.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception("Error uploading file: $e");
    }
  }
}
