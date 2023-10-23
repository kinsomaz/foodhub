import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodhub/services/cloud/cloud_storage_constants.dart';

class CloudProfile {
  final String ownerUserId;
  final String userName;
  final String userEmail;
  final String phoneNumber;

  CloudProfile({
    required this.userName,
    required this.userEmail,
    required this.phoneNumber,
    required this.ownerUserId,
  });

  CloudProfile.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : ownerUserId = snapshot.data()[ownerUserIdFieldName],
        userName = snapshot.data()[userNameFieldName],
        userEmail = snapshot.data()[emailFieldName],
        phoneNumber = snapshot.data()[phoneFieldName];
}
