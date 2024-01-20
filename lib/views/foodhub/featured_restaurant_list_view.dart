import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/icons/custom_delivery_clock_icon.dart';
import 'package:foodhub/icons/custom_delivery_icon.dart';
import 'package:foodhub/views/foodhub/restaurant.dart';
import 'package:foodhub/views/foodhub/restaurant_tag_list_view.dart';

typedef FeaturedRestaurantCallback = void Function(Restaurant restaurant);
typedef IsRestaurantFavouriteCallback = Stream<bool> Function(
  Restaurant restaurant,
);
typedef CalculateRestaurantFeeCallback = Future<void> Function(
  String restaurantName,
);
typedef GetRestaurantFeeCallback = Stream<Map> Function(
  String restaurantName,
);

class FeaturedRestaurantListView extends StatefulWidget {
  final Iterable<Restaurant> restaurants;
  final FeaturedRestaurantCallback onTap;
  final FeaturedRestaurantCallback addToFavourite;
  final IsRestaurantFavouriteCallback isFavourite;
  final CalculateRestaurantFeeCallback calculateRestaurantFee;
  final GetRestaurantFeeCallback getRestaurantFee;

  const FeaturedRestaurantListView({
    super.key,
    required this.restaurants,
    required this.onTap,
    required this.addToFavourite,
    required this.isFavourite,
    required this.calculateRestaurantFee,
    required this.getRestaurantFee,
  });

  @override
  State<FeaturedRestaurantListView> createState() =>
      _FeaturedRestaurantListViewState();
}

class _FeaturedRestaurantListViewState
    extends State<FeaturedRestaurantListView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return ListView.builder(
      itemCount: widget.restaurants.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final restaurant = widget.restaurants.elementAt(index);
        return GestureDetector(
          onTap: () {
            widget.onTap(restaurant);
          },
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.025),
            child: Container(
              height: screenHeight * 0.30,
              width: screenWidth * 0.7,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: restaurant.imageUrl,
                        imageBuilder: (context, imageProvider) => Container(
                          height: screenHeight * 0.185,
                          width: screenWidth * 0.7,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
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
                          height: screenHeight * 0.185,
                          width: screenWidth * 0.7,
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(10),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: StreamBuilder(
                            stream: widget.isFavourite(restaurant),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case (ConnectionState.waiting):
                                case (ConnectionState.active):
                                  if (snapshot.hasData) {
                                    if (snapshot.data == true) {
                                      return GestureDetector(
                                        onTap: () {
                                          widget.addToFavourite(restaurant);
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
                                          widget.addToFavourite(restaurant);
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
                                        widget.addToFavourite(restaurant);
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
                                      widget.addToFavourite(restaurant);
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
                            }),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.007,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth * 0.03,
                          right: screenWidth * 0.015,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            restaurant.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'SofiaPro',
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.check_circle,
                        color: restaurant.isVerified
                            ? const Color(0xFF029094)
                            : const Color(0xFFD3D1D8),
                        size: 15,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.001,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth * 0.03,
                          right: screenWidth * 0.02,
                        ),
                        child: const CustomDeliveryIcon(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: screenWidth * 0.02,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Builder(
                            builder: (context) {
                              widget.calculateRestaurantFee(restaurant.name);
                              return StreamBuilder(
                                stream:
                                    widget.getRestaurantFee(restaurant.name),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case (ConnectionState.waiting):
                                    case (ConnectionState.active):
                                      if (snapshot.hasData) {
                                        final data = snapshot.data;
                                        final amount =
                                            double.parse(data!['deliveryFee']);
                                        return Text(
                                          '\$${amount.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'HelveticaNeue',
                                            color: Color(0xFF7E8392),
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    default:
                                      return Container();
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 0.02,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth * 0.015,
                          right: screenWidth * 0.01,
                        ),
                        child: const CustomDeliveryClockIcon(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: screenWidth * 0.015,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            restaurant.deliveryTime,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'HelveticaNeue',
                              color: Color(0xFF7E8392),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.007,
                  ),
                  Container(
                    height: 22,
                    margin: EdgeInsets.only(
                      left: screenWidth * 0.01,
                    ),
                    child: RestaurantTagListView(
                      tags: restaurant.tags,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
