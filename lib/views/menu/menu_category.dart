import 'package:cloud_firestore/cloud_firestore.dart';

class MenuCategory {
  final String category;

  MenuCategory({
    required this.category,
  });

  MenuCategory.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : category = snapshot.data()['category'];
}
