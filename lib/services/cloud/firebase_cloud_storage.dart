import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodhub/services/cloud/cloud_storage.dart';
import 'package:foodhub/services/cloud/cloud_storage_constants.dart';
import 'package:foodhub/services/cloud/cloud_storage_exception.dart';

class FirebaseCloudStorage extends CloudStorage {
  @override
  Future<void> createNewProfile({
    required String ownerUserId,
    required String name,
    required String email,
  }) async {
    final profile = initialize().collection('profile');
    await profile.add({
      ownerUserIdFieldName: ownerUserId,
      userNameFieldName: name,
      emailFieldName: email,
    });
  }

  @override
  FirebaseFirestore initialize() => FirebaseFirestore.instance;

  @override
  Future<void> storeVerificationCode({
    required String ownerUserId,
    required String verificationCode,
  }) async {
    final verification = initialize().collection('verificationCode');
    await verification.add({
      ownerUserIdFieldName: ownerUserId,
      verificationCodeFieldName: verificationCode,
    });
  }

  @override
  Future<String> readVerificationCode({
    required String ownerUserId,
  }) async {
    final verification = initialize().collection('verificationCode');
    final verificationDocsList = await verification
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .get()
        .then((event) => event.docs);
    final verificationDocs =
        await _listenToDocumentStream(verificationDocsList);
    final verificationCodeMap = verificationDocs[0];
    final verificationCode = verificationCodeMap['verification_code'];
    return verificationCode;
  }
}

Future<List<Map<String, dynamic>>> _listenToDocumentStream(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> snapshots) async {
  List<Map<String, dynamic>> verificationDocs = [];

  try {
    for (QueryDocumentSnapshot<Map<String, dynamic>> snapshot in snapshots) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data();
        verificationDocs.add(data);
      }
    }
    return verificationDocs;
  } catch (e) {
    throw ErrorListeningToDocumentStreamException();
  }
}
