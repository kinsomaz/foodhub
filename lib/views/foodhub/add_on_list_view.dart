import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/views/foodhub/add_on.dart';

typedef AddOnSelected = void Function(int selectedInt);

class AddOnListView extends StatefulWidget {
  final List<AddOn> addOns;
  final AddOnSelected onAddOnSelected;

  const AddOnListView({
    super.key,
    required this.addOns,
    required this.onAddOnSelected,
  });

  @override
  State<AddOnListView> createState() => _AddOnListViewState();
}

class _AddOnListViewState extends State<AddOnListView> {
  int selectedAddOnIndex = -1;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Wrap(
      children: List.generate(
        widget.addOns.length,
        (index) {
          final addOn = widget.addOns[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedAddOnIndex = index;
              });
              widget.onAddOnSelected(selectedAddOnIndex);
            },
            child: Container(
              width: screenWidth,
              height: 43,
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
                      CachedNetworkImage(
                        imageUrl: addOn.image,
                        imageBuilder: (context, imageProvider) => Container(
                          height: 43,
                          width: 45,
                          padding: const EdgeInsets.all(4.0),
                          child: Image(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          height: 43,
                          width: 45,
                          padding: const EdgeInsets.all(4.0),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        addOn.name,
                        style: const TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        addOn.price,
                        style: const TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF000000),
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
    );
  }
}
