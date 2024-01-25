import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/views/foodhub/menu_extra.dart';

typedef ExtraSelected = void Function(int selectedInt);

class MenuExtraListView extends StatefulWidget {
  final MenuExtra extra;
  final ExtraSelected onExtraSelected;
  const MenuExtraListView({
    super.key,
    required this.extra,
    required this.onExtraSelected,
  });

  @override
  State<MenuExtraListView> createState() => _MenuExtraListViewState();
}

class _MenuExtraListViewState extends State<MenuExtraListView> {
  int selectedAddOnIndex = -1;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Wrap(children: [
      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        child: Text(
          widget.extra.title,
          style: TextStyle(
            fontFamily: 'SofiaPro',
            fontSize: screenWidth * 0.044,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF323643),
          ),
        ),
      ),
      ...List.generate(
        widget.extra.item.length,
        (index) {
          final extra = widget.extra.item[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedAddOnIndex = index;
              });
              widget.onExtraSelected(selectedAddOnIndex);
            },
            child: Container(
              width: screenWidth,
              height: screenHeight * 0.054,
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(
                left: 10,
                right: 18,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Visibility(
                        visible: (extra['image'] ?? '').isNotEmpty,
                        child: CachedNetworkImage(
                          imageUrl: extra['image'] ?? '',
                          imageBuilder: (context, imageProvider) => Container(
                            height: screenHeight * 0.05,
                            width: screenWidth * 0.1,
                            padding: const EdgeInsets.only(
                              right: 4,
                              top: 4,
                              bottom: 4,
                            ),
                            child: Image(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            height: screenHeight * 0.05,
                            width: screenWidth * 0.1,
                            padding: const EdgeInsets.all(4.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        extra['name'] ?? '',
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontSize: screenWidth * 0.038,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF000000),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        extra['price'] ?? '',
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontSize: screenWidth * 0.038,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF000000),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Icon(
                        selectedAddOnIndex == index
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        size: 25,
                        color: const Color(0xFFFE724C),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    ]);
  }
}
