import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CloudStorage {
  DocumentReference? profileRef;
  Future<void> createOrUpdateProfile({
    required String ownerUserId,
    required String name,
    required String email,
    required String phone,
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
