import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

abstract class CloudStorage {
  FirebaseStorage initialize();
  Future<void> uploadProfileImage({
    required XFile pickedFile,
    required String userId,
  });
}
