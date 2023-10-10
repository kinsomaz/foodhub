import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodhub/services/cloud/cloud_storage_constants.dart';

class FirebaseCloudStorage {
  final profile = FirebaseFirestore.instance.collection('profile');

  Future<void> createNewProfile({
    required String ownerUserId,
    required String name,
    required String email,
  }) async {
    await profile.add({
      ownerUserIdFieldName: ownerUserId,
      userNameFieldName: name,
      emailFieldName: email,
    });
  }
}
