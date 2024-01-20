import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodhub/services/cloud/database/cloud_profile.dart';
import 'package:foodhub/services/cloud/database/cloud_database.dart';
import 'package:foodhub/services/cloud/database/cloud_database_constants.dart';
import 'package:foodhub/services/cloud/database/cloud_database_exception.dart';
import 'package:foodhub/views/foodhub/food_category.dart';
import 'package:foodhub/views/foodhub/menu_category.dart';
import 'package:foodhub/views/foodhub/menu_extra.dart';
import 'package:foodhub/views/foodhub/menu_item.dart';
import 'package:foodhub/views/foodhub/restaurant.dart';

class FirebaseCloudDatabase implements CloudDatabase {
  static final FirebaseCloudDatabase _shared =
      FirebaseCloudDatabase._sharedInstances();
  FirebaseCloudDatabase._sharedInstances();
  factory FirebaseCloudDatabase() => _shared;

  @override
  Future<void> createNewProfile({
    required String ownerUserId,
    required String name,
    required String email,
    required String phone,
    required String state,
    required String city,
    required String street,
  }) async {
    final profile = initialize().collection('profile');
    await profile.add({
      ownerUserIdFieldName: ownerUserId,
      userNameFieldName: name,
      emailFieldName: email,
      phoneFieldName: phone,
      stateFieldName: state,
      cityFieldName: city,
      streetFieldName: street,
    });
  }

  @override
  FirebaseFirestore initialize() => FirebaseFirestore.instance;

  @override
  Future<void> storeVerificationCode({
    required String ownerUserId,
    required String verificationCode,
  }) async {
    final verification = initialize().collection('verificationCode');
    await verification.add({
      ownerUserIdFieldName: ownerUserId,
      verificationCodeFieldName: verificationCode,
    });
  }

  @override
  Future<String> readVerificationCode({
    required String ownerUserId,
  }) async {
    final verification = initialize().collection('verificationCode');
    final verificationDocsList = await verification
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .get()
        .then((event) => event.docs);
    final verificationDocs = await _getDocument(verificationDocsList);
    final verificationCodeMap = verificationDocs[0];
    final verificationCode = verificationCodeMap['verification_code'];
    return verificationCode;
  }

