import 'package:flutter/material.dart';

class AddressSearchScreen extends StatefulWidget {
  const AddressSearchScreen({super.key});

  @override
  State<AddressSearchScreen> createState() => _AddressSearchScreenState();
}

class _AddressSearchScreenState extends State<AddressSearchScreen> {
  late final TextEditingController _street;
  final FocusNode _focusNodeStreet = FocusNode();

  @override
  void initState() {
    _street = TextEditingController();
    _focusNodeStreet.addListener(
      () {
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _street.dispose();
    _focusNodeStreet.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(
            right: 5,
            left: 16,
            top: 12,
            bottom: 11,
          ),
          child: Container(
            height: screenHeight * 0.04,
            width: screenWidth * 0.1,
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
        title: Container(
          height: screenHeight * 0.055,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: _focusNodeStreet.hasFocus
                  ? const Color(0xFFFE724C)
                  : const Color(0xFFEEEEEE),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.015,
                ),
                child: Icon(
                  Icons.search,
                  size: screenWidth * 0.05,
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.01,
                  top: screenHeight * 0.01,
                  bottom: screenHeight * 0.01,
                ),
                width: screenWidth * 0.6,
                child: TextField(
                  controller: _street,
                  cursorHeight: 20,
                  focusNode: _focusNodeStreet,
                  keyboardType: TextInputType.streetAddress,
                  enableSuggestions: true,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: 'Search street, city, district',
                    hintStyle: TextStyle(
                      fontSize: screenWidth * 0.047,
                      fontFamily: 'SofiaPro',
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF9796A1),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(5.0),
                  ),
                  cursorColor: const Color(0xFFFE724C),
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
