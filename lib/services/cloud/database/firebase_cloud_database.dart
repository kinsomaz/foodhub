import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodhub/services/cloud/database/cloud_profile.dart';
import 'package:foodhub/services/cloud/database/cloud_database.dart';
import 'package:foodhub/services/cloud/database/cloud_database_constants.dart';
import 'package:foodhub/services/cloud/database/cloud_database_exception.dart';
import 'package:foodhub/views/foodhub/food_caregory.dart';

class FirebaseCloudDatabase implements CloudDatabase {
  static final FirebaseCloudDatabase _shared =
      FirebaseCloudDatabase._sharedInstances();
  FirebaseCloudDatabase._sharedInstances();
  factory FirebaseCloudDatabase() => _shared;

  @override
  Future<void> createNewProfile({
    required String ownerUserId,
    required String name,
    required String email,
    required String phone,
    required String state,
    required String city,
    required String street,
  }) async {
    final profile = initialize().collection('profile');
    await profile.add({
      ownerUserIdFieldName: ownerUserId,
      userNameFieldName: name,
      emailFieldName: email,
      phoneFieldName: phone,
      stateFieldName: state,
      cityFieldName: city,
      streetFieldName: street,
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
    final verificationDocs = await _getDocument(verificationDocsList);
    final verificationCodeMap = verificationDocs[0];
    final verificationCode = verificationCodeMap['verification_code'];
    return verificationCode;
  }

  @override
  Future<DocumentReference<Object?>?> getProfileRef({
    required String uid,
  }) async {
    final profile = initialize().collection('profile');
    QuerySnapshot querySnapshot =
        await profile.where(ownerUserIdFieldName, isEqualTo: uid).get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentReference documentReference = querySnapshot.docs[0].reference;
      return documentReference;
    } else {
      return null;
    }
  }

  @override
  Stream<List<CloudProfile>> userProfile({
    required String ownerUserId,
  }) {
    final profile = initialize().collection('profile');
    return profile
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) =>
            event.docs.map((doc) => CloudProfile.fromSnapshot(doc)).toList());
  }

  @override
  Stream<List<FoodCategory>> foodCategory() {
    final foodCategory = initialize().collection('foodCategory');
    final snapshot = foodCategory.snapshots();
    return snapshot.map((event) =>
        event.docs.map((doc) => FoodCategory.fromSnapshot(doc)).toList());
  }
}

Future<List<Map<String, dynamic>>> _getDocument(
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
