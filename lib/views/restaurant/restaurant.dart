import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  final String name;
  final String imageUrl;
  final String logo;
  final bool isVerified;
  final String deliveryTime;
  final List<String> tags;

  Restaurant({
    required this.name,
    required this.imageUrl,
    required this.logo,
    required this.isVerified,
    required this.deliveryTime,
    required this.tags,
  });

  Restaurant.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : name = snapshot.data()['name'] ?? '',
        imageUrl = snapshot.data()['imageUrl'] ?? '',
        isVerified = snapshot.data()['isVerified'] ?? '',
        logo = snapshot.data()['logo'],
        deliveryTime = snapshot.data()['deliveryTime'] ?? '',
        tags = (snapshot.data()['tag'] as List<dynamic>?)?.cast<String>() ?? [];
}
