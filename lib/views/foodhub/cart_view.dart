import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodhub/services/auth/firebase_auth_provider.dart';
import 'package:foodhub/services/cloud/database/firebase_cloud_database.dart';
import 'package:foodhub/utilities/dialogs/remove_item_dialog.dart';
import 'package:foodhub/views/foodhub/cart_list_item.dart';
import 'package:foodhub/views/foodhub/restaurant.dart';
import 'package:rxdart/rxdart.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView>
    with SingleTickerProviderStateMixin {
  late final FirebaseCloudDatabase _cloudServices;
  late final FirebaseAuthProvider _authProvider;
  late final StreamController<List<Map>> _listOfItemsController;
  late final StreamController<double> _subTotalController;
  late final StreamController<double> _taxFeeController;
  late final StreamController<double> _deliveryController;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late final StreamController<String> _restaurantNameController;
  int quantity = 0;

  @override
  void initState() {
    _cloudServices = FirebaseCloudDatabase();
    _authProvider = FirebaseAuthProvider();
    _listOfItemsController = StreamController<List<Map>>.broadcast(
      onListen: () {
        _listOfItemsController.sink.add([]);
      },
    );
    _subTotalController = StreamController<double>.broadcast();
    _taxFeeController = StreamController<double>.broadcast();
    _deliveryController = StreamController<double>.broadcast();
    _controller = AnimationController(
      duration:
          const Duration(milliseconds: 900), // Adjust the duration as needed
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _restaurantNameController = StreamController<String>.broadcast();

    Future.delayed(const Duration(seconds: 1), () {
      _controller.forward();
    });

    super.initState();
  }

  Stream<double> _combineStreams() {
    return Rx.combineLatest3<double, double, double, double>(
      _subTotalController.stream,
      _taxFeeController.stream,
      _deliveryController.stream,
      (double subTotal, double taxFee, double delivery) {
        // Calculate the total by adding the three values
        return subTotal + taxFee + delivery;
      },
    );
  }

  String _reload(List<Map<String, dynamic>> items) {
    if (items.every((item) => item['name'] == items.first['name'])) {
      return items.first['name'];
    } else {
      return '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _listOfItemsController.close();
    _subTotalController.close();
    _taxFeeController.close();
    _deliveryController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    final restaurant = arguments[0] as Restaurant?;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(
                right: 9,
                left: 16,
                top: 10,
                bottom: 16,
              ),
              child: Container(
                height: screenHeight * 0.04,
                width: screenWidth * 0.08,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 1.5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      )
                    ]),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.015,
                  ),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: screenWidth * 0.05,
                  ),
                ),
              ),
            ),
            title: const Text(
              'Cart',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF111719)),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                StreamBuilder(
                  stream: _cloudServices.getRestaurantCartItems(
                    ownerUserId: _authProvider.currentUser!.uid,
                    restaurantName: restaurant?.name ?? '',
                  ),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case (ConnectionState.waiting):
                      case (ConnectionState.active):
                        if (snapshot.hasData) {
                          final items =
                              snapshot.data as List<Map<String, dynamic>>;
                          final restaurantName = _reload(items);
                          _restaurantNameController.add(restaurantName);
                          _listOfItemsController.add(items);
                          return CartListItem(
                            items: items,
                            onAdd: (item) async {
                              await _cloudServices.addToItemQuantityInCart(
                                item: item,
                              );
                            },
                            onSub: (item) async {
                              final quatity =
                                  int.parse(item['item']['quatity'].toString());
                              if (quatity == 1 && items.length == 1) {
                                final shouldRemove =
                                    await showRemoveItemDialog(context);
                                if (shouldRemove) {
                                  await _cloudServices
                                      .subFromItemQuantityInCart(
                                    item: item,
                                  );
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pop();
                                }
                              } else if (quatity == 1) {
                                final shouldRemove =
                                    await showRemoveItemDialog(context);
                                if (shouldRemove) {
                                  await _cloudServices
                                      .subFromItemQuantityInCart(
                                    item: item,
                                  );
                                }
                              } else {
                                await _cloudServices.subFromItemQuantityInCart(
                                  item: item,
                                );
                              }
                            },
                            onDelete: (item) async {
                              if (items.length == 1) {
                                final shouldRemove =
                                    await showRemoveItemDialog(context);
                                if (shouldRemove) {
                                  await _cloudServices.deleteItemFromCart(
                                    item: item,
                                  );
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pop();
                                }
                              } else {
                                final shouldRemove =
                                    await showRemoveItemDialog(context);
                                if (shouldRemove) {
                                  await _cloudServices.deleteItemFromCart(
                                    item: item,
                                  );
                                }
                              }
                            },
                          );
                        } else {
                          return const Center(
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      default:
                        return const Center(
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(),
                          ),
                        );
                    }
                  },
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Container(
                  height: 53,
                  width: screenWidth,
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    border: Border.all(
                      color: const Color(0xFFEEEEEE),
                    ),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 50,
                        width: 200,
                        padding: const EdgeInsets.only(left: 7),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            hintText: 'Promo Code',
                            hintStyle: TextStyle(
                              fontSize: screenWidth * 0.040,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFFBEBEBE),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: const Color(0xFFFE724C)),
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 10,
                            bottom: 10,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Apply',
                            style: TextStyle(
                                fontSize: screenWidth * 0.042,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFFFFFFFF)),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 40,
                      alignment: Alignment.centerLeft,
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Text(
                        'Subtotal',
                        style: TextStyle(
                          fontSize: screenWidth * 0.042,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        StreamBuilder(
                          stream: _listOfItemsController.stream,
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case (ConnectionState.active):
                                if (snapshot.hasData) {
                                  final data = snapshot.data;
                                  final listPrice = data!.map((menuItem) {
                                    final itemPrice = double.parse(
                                        menuItem['item']['price'].toString());
                                    final quatity = double.parse(
                                        menuItem['item']['quatity'].toString());
                                    double itemPriceToQuatity =
                                        itemPrice * quatity;
                                    final extras = menuItem['extra'] as Map;
                                    for (var key in extras.keys) {
                                      final extra = extras[key]['price'];
                                      double price =
                                          double.parse(extra.substring(2));
                                      itemPriceToQuatity += price * quatity;
                                    }
                                    return itemPriceToQuatity;
                                  }).toList();
                                  double totalPrice = 0.0;
                                  for (double price in listPrice) {
                                    totalPrice += price;
                                  }
                                  _subTotalController.add(totalPrice);
                                  return Text(
                                    '\$${totalPrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.042,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              default:
                                return Container();
                            }
                          },
                        ),
                        Container(
                          height: 40,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(
                            right: screenWidth * 0.05,
                            left: 5,
                          ),
                          child: Text(
                            'USD',
                            style: TextStyle(
                                fontSize: screenWidth * 0.036,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF9796A1)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  color: const Color(0xFFF1F2F3),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 40,
                      alignment: Alignment.centerLeft,
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Text(
                        'Tax and Fees',
                        style: TextStyle(
                          fontSize: screenWidth * 0.042,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        StreamBuilder(
                          stream: _cloudServices.getRestaurantFeeForCart(
                            restaurantNameStream:
                                _restaurantNameController.stream,
                            userId: _authProvider.currentUser!.uid,
                          ),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case (ConnectionState.waiting):
                              case (ConnectionState.active):
                                if (snapshot.hasData) {
                                  final data = snapshot.data as Map;
                                  if (data.isNotEmpty) {
                                    final amount =
                                        double.parse(data['taxAndFees']);
                                    _taxFeeController.add(amount);
                                    return Text(
                                      '\$${amount.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.042,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                } else {
                                  return Container();
                                }
                              default:
                                return Container();
                            }
                          },
                        ),
                        Container(
                          height: 40,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(
                            right: screenWidth * 0.05,
                            left: 5,
                          ),
                          child: Text(
                            'USD',
                            style: TextStyle(
                                fontSize: screenWidth * 0.036,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF9796A1)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  color: const Color(0xFFF1F2F3),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 40,
                      alignment: Alignment.centerLeft,
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Text(
                        'Delivery',
                        style: TextStyle(
                          fontSize: screenWidth * 0.042,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        StreamBuilder(
                          stream: _cloudServices.getRestaurantFeeForCart(
                            restaurantNameStream:
                                _restaurantNameController.stream,
                            userId: _authProvider.currentUser!.uid,
                          ),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case (ConnectionState.waiting):
                              case (ConnectionState.active):
                                if (snapshot.hasData) {
                                  final data = snapshot.data as Map;
                                  if (data.isNotEmpty) {
                                    final amount =
                                        double.parse(data['deliveryFee']);
                                    _deliveryController.add(amount);
                                    return Text(
                                      '\$${amount.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.042,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                } else {
                                  return Container();
                                }
                              default:
                                return Container();
                            }
                          },
                        ),
                        Container(
                          height: 40,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(
                            right: screenWidth * 0.05,
                            left: 5,
                          ),
                          child: Text(
                            'USD',
                            style: TextStyle(
                                fontSize: screenWidth * 0.036,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF9796A1)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  color: const Color(0xFFF1F2F3),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 40,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(
                            left: screenWidth * 0.05,
                            right: 5,
                          ),
                          child: Text(
                            'Total',
                            style: TextStyle(
                              fontSize: screenWidth * 0.042,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        StreamBuilder(
                            stream: _listOfItemsController.stream,
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case (ConnectionState.active):
                                  if (snapshot.hasData) {
                                    final item = snapshot.data;
                                    return Container(
                                      height: 40,
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(
                                        bottom: 3,
                                      ),
                                      child: Text(
                                        '(${item!.length} items)',
                                        style: TextStyle(
                                            fontSize: screenWidth * 0.038,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFFBEBEBE)),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                default:
                                  return Container();
                              }
                            }),
                      ],
                    ),
                    Row(
                      children: [
                        StreamBuilder(
                          stream: _combineStreams(),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case (ConnectionState.active):
                                if (snapshot.hasData) {
                                  final total = snapshot.data;
                                  return Container(
                                    height: 40,
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(
                                      bottom: 3,
                                    ),
                                    child: Text(
                                      '\$${total!.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.042,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              default:
                                return Container();
                            }
                          },
                        ),
                        Container(
                          height: 40,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(
                            right: screenWidth * 0.05,
                            left: 5,
                          ),
                          child: Text(
                            'USD',
                            style: TextStyle(
                                fontSize: screenWidth * 0.036,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF9796A1)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.16,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 5,
          child: SlideTransition(
            position: _offsetAnimation,
            child: GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 80.0,
                  right: 80.0,
                  bottom: 10.0,
                ),
                child: Material(
                  child: Container(
                    width: screenWidth - 160,
                    height: 45,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    decoration: const BoxDecoration(
                        color: Color(0xFFFE724C),
                        borderRadius: BorderRadius.all(
                          Radius.circular(40),
                        )),
                    child: const Center(
                      child: Text(
                        'CHECKOUT',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SofiaPro',
                            color: Color(0xFFFFFFFF)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
