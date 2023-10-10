import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodhub/services/cloud/cloud_storage_constants.dart';

class CloudProfile {
  final String documentId;
  final String ownerUserId;
  final String userName;

  CloudProfile({
    required this.documentId,
    required this.ownerUserId,
    required this.userName,
  });

  CloudProfile.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        userName = snapshot.data()[userNameFieldName];
}
