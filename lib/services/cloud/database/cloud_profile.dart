import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodhub/services/cloud/database/cloud_database_constants.dart';

class CloudProfile {
  final String ownerUserId;
  final String userName;
  final String userEmail;
  final String phoneNumber;
  final String profileImageUrl;
  final String state;
  final String city;
  final String street;
  final List<String> favouriteRestaurants;

  CloudProfile({
    required this.userName,
    required this.userEmail,
    required this.phoneNumber,
    required this.ownerUserId,
    required this.profileImageUrl,
    required this.state,
    required this.city,
    required this.street,
    required this.favouriteRestaurants,
  });

  CloudProfile.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : ownerUserId = snapshot.data()[ownerUserIdFieldName] ?? '',
        userName = snapshot.data()[userNameFieldName] ?? '',
        userEmail = snapshot.data()[emailFieldName] ?? '',
        phoneNumber = snapshot.data()[phoneFieldName] ?? '',
        profileImageUrl = snapshot.data()[profileImageUrlFieldName] ?? '',
        state = snapshot.data()[stateFieldName] ?? '',
        city = snapshot.data()[cityFieldName] ?? '',
        street = snapshot.data()[streetFieldName] ?? '',
        favouriteRestaurants =
            (snapshot.data()[favouriteRestaurantsFieldName] as List<dynamic>?)
                    ?.cast<String>() ??
                [];
}
