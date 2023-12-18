import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodhub/services/cloud/database/cloud_profile.dart';
import 'package:foodhub/views/foodhub/food_caregory.dart';

abstract class CloudDatabase {
  Future<void> createNewProfile({
    required String ownerUserId,
    required String name,
    required String email,
    required String phone,
    required String state,
    required String city,
    required String street,
  });
  FirebaseFirestore initialize();
  Future<void> storeVerificationCode({
    required String ownerUserId,
    required String verificationCode,
  });
  Future<String> readVerificationCode({
    required String ownerUserId,
  });
  Future<DocumentReference<Object?>?> getProfileRef({
    required String uid,
  });
  Stream<List<CloudProfile>> userProfile({
    required String ownerUserId,
  });
  Stream<List<FoodCategory>> foodCategory();
}
