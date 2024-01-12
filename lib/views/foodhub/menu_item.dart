import 'package:cloud_firestore/cloud_firestore.dart';

class MenuItem {
  final String name;
  final String imageUrl;
  final String price;
  final String ingredients;
  final String category;
  final String tag;
  final String description;

  MenuItem({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.ingredients,
    required this.category,
    required this.tag,
    required this.description,
  });

  MenuItem.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : name = snapshot.data()['name'] ?? '',
        imageUrl = snapshot.data()['imageUrl'] ?? '',
        price = snapshot.data()['price'] ?? '',
        ingredients = snapshot.data()['ingredients'] ?? '',
        category = snapshot.data()['category'] ?? '',
        tag = snapshot.data()['tag'] ?? '',
        description = snapshot.data()['description'] ?? '';
}
