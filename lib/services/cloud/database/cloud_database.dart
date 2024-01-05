import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodhub/services/cloud/database/cloud_profile.dart';
import 'package:foodhub/views/foodhub/food_category.dart';
import 'package:foodhub/views/foodhub/menu_category.dart';
import 'package:foodhub/views/foodhub/menu_item.dart';
import 'package:foodhub/views/foodhub/restaurant.dart';

abstract class CloudDatabase {
  Future<void> createNewProfile({
    required String ownerUserId,
    required String name,
    required String email,
    required String phone,
    required String state,
    required String city,
    required String street,
  });
  FirebaseFirestore initialize();
  Future<void> storeVerificationCode({
    required String ownerUserId,
    required String verificationCode,
  });
  Future<String> readVerificationCode({
    required String ownerUserId,
  });
  Future<DocumentReference<Object?>?> getProfileRef({
    required String uid,
  });
  Stream<List<CloudProfile>> userProfile({
    required String ownerUserId,
  });
  Stream<List<FoodCategory>> foodCategory();
  Stream<List<Restaurant>?> featuredRestaurantsStream({
    required Stream<String?> foodCategoryNameStream,
  });
  Stream<List<MenuItem>> featuredMenuItem({
    required String restaurantName,
  });
  Stream<List<MenuCategory>> menuCategory({
    required String restaurantName,
  });
  Stream<List<MenuItem>?> menuItemsStream({
    required String restaurantName,
    required Stream<String?> menuCategoryNameStream,
  });
  Stream<List<Restaurant>?> searchForRestaurant({
    required Stream<String> searchTextStream,
  });
  Stream<List<MenuItem>?> searchForFoodItem({
    required Stream<String> searchTextStream,
  });
  Future<void> addOrRemoveFromFavourite({
    required Restaurant restaurant,
    required String userId,
  });
  Stream<void> isRestaurantFavourite({
    required Restaurant restaurant,
    required String userId,
  });

  Future<List<MenuItem>> getMenus(String documentId);
}
