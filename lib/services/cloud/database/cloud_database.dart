import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodhub/services/cloud/database/cloud_profile.dart';
import 'package:foodhub/views/foodhub/food_category.dart';
import 'package:foodhub/views/foodhub/menu_category.dart';
import 'package:foodhub/views/foodhub/menu_extra.dart';
import 'package:foodhub/views/foodhub/menu_item.dart';
import 'package:foodhub/views/foodhub/order_item.dart';
import 'package:foodhub/views/foodhub/restaurant.dart';
import 'package:foodhub/views/payment/card_information.dart';

abstract class CloudDatabase {
  Future<void> createNewProfile({
    required String ownerUserId,
    required String name,
    required String email,
    required String phone,
    required String state,
    required String city,
    required String street,
    required String profileUrl,
  });
  FirebaseFirestore initialize();
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
  Future<List<MenuItem>> getMenus(String documentId);
  Future<void> addOrRemoveFavouriteRestaurant({
    required Restaurant restaurant,
    required String userId,
  });
  Stream<bool> isRestaurantFavourite({
    required Restaurant restaurant,
    required String userId,
  });
  Future<void> addOrRemoveFavouriteFoodItem({
    required MenuItem menuItem,
    required String userId,
  });
  Stream<bool> isFoodItemFavourite({
    required MenuItem menuItem,
    required String userId,
  });
  Stream<List<MenuItem>?> favouriteMenuItem({
    required String userId,
  });
  Future<List<MenuItem>> getFavouriteMenus({
    required String documentId,
    required List<dynamic> itemNameList,
  });
  Stream<List<Restaurant>?> favouriteRestaurants({
    required String userId,
  });
  Stream<List<MenuItem>?> popularItemsStream();
  Future<List<MenuItem>> getPopularMenus({
    required String documentId,
  });

  Stream<List<MenuExtra>> getMenuExtras({
    required String menuName,
    required String restaurantName,
  });

  Future<void> addToCart({
    required String ownerUserId,
    required String restaurantName,
    required MenuItem menuItem,
    required int quatity,
    required Map<String, Map> extras,
  });

  Stream<dynamic> getRestaurantCartItems({
    required String ownerUserId,
    required String restaurantName,
  });

  Future<List<Map<String, dynamic>>> getAllCartItems({
    required String ownerUserId,
  });

  Future<void> addToItemQuantityInCart({
    required Map item,
  });
  Future<void> subFromItemQuantityInCart({
    required Map item,
  });
  Future<void> deleteItemFromCart({
    required Map item,
  });
  Future<void> setRestaurantFee({
    required String restaurantName,
    required String userId,
  });
  Stream<Map> getRestaurantFeeForCart({
    required Stream<String> restaurantNameStream,
    required String userId,
  });
  Stream<Map> getRestaurantFee({
    required String restaurantName,
    required String userId,
  });
  Future<void> addNewCard({
    required String nameOnCard,
    required String userId,
    required String cardNumber,
    required String cvv,
    required String expiryMonth,
    required String expiryYear,
    required String displayName,
  });
  Stream<List?> getAllCards({
    required String userId,
  });
  Future<CardInformation> getCardInformation({
    required String userId,
    required String lastFourDigit,
  });
  Future<void> placeNewOrder({
    required String userId,
    required String restaurantName,
    required String restaurantLogo,
    required bool isRestaurantVerified,
    required String orderedTime,
    required String totalPrice,
    required String numberOfItems,
    required List<Map> menuItems,
  });
  Stream<List<OrderItem>?> getAllPlacedOrder({
    required String userId,
  });
  Stream<List<OrderItem>?> getUpcomingOrder({
    required String userId,
  });
  Future<Restaurant> getRestaurant({
    required String restaurantName,
  });
}
