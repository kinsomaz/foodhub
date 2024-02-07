import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/constants/others.dart';
import 'package:foodhub/helpers/loading/loading_screen_for_add_on.dart';
import 'package:foodhub/services/auth/firebase_auth_provider.dart';
import 'package:foodhub/services/cloud/database/firebase_cloud_database.dart';
import 'package:foodhub/utilities/animations/custom_cart_buttom.dart';
import 'package:foodhub/views/foodhub/menu_extra.dart';
import 'package:foodhub/views/foodhub/menu_extras_list_view.dart';
import 'package:foodhub/views/foodhub/menu_item.dart';

class MenuItemDetailsView extends StatefulWidget {
  const MenuItemDetailsView({super.key});

  @override
  State<MenuItemDetailsView> createState() => _MenuItemDetailsViewState();
}

class _MenuItemDetailsViewState extends State<MenuItemDetailsView>
    with SingleTickerProviderStateMixin {
  late final FirebaseCloudDatabase _cloudServices;
  late final FirebaseAuthProvider _authProvider;
  late Map<String, Map<String, dynamic>> selectedExtras;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  int quantity = 1;

  @override
  void initState() {
    _cloudServices = FirebaseCloudDatabase();
    _authProvider = FirebaseAuthProvider();
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

    Future.delayed(const Duration(seconds: 1), () {
      _controller.forward();
    });

    selectedExtras = {};
    super.initState();
  }

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    setState(() {
      if (quantity > 1) {
        quantity--;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    final menuItem = arguments[0] as MenuItem;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: imageUrl,
                      imageBuilder: (context, imageProvider) => Container(
                        height: screenHeight * 0.25,
                        width: screenWidth,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                        ),
                        margin: const EdgeInsets.only(
                          top: 30,
                        ),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        )),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                          child: Image(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        height: screenHeight * 0.25,
                        width: screenWidth,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                        ),
                        margin: const EdgeInsets.only(
                          top: 30,
                        ),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        )),
                      ),
                      errorWidget: (context, url, error) {
                        return Container(
                          height: screenHeight * 0.25,
                          width: screenWidth,
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05,
                          ),
                          margin: const EdgeInsets.only(
                            top: 30,
                          ),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          )),
                        );
                      },
                    ),
                    Positioned(
                      top: 40,
                      right: 27,
                      child: StreamBuilder(
                          stream: _cloudServices.isFoodItemFavourite(
                            menuItem: menuItem,
                            userId: _authProvider.currentUser!.uid,
                          ),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case (ConnectionState.waiting):
                              case (ConnectionState.active):
                                if (snapshot.hasData) {
                                  if (snapshot.data == true) {
                                    return GestureDetector(
                                      onTap: () {
                                        _cloudServices
                                            .addOrRemoveFavouriteFoodItem(
                                                menuItem: menuItem,
                                                userId: _authProvider
                                                    .currentUser!.uid);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          left: 4,
                                          right: 4,
                                          top: 5,
                                          bottom: 4,
                                        ),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFFFE724C),
                                        ),
                                        child: const Icon(
                                          Icons.favorite_rounded,
                                          color: Color(0xFFFFFFFF),
                                          size: 18,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return GestureDetector(
                                      onTap: () {
                                        _cloudServices
                                            .addOrRemoveFavouriteFoodItem(
                                                menuItem: menuItem,
                                                userId: _authProvider
                                                    .currentUser!.uid);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          left: 4,
                                          right: 4,
                                          top: 5,
                                          bottom: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color(0xFFFFFFFF)
                                              .withAlpha(60),
                                        ),
                                        child: const Icon(
                                          Icons.favorite_rounded,
                                          color: Color(0xFFFFFFFF),
                                          size: 18,
                                        ),
                                      ),
                                    );
                                  }
                                } else {
                                  return GestureDetector(
                                    onTap: () {
                                      _cloudServices
                                          .addOrRemoveFavouriteFoodItem(
                                              menuItem: menuItem,
                                              userId: _authProvider
                                                  .currentUser!.uid);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                        left: 4,
                                        right: 4,
                                        top: 5,
                                        bottom: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFFFFFFFF)
                                            .withAlpha(60),
                                      ),
                                      child: const Icon(
                                        Icons.favorite_rounded,
                                        color: Color(0xFFFFFFFF),
                                        size: 18,
                                      ),
                                    ),
                                  );
                                }
                              default:
                                return GestureDetector(
                                  onTap: () {
                                    _cloudServices.addOrRemoveFavouriteFoodItem(
                                        menuItem: menuItem,
                                        userId: _authProvider.currentUser!.uid);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      left: 4,
                                      right: 4,
                                      top: 5,
                                      bottom: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          const Color(0xFFFFFFFF).withAlpha(60),
                                    ),
                                    child: const Icon(
                                      Icons.favorite_rounded,
                                      color: Color(0xFFFFFFFF),
                                      size: 18,
                                    ),
                                  ),
                                );
                            }
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: screenHeight * 0.055,
                        left: screenWidth * 0.07,
                      ),
                      child: Container(
                        height: screenHeight * 0.041,
                        width: screenWidth * 0.08,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
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
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.04,
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      width: screenWidth * 0.8,
                      child: Text(
                        menuItem.name,
                        style: TextStyle(
                          fontSize: screenWidth * 0.08,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SofiaPro',
                          color: const Color(0xFF323643),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 18,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.attach_money,
                            size: 17,
                            color: Color(0xFFFE724C),
                          ),
                          Text(
                            menuItem.price,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFE724C),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: decrementQuantity,
                            child: const Icon(
                              Icons.remove_circle_outline,
                              size: 30,
                              color: Color(0xFFFE724C),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            quantity.toString().padLeft(2, '0'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: incrementQuantity,
                            child: const Icon(
                              Icons.add_circle,
                              size: 30,
                              color: Color(0xFFFE724C),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Text(
                    menuItem.description,
                    style: TextStyle(
                      fontFamily: 'HelveticaNeue',
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF858992),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                StreamBuilder(
                  stream: _cloudServices.getMenuExtras(
                    menuName: menuItem.name,
                    restaurantName: menuItem.restaurant,
                  ),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        if (snapshot.hasData) {
                          final extras = snapshot.data as List<MenuExtra>;
                          List<MenuExtraListView> listView =
                              extras.map((extra) {
                            return MenuExtraListView(
                              extra: extra,
                              onExtraSelected: (int selectedInt) {
                                setState(() {
                                  selectedExtras[extra.title] =
                                      extra.item[selectedInt];
                                });
                              },
                            );
                          }).toList();
                          return Container(
                            constraints: const BoxConstraints(
                              minHeight: 400,
                            ),
                            child: Wrap(
                              children: List.generate(listView.length, (index) {
                                return listView[index];
                              }),
                            ),
                          );
                        } else {
                          return Container(
                            constraints: const BoxConstraints(
                              minHeight: 400,
                            ),
                            child: buildAddOnLoadingState(
                              screenHeight,
                              screenWidth,
                            ),
                          );
                        }
                      default:
                        return Container(
                          constraints: const BoxConstraints(
                            minHeight: 400,
                          ),
                          child: buildAddOnLoadingState(
                            screenHeight,
                            screenWidth,
                          ),
                        );
                    }
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 8,
            child: SlideTransition(
              position: _offsetAnimation,
              child: Center(
                child: CustomCartButton(
                  addToCart: () async {
                    await _cloudServices.addToCart(
                      ownerUserId: _authProvider.currentUser!.uid,
                      restaurantName: menuItem.restaurant,
                      menuItem: menuItem,
                      quatity: quantity,
                      extras: selectedExtras,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
