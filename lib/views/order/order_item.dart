class OrderItem {
  final String restaurantName;
  final String restaurantLogo;
  final bool restaurantIsVerified;
  final String orderedTime;
  final String totalPrice;
  final String itemsCount;
  final List<Map> menuItems;

  OrderItem({
    required this.restaurantName,
    required this.restaurantLogo,
    required this.restaurantIsVerified,
    required this.orderedTime,
    required this.totalPrice,
    required this.itemsCount,
    required this.menuItems,
  });

  OrderItem.fromDatabase(Map<String, dynamic> data)
      : restaurantName = data['restaurant_name'],
        restaurantLogo = data['restaurant_logo'],
        restaurantIsVerified = data['restaurant_is_verified'],
        orderedTime = data['ordered_time'],
        totalPrice = data['total_price'],
        itemsCount = data['number_of_items'],
        menuItems = List<Map<String, dynamic>>.from(data['menu_items'] ?? []);
}
