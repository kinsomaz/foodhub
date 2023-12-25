import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  final String name;
  final String imageUrl;
  final bool isVerified;
  final String deliveryFee;
  final String deliveryTime;

  Restaurant({
    required this.name,
    required this.imageUrl,
    required this.isVerified,
    required this.deliveryFee,
    required this.deliveryTime,
  });

  Restaurant.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : name = snapshot.data()['name'] as String,
        imageUrl = snapshot.data()['imageUrl'],
        isVerified = snapshot.data()['isVerified'],
        deliveryFee = snapshot.data()['deliveryFee'],
        deliveryTime = snapshot.data()['deliveryTime'];
}
