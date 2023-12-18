import 'package:cloud_firestore/cloud_firestore.dart';

class FoodCategory {
  final String name;
  final String imageUrl;

  FoodCategory({
    required this.name,
    required this.imageUrl,
  });

  FoodCategory.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : name = snapshot.data()['name'] as String,
        imageUrl = snapshot.data()['imageUrl'];
}