  @override
  Future<DocumentReference<Object?>?> getProfileRef({
    required String uid,
  }) async {
    final profile = initialize().collection('profile');
    QuerySnapshot querySnapshot =
        await profile.where(ownerUserIdFieldName, isEqualTo: uid).get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentReference documentReference = querySnapshot.docs[0].reference;
      return documentReference;
    } else {
      return null;
    }
  }

  @override
  Stream<List<CloudProfile>> userProfile({
    required String ownerUserId,
  }) {
    final profile = initialize().collection('profile');
    return profile
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) =>
            event.docs.map((doc) => CloudProfile.fromSnapshot(doc)).toList());
  }

  @override
  Stream<List<FoodCategory>> foodCategory() {
    final foodCategory = initialize().collection('foodCategory');
    final snapshot = foodCategory.snapshots();
    return snapshot.map((event) =>
        event.docs.map((doc) => FoodCategory.fromSnapshot(doc)).toList());
  }

  @override
  Stream<List<Restaurant>?> featuredRestaurantsStream({
    required Stream<String?> foodCategoryNameStream,
  }) async* {
    await for (var foodCategoryName in foodCategoryNameStream) {
      try {
        if (foodCategoryName == 'all') {
          final restaurantCollection =
              await initialize().collection('restaurant').get();
          final restaurants = restaurantCollection.docs
              .map((doc) => Restaurant.fromSnapshot(doc))
              .toList();
          yield restaurants;
        } else {
          final foodCategory = initialize().collection('foodCategory');
          final foodCategoryDocsList = await foodCategory
              .where('name', isEqualTo: foodCategoryName)
              .get()
              .then((event) => event.docs);
          DocumentSnapshot foodCategoryDoc = foodCategoryDocsList[0];
          final restaurantQuery =
              await foodCategoryDoc.reference.collection('restaurant').get();
          final restaurants = restaurantQuery.docs
              .map((doc) => Restaurant.fromSnapshot(doc))
              .toList();
          yield restaurants;
        }
      } catch (e) {
        throw ErrorFetchingFeaturedRestaurant();
      }
    }
  }

  @override
  Stream<List<MenuItem>> featuredMenuItem({
    required String restaurantName,
  }) {
    try {
      final restaurantQuery = initialize().collection('restaurant');
      return restaurantQuery
          .where('name', isEqualTo: restaurantName)
          .snapshots()
          .asyncMap((restaurantDocs) async {
        final restaurantDoc = restaurantDocs.docs[0];
        final menuCollection = restaurantDoc.reference.collection('menus');
        final featuredMenuItemQuery =
            await menuCollection.where('tag', isEqualTo: 'featured_item').get();

        List<MenuItem> featuredMenuItemList = featuredMenuItemQuery.docs
            .map((doc) => MenuItem.fromSnapshot(doc))
            .toList();

        return featuredMenuItemList;
      });
    } catch (e) {
      throw ErrorFetchingFeaturedMenuItem();
    }
  }

  @override
  Stream<List<MenuCategory>> menuCategory(
      {required String restaurantName}) async* {
    final restaurantQuery = initialize().collection('restaurant');
    final restaurantDocs =
        await restaurantQuery.where('name', isEqualTo: restaurantName).get();
    DocumentSnapshot restaurantDoc = restaurantDocs.docs[0];
    final menuCategoryQuery =
        restaurantDoc.reference.collection('menuCategory');
    final menuCategoryDocs = menuCategoryQuery.snapshots();
    final menuCategoryList = menuCategoryDocs.map((event) =>
        event.docs.map((doc) => MenuCategory.fromSnapshot(doc)).toList());
    yield* menuCategoryList;
  }

  @override
  Stream<List<MenuItem>?> menuItemsStream({
    required String restaurantName,
    required Stream<String?> menuCategoryNameStream,
  }) async* {
    await for (var menuCategoryName in menuCategoryNameStream) {
      try {
        final restaurantQuery = initialize().collection('restaurant');
        final restaurantDocs = await restaurantQuery
            .where('name', isEqualTo: restaurantName)
            .get()
            .then((event) => event.docs);
        DocumentSnapshot restaurantDoc = restaurantDocs[0];
        if (menuCategoryName == null || menuCategoryName == 'All') {
          final menuCollection = restaurantDoc.reference.collection('menus');
          final featuredMenuItemQuery = await menuCollection.get();
          final featuredMenuItem = featuredMenuItemQuery.docs
              .map((doc) => MenuItem.fromSnapshot(doc))
              .toList();
          yield featuredMenuItem;
        } else {
          final menuCollection = restaurantDoc.reference.collection('menus');
          final featuredMenuItemQuery = await menuCollection
              .where('category', isEqualTo: menuCategoryName)
              .get();
          final featuredMenuItem = featuredMenuItemQuery.docs
              .map((doc) => MenuItem.fromSnapshot(doc))
              .toList();
          yield featuredMenuItem;
        }
      } catch (e) {
        throw ErrorFetchingMenuItem();
      }
    }
  }

  @override
  Stream<List<Restaurant>?> searchForRestaurant({
    required Stream<String> searchTextStream,
  }) {
    return searchTextStream.asyncMap((String searchText) async {
      Set<String> uniqueRestaurantIds = {};
      List<Restaurant> resultList = [];

      QuerySnapshot<Map<String, dynamic>> foodCategoryQuery =
          await initialize().collection('foodCategory').get();

      QuerySnapshot<Map<String, dynamic>> restaurantQuery =
          await initialize().collection('restaurant').get();

      for (var mainDocument in foodCategoryQuery.docs) {
        if (_documentNameContainsText(mainDocument, searchText)) {
          QuerySnapshot<Map<String, dynamic>> restaurantQuery =
              await mainDocument.reference.collection('restaurant').get();

          List<Restaurant> restaurants = restaurantQuery.docs
              .map((doc) => Restaurant.fromSnapshot(doc))
              .toList();

          for (var restaurant in restaurants) {
            if (uniqueRestaurantIds.add(restaurant.name)) {
              resultList.add(restaurant);
            }
          }
        }
      }

      for (var mainDocument in restaurantQuery.docs) {
        if (_documentNameContainsText(mainDocument, searchText)) {
          Restaurant restaurant = Restaurant.fromSnapshot(mainDocument);
          if (uniqueRestaurantIds.add(restaurant.name)) {
            resultList.add(restaurant);
          }
        }
      }

      return resultList;
    });
  }

  @override
  Stream<List<MenuItem>?> searchForFoodItem({
    required Stream<String> searchTextStream,
  }) {
    return searchTextStream.asyncMap((String searchText) async {
      List<MenuItem> resultList = [];

      QuerySnapshot<Map<String, dynamic>> collectionSnapshot =
          await initialize().collection('restaurant').get();

      for (var document in collectionSnapshot.docs) {
        List<MenuItem> menuList = await getMenus(document.id);
        List<MenuItem> list = _containsSearchTextInMenus(menuList, searchText);
        resultList.addAll(list);
      }

      return resultList;
    });
  }

  @override
  Future<List<MenuItem>> getMenus(String documentId) async {
    QuerySnapshot<Map<String, dynamic>> menuSnapshot = await initialize()
        .collection('restaurant')
        .doc(documentId)
        .collection('menus')
        .get();

    return menuSnapshot.docs
        .map((menuDoc) => MenuItem.fromSnapshot(menuDoc))
        .toList();
  }

  @override
  Future<void> addOrRemoveFavouriteRestaurant({
    required Restaurant restaurant,
    required String userId,
  }) async {
    try {
      final userData = await initialize()
          .collection('profile')
          .where('user_id', isEqualTo: userId)
          .get();

      if (userData.docs.isNotEmpty) {
        final doc = userData.docs[0];
        final List<dynamic> favouriteRestaurants =
            (doc.data()['favouriteRestaurants'] as List<dynamic>?)
                    ?.cast<String>() ??
                [];

        if (favouriteRestaurants.contains(restaurant.name)) {
          await doc.reference.update({
            'favouriteRestaurants': FieldValue.arrayRemove([restaurant.name])
          });
        } else {
          await doc.reference.update({
            'favouriteRestaurants': FieldValue.arrayUnion([restaurant.name])
          });
        }
      }
    } catch (e) {
      throw ErrorUpdatingUsersFavourite();
    }
  }

  @override
  Stream<bool> isRestaurantFavourite({
    required Restaurant restaurant,
    required String userId,
  }) {
    return initialize()
        .collection('profile')
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .map((event) {
      final doc = event.docs[0];
      final List<dynamic> favouriteRestaurants =
          (doc.data()['favouriteRestaurants'] as List<dynamic>?)
                  ?.cast<String>() ??
              [];
      if (favouriteRestaurants.contains(restaurant.name)) {
        return true;
      } else {
        return false;
      }
    });
  }

  @override
  Future<void> addOrRemoveFavouriteFoodItem({
    required MenuItem menuItem,
    required String userId,
  }) async {
    try {
      final userData = await initialize()
          .collection('profile')
          .where('user_id', isEqualTo: userId)
          .get();

      if (userData.docs.isNotEmpty) {
        final doc = userData.docs[0];
        final List<dynamic> favouriteRestaurants =
            (doc.data()['favouriteFoodItems'] as List<dynamic>?)
                    ?.cast<String>() ??
                [];

        if (favouriteRestaurants.contains(menuItem.name)) {
          await doc.reference.update({
            'favouriteFoodItems': FieldValue.arrayRemove([menuItem.name])
          });
        } else {
          await doc.reference.update({
            'favouriteFoodItems': FieldValue.arrayUnion([menuItem.name])
          });
        }
      }
    } catch (e) {
      throw ErrorUpdatingUsersFavourite();
    }
  }

  @override
  Stream<bool> isFoodItemFavourite({
    required MenuItem menuItem,
    required String userId,
  }) {
    return initialize()
        .collection('profile')
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .map((event) {
      final doc = event.docs[0];
      final List<dynamic> favouriteFoodItem =
          (doc.data()['favouriteFoodItems'] as List<dynamic>?)
                  ?.cast<String>() ??
              [];
      if (favouriteFoodItem.contains(menuItem.name)) {
        return true;
      } else {
        return false;
      }
    });
  }

  @override
  Stream<List<MenuItem>> favouriteMenuItem({
    required String userId,
  }) {
    final profile = initialize().collection('profile');
    return profile
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .asyncMap((event) async {
      List<MenuItem> resultList = [];
      final profileDoc = event.docs[0];
      final List<dynamic> favouriteFoodItem =
          (profileDoc.data()['favouriteFoodItems'] as List<dynamic>?)
                  ?.cast<String>() ??
              [];
      QuerySnapshot<Map<String, dynamic>> restaurantSnapshot =
          await initialize().collection('restaurant').get();

      for (var document in restaurantSnapshot.docs) {
        List<MenuItem> menuList = await getFavouriteMenus(
          documentId: document.id,
          itemNameList: favouriteFoodItem,
        );
        resultList.addAll(menuList);
      }
      return resultList;
    });
  }

  @override
  Future<List<MenuItem>> getFavouriteMenus({
    required String documentId,
    required List itemNameList,
  }) async {
    QuerySnapshot<Map<String, dynamic>> menuSnapshot = await initialize()
        .collection('restaurant')
        .doc(documentId)
        .collection('menus')
        .where('name', whereIn: itemNameList)
        .get();

    return menuSnapshot.docs
        .map((menuDoc) => MenuItem.fromSnapshot(menuDoc))
        .toList();
  }

  @override
  Stream<List<Restaurant>?> favouriteRestaurants({
    required String userId,
  }) {
    final profile = initialize().collection('profile');
    return profile
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .asyncMap((event) async {
      final profileDoc = event.docs[0];
      final List<dynamic> favouriteRestaurants =
          (profileDoc.data()['favouriteRestaurants'] as List<dynamic>?)
                  ?.cast<String>() ??
              [];
      final restaurantCollection = await initialize()
          .collection('restaurant')
          .where('name', whereIn: favouriteRestaurants)
          .get();
      return restaurantCollection.docs
          .map((doc) => Restaurant.fromSnapshot(doc))
          .toList();
    });
  }

  @override
  Stream<List<MenuItem>?> popularItemsStream() {
    return initialize()
        .collection('restaurant')
        .snapshots()
        .asyncMap((event) async {
      List<MenuItem> resultList = [];
      final restaurantdocuments = event.docs;
      for (var document in restaurantdocuments) {
        List<MenuItem> menuList = await getPopularMenus(
          documentId: document.id,
        );
        resultList.addAll(menuList);
      }
      resultList.shuffle();
      return resultList;
    });
  }

  @override
  Future<List<MenuItem>> getPopularMenus({
    required String documentId,
  }) async {
    QuerySnapshot<Map<String, dynamic>> menuSnapshot = await initialize()
        .collection('restaurant')
        .doc(documentId)
        .collection('menus')
        .where('tag', isEqualTo: 'featured_item')
        .get();

    return menuSnapshot.docs
        .map((menuDoc) => MenuItem.fromSnapshot(menuDoc))
        .toList();
  }

  @override
  Stream<List<MenuExtra>> getMenuExtras({
    required String menuName,
    required String restaurantName,
  }) {
    return initialize()
        .collection('restaurant')
        .where('name', isEqualTo: restaurantName)
        .snapshots()
        .asyncMap((event) async {
      final restaurantDoc = event.docs[0];
      final menuCollection = await restaurantDoc.reference
          .collection('menus')
          .where('name', isEqualTo: menuName)
          .get();
      final menuDoc = menuCollection.docs[0];
      final extras = (menuDoc.data()['extras'] as List<dynamic>?) ?? [];
      return extras.map((extra) => MenuExtra.fromSnapshot(extra)).toList();
    });
  }

  @override
  Future<void> addToCart({
    required String ownerUserId,
    required String restaurantName,
    required MenuItem menuItem,
    required int quatity,
    required Map<String, Map> extras,
  }) async {
    final userCart = initialize().collection('userCart');
    await userCart.add({
      'user_id': ownerUserId,
      'name': restaurantName,
      'item': {
        'name': menuItem.name,
        'price': menuItem.price,
        'imageUrl': menuItem.imageUrl,
        'quatity': quatity,
      },
      'extra': extras,
    });
  }

  @override
  Stream<List<Map<String, dynamic>>?> getRestaurantCartItems({
    required String ownerUserId,
    required String restaurantName,
  }) {
    final userCart = initialize().collection('userCart');
    final userCartCollection = userCart
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .where('name', isEqualTo: restaurantName)
        .snapshots();

    return userCartCollection.map((event) {
      if (event.docs.isNotEmpty) {
        return event.docs.map((doc) => doc.data()).toList();
      } else {
        return null;
      }
    });
  }

  @override
  Future<void> addToItemQuantityInCart({required Map item}) async {
    final userCart = initialize().collection('userCart');
    final userCartCollection = await userCart
        .where('item', isEqualTo: item['item'])
        .where('extra', isEqualTo: item['extra'])
        .get();
    final doc = userCartCollection.docs[0];
    await doc.reference.update({'item.quatity': FieldValue.increment(1)});
  }

  @override
  Future<void> deleteItemFromCart({required Map item}) async {
    final userCart = initialize().collection('userCart');
    final userCartCollection = await userCart
        .where('item', isEqualTo: item['item'])
        .where('extra', isEqualTo: item['extra'])
        .get();
    final doc = userCartCollection.docs[0];
    await doc.reference.delete();
  }

  @override
  Future<void> subFromItemQuantityInCart({required Map item}) async {
    final userCart = initialize().collection('userCart');
    final userCartCollection = await userCart
        .where('item', isEqualTo: item['item'])
        .where('extra', isEqualTo: item['extra'])
        .get();
    final doc = userCartCollection.docs[0];
    if (doc.data()['item']['quatity'] > 1) {
      await doc.reference.update({'item.quatity': FieldValue.increment(-1)});
    }
    if (doc.data()['item']['quatity'] == 1) {
      await deleteItemFromCart(item: item);
    }
  }

  @override
  Future<void> setRestaurantFee({
    required String restaurantName,
    required String userId,
  }) async {
    final calculatedRestaurantFeeCollection =
        initialize().collection('calculatedRestaurantFee');
    final documentRef = calculatedRestaurantFeeCollection.doc(userId);
    final dataToSet = {
      restaurantName: {
        'taxAndFees': '3.5',
        'deliveryFee': '1.00',
      }
    };
    await documentRef.set(
      dataToSet,
      SetOptions(merge: true),
    );
  }

  @override
  Stream<Map> getRestaurantFee({
    required String restaurantName,
    required String userId,
  }) {
    final calculatedRestaurantFeeCollection =
        initialize().collection('calculatedRestaurantFee');
    return calculatedRestaurantFeeCollection
        .doc(userId)
        .snapshots()
        .asyncMap((event) {
      final restaurantData = event.data();
      final restaurantFee = restaurantData![restaurantName] as Map;
      return restaurantFee;
    });
  }
}

List<MenuItem> _containsSearchTextInMenus(
    List<MenuItem> menuList, String searchText) {
  // Check if any menu in the list contains the search text
  return menuList
      .where((menu) =>
          menu.name.toLowerCase().contains(searchText.toLowerCase()) ||
          menu.ingredients.toLowerCase().contains(searchText.toLowerCase()))
      .toList();
}

bool _documentNameContainsText(DocumentSnapshot document, String searchText) {
  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
  final value = data['name'];
  if (value.toString().toLowerCase().contains(searchText.toLowerCase())) {
    return true;
  }

  return false;
}

Future<List<Map<String, dynamic>>> _getDocument(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> snapshots) async {
  List<Map<String, dynamic>> verificationDocs = [];

  try {
    for (QueryDocumentSnapshot<Map<String, dynamic>> snapshot in snapshots) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data();
        verificationDocs.add(data);
      }
    }
    return verificationDocs;
  } catch (e) {
    throw ErrorListeningToDocumentStreamException();
  }
}
