import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/icons/custom_delivery_clock_icon.dart';
import 'package:foodhub/icons/custom_delivery_icon.dart';
import 'package:foodhub/views/foodhub/restaurant.dart';

typedef SearchedRestaurantCallback = void Function(Restaurant restaurant);

class SearchRestaurantListView extends StatefulWidget {
  final Iterable<Restaurant> restaurants;
  final SearchedRestaurantCallback onTap;

  const SearchRestaurantListView({
    super.key,
    required this.restaurants,
    required this.onTap,
  });

  @override
  State<SearchRestaurantListView> createState() =>
      _SearchRestaurantListViewState();
}

class _SearchRestaurantListViewState extends State<SearchRestaurantListView> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Wrap(
      spacing: screenWidth * 0.005,
      runSpacing: screenWidth * 0.05,
      alignment: WrapAlignment.spaceEvenly,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: screenWidth * 0.41,
            margin: EdgeInsets.only(left: screenWidth * 0.025),
            child: Text(
              'Found ${widget.restaurants.length} results',
              style: TextStyle(
                fontSize: screenWidth * 0.08,
                fontWeight: FontWeight.w700,
                fontFamily: 'SofiaPro',
                color: const Color(0xFF111719),
              ),
            ),
          ),
        ),
        ...widget.restaurants.map((restaurant) => Container(
              height: screenHeight * 0.24,
              width: screenWidth * 0.41,
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CachedNetworkImage(
                      imageUrl: restaurant.logo,
                      imageBuilder: (context, imageProvider) => Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Image(
                          image: imageProvider,
                          fit: BoxFit.contain,
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withAlpha(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.035,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth * 0.02,
                          right: screenWidth * 0.015,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            restaurant.name,
                            style: const TextStyle(
                              fontSize: 14,
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
                        size: 13,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.001,
                  ),
                  SizedBox(
                    width: screenWidth * 0.4,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth * 0.02,
                            right: screenWidth * 0.02,
                          ),
                          child: const CustomDeliveryIcon(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            right: screenWidth * 0.02,
                          ),
                          child: SizedBox(
                            width: screenWidth * 0.054,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                restaurant.deliveryFee == 'Free Delivery'
                                    ? 'free'
                                    : restaurant.deliveryFee,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'HelveticaNeue',
                                  color: Color(0xFF7E8392),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth * 0.015,
                            right: screenWidth * 0.01,
                          ),
                          child: const CustomDeliveryClockIcon(),
                        ),
                        SizedBox(
                          width: screenWidth * 0.18,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              restaurant.deliveryTime,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'HelveticaNeue',
                                color: Color(0xFF7E8392),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.008,
                  ),
                  Wrap(
                    children: restaurant.tags
                        .map((tag) {
                          return Container(
                            margin: EdgeInsets.only(
                              left: screenWidth * 0.02,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.015,
                              vertical: 2.0,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6F6F6),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'SofiaPro',
                                color: Color(0xFF8A8E9B),
                              ),
                            ),
                          );
                        })
                        .take(2)
                        .toList(),
                  ),
                ],
              ),
            ))
      ],
    );
  }
}
