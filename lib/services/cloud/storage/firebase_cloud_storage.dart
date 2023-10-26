import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:foodhub/services/cloud/storage/cloud_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseCloudStorage implements CloudStorage {
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstances();
  FirebaseCloudStorage._sharedInstances();
  factory FirebaseCloudStorage() => _shared;
  @override
  FirebaseStorage initialize() => FirebaseStorage.instance;

  @override
  Future<String> uploadProfileImage({
    required XFile pickedFile,
    required String userId,
  }) async {
    final Reference storageReference =
        initialize().ref().child('user_images/$userId/$userId.jpg');
    final UploadTask uploadTask =
        storageReference.putFile(File(pickedFile.path));
    await uploadTask.whenComplete(() => null);
    final imageURL = await storageReference.getDownloadURL();
    return imageURL;
  }
}
