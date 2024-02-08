import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/views/order/order_item.dart';

class OrderItemListView extends StatefulWidget {
  final Iterable<OrderItem> orderItems;
  const OrderItemListView({
    super.key,
    required this.orderItems,
  });

  @override
  State<OrderItemListView> createState() => _OrderItemListViewState();
}

class _OrderItemListViewState extends State<OrderItemListView> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return ListView.builder(
      itemCount: widget.orderItems.length,
      itemBuilder: (context, index) {
        final orderItem = widget.orderItems.elementAt(index);
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenWidth * 0.025,
          ),
          child: Container(
            height: screenHeight * 0.21,
            width: screenWidth,
            alignment: Alignment.topCenter,
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: screenHeight * 0.085,
                          width: screenHeight * 0.085,
                          margin: EdgeInsets.all(screenWidth * 0.038),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: CachedNetworkImage(
                            imageUrl: orderItem.restaurantLogo,
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
                            errorWidget: (context, url, error) {
                              return Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black.withAlpha(10),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: screenHeight * 0.001,
                        ),
                        SizedBox(
                          height: screenHeight * 0.09,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    orderItem.orderedTime,
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.036,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'SofiaPro',
                                      color: const Color(0xFF9796A1),
                                    ),
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.013,
                                  ),
                                  const Icon(
                                    Icons.circle,
                                    color: Color(0xFF9796A1),
                                    size: 5,
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.013,
                                  ),
                                  Text(
                                    '${orderItem.menuItems.length} Items',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.036,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'SofiaPro',
                                      color: const Color(0xFF9796A1),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    orderItem.restaurantName,
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.042,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'SofiaPro',
                                      color: const Color(0xFF000000),
                                    ),
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.015,
                                  ),
                                  Icon(
                                    Icons.check_circle,
                                    color: orderItem.restaurantIsVerified
                                        ? const Color(0xFF029094)
                                        : const Color(0xFFD3D1D8),
                                    size: screenWidth * 0.037,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: orderItem.restaurantIsVerified
                                        ? const Color(0xFF4EE476)
                                        : const Color(0xFFD3D1D8),
                                    size: screenWidth * 0.027,
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.015,
                                  ),
                                  Text(
                                    'Order delivered',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.038,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'SofiaPro',
                                      color: const Color(0xFF4EE476),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      margin: EdgeInsets.only(
                        top: screenWidth * 0.038,
                        right: screenWidth * 0.038,
                      ),
                      child: Text(
                        '\$${orderItem.totalPrice}',
                        style: TextStyle(
                          fontSize: screenWidth * 0.044,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SofiaPro',
                          color: const Color(0xFFFE724C),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.005,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: screenHeight * 0.06,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.042,
                      ),
                      constraints: BoxConstraints(
                        maxWidth: screenWidth * 0.36,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Rate',
                          style: TextStyle(
                              fontSize: screenWidth * 0.042,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'SofiaPro',
                              color: const Color(0xFF000000)),
                        ),
                      ),
                    ),
                    Container(
                      height: screenHeight * 0.06,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.042,
                      ),
                      constraints: BoxConstraints(
                        maxWidth: screenWidth * 0.36,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFE724C),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Re-Order',
                          style: TextStyle(
                              fontSize: screenWidth * 0.042,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'SofiaPro',
                              color: const Color(0xFFFFFFFF)),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
