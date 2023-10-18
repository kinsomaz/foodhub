import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CloudStorage {
  Future<void> createNewProfile({
    required String ownerUserId,
    required String name,
    required String email,
  });
  FirebaseFirestore initialize();
  Future<void> storeVerificationCode({
    required String ownerUserId,
    required String verificationCode,
  });
  Future<String> readVerificationCode({
    required String ownerUserId,
  });
}
