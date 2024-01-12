import 'package:cloud_firestore/cloud_firestore.dart';

class AddOn {
  final String name;
  final String image;
  final String price;

  AddOn({
    required this.name,
    required this.image,
    required this.price,
  });

  AddOn.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : name = snapshot.data()['name'] ?? '',
        image = snapshot.data()['image'] ?? '',
        price = snapshot.data()['price'] ?? '';
}
