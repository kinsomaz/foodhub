import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/constants/others.dart';

typedef OnAddOrSubToQuatity = Future<void> Function(Map item);
typedef OnDeleteItem = Future<void> Function(Map item);

class CartListItem extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final OnAddOrSubToQuatity onAdd;
  final OnAddOrSubToQuatity onSub;
  final OnDeleteItem onDelete;
  const CartListItem({
    super.key,
    required this.items,
    required this.onAdd,
    required this.onSub,
    required this.onDelete,
  });

  @override
  State<CartListItem> createState() => _CartListItemState();
}

class _CartListItemState extends State<CartListItem> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Wrap(
      children: widget.items.map((item) {
        return Padding(
          padding: EdgeInsets.only(
            right: screenWidth * 0.04,
            left: screenWidth * 0.04,
            bottom: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      height: screenHeight * 0.08,
                      width: screenWidth * 0.17,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
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
                      height: screenHeight * 0.08,
                      width: screenWidth * 0.17,
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(10),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 13,
                  ),
                  SizedBox(
                    width: screenWidth * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${item['item']['name']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            fontFamily: 'SofiaPro',
                          ),
                        ),
                        Builder(builder: (context) {
                          String text = '';
                          final extras = item['extra'] as Map;
                          for (var key in extras.keys) {
                            final extraName = extras[key]['name'];
                            text += '$extraName';
                            text += ', ';
                          }
                          return Wrap(
                            children: [
                              Text(
                                text,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 13,
                                  fontFamily: 'SofiaPro',
                                ),
                              ),
                            ],
                          );
                        }),
                        Builder(builder: (context) {
                          final itemPrice =
                              double.parse(item['item']['price'].toString());
                          final quatity =
                              double.parse(item['item']['quatity'].toString());
                          double itemPriceToQuatity = itemPrice * quatity;
                          final extras = item['extra'] as Map;
                          for (var key in extras.keys) {
                            final extra = extras[key]['price'];
                            double price = double.parse(extra.substring(2));
                            itemPriceToQuatity += price * quatity;
                          }
                          return Text(
                            '\$${itemPriceToQuatity.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                fontFamily: 'SofiaPro',
                                color: Color(0xFFFE724C)),
                          );
                        })
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: screenHeight * 0.08,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        widget.onDelete(item);
                      },
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Color(0xFFFE724C),
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            widget.onSub(item);
                          },
                          child: const Icon(
                            Icons.remove_circle_outline,
                            size: 24,
                            color: Color(0xFFFE724C),
                          ),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          item['item']['quatity'].toString().padLeft(2, '0'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.onAdd(item);
                          },
                          child: const Icon(
                            Icons.add_circle,
                            size: 24,
                            color: Color(0xFFFE724C),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
