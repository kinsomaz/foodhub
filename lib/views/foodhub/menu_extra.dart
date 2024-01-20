class MenuExtra {
  final String title;
  final String choose;
  final List<Map<String, dynamic>> item;

  MenuExtra({
    required this.title,
    required this.choose,
    required this.item,
  });

  MenuExtra.fromSnapshot(Map<String, dynamic> snapshot)
      : title = snapshot['title'],
        choose = snapshot['choose'],
        item = List<Map<String, dynamic>>.from(snapshot['item'] ?? []);
}
