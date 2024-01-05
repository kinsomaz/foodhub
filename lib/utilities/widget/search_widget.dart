import 'package:flutter/material.dart';
import 'package:foodhub/icons/custom_search_switch_icon.dart';

class SearchWidget extends StatefulWidget {
  final TextEditingController searchController;
  final FocusNode focusNode;
  const SearchWidget({
    super.key,
    required this.searchController,
    required this.focusNode,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.05,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: screenHeight * 0.055,
            width: screenWidth * 0.7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: const Color(0xFFFCFCFD),
              border: Border.all(
                color: widget.focusNode.hasFocus
                    ? const Color(0xFFFE724C)
                    : const Color(0xFFEFEFEF),
              ),
            ),
            child: TextField(
              controller: widget.searchController,
              focusNode: widget.focusNode,
              keyboardType: TextInputType.text,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: 'Find for food or restaurant',
                hintStyle: TextStyle(
                  fontSize: screenWidth * 0.039,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF9AA0B4),
                ),
                prefixIcon: const Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(1.0),
              ),
              onTapOutside: (event) {
                widget.focusNode.unfocus();
              },
              cursorColor: const Color(0xFFFE724C),
            ),
          ),
          SizedBox(
            width: screenWidth * 0.04,
          ),
          Container(
            width: screenWidth * 0.1,
            height: screenHeight * 0.05,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: CustomSearchSwitchIcon(),
            ),
          ),
        ],
      ),
    );
  }
}
