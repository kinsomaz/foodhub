import 'package:flutter/material.dart';
import 'package:foodhub/services/auth/firebase_auth_provider.dart';
import 'package:foodhub/services/cloud/database/firebase_cloud_database.dart';
import 'package:foodhub/utilities/dialogs/confirm_dialog.dart';
import 'package:foodhub/utilities/dialogs/error_dialog.dart';

class AddNewCardScreen extends StatefulWidget {
  const AddNewCardScreen({super.key});

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen>
    with SingleTickerProviderStateMixin {
  late final FirebaseCloudDatabase _cloudServices;
  late final FirebaseAuthProvider _authProvider;
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  late final GlobalKey<FormState> _formKey;
  final _verticalSizeBox = const SizedBox(height: 20.0);
  final _horizontalSizeBox = const SizedBox(width: 10.0);
  String? _name;
  String? _displayName;
  String? _cardNumber;
  String? _cvv;
  int? _expiryMonth;
  int? _expiryYear;

  @override
  void initState() {
    _cloudServices = FirebaseCloudDatabase();
    _authProvider = FirebaseAuthProvider();
    _formKey = GlobalKey<FormState>();
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

    super.initState();
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

    return Scaffold(
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
          'Add a new card',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Color(0xFF111719)),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 19,
                ),
                child: Form(
                  key: _formKey,
                  child: ListBody(
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(),
                          labelText: 'NAME ON CARD',
                          hintText: 'Name on card',
                          labelStyle: TextStyle(
                            fontSize: screenWidth * 0.043,
                            fontFamily: 'SofiaPro',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name on card is required';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (String? value) => _name = value,
                      ),
                      _verticalSizeBox,
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(),
                          labelText: 'CARD NUMBER',
                          hintText: '0000 0000 0000 0000',
                          labelStyle: TextStyle(
                            fontSize: screenWidth * 0.043,
                            fontFamily: 'SofiaPro',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        onSaved: (String? value) => _cardNumber = value,
                      ),
                      _verticalSizeBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                border: const UnderlineInputBorder(),
                                labelText: 'CVV',
                                hintText: '123',
                                labelStyle: TextStyle(
                                  fontSize: screenWidth * 0.043,
                                  fontFamily: 'SofiaPro',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.length != 3) {
                                  return 'CVV invalid';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (String? value) => _cvv = value,
                            ),
                          ),
                          _horizontalSizeBox,
                          Expanded(
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                border: const UnderlineInputBorder(),
                                labelText: 'EXPIRY MONTH',
                                hintText: 'MM',
                                hintStyle: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                ),
                                labelStyle: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  fontFamily: 'SofiaPro',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.length != 2) {
                                  return 'Month invalid';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (String? value) =>
                                  _expiryMonth = int.tryParse(value ?? ""),
                            ),
                          ),
                          _horizontalSizeBox,
                          Expanded(
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                border: const UnderlineInputBorder(),
                                labelText: 'EXPIRY YEAR',
                                hintText: 'YYYY',
                                hintStyle: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                ),
                                labelStyle: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  fontFamily: 'SofiaPro',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.length != 4) {
                                  return 'Year invalid';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (String? value) =>
                                  _expiryYear = int.tryParse(value ?? ""),
                            ),
                          )
                        ],
                      ),
                      _verticalSizeBox,
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(),
                          labelText: 'DISPLAY NAME',
                          hintText: 'Add a display name',
                          labelStyle: TextStyle(
                            fontSize: screenWidth * 0.043,
                            fontFamily: 'SofiaPro',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        onSaved: (String? value) => _displayName = value,
                      ),
                      _verticalSizeBox,
                      _verticalSizeBox,
                      _verticalSizeBox,
                      _verticalSizeBox,
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            child: SlideTransition(
              position: _offsetAnimation,
              child: GestureDetector(
                onTap: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    final result = await showConfirmationDialog(context);
                    if (result) {
                      await _cloudServices.addNewCard(
                        nameOnCard: _name ?? '',
                        userId: _authProvider.currentUser!.uid,
                        cardNumber: _cardNumber ?? '',
                        cvv: _cvv ?? '',
                        expiryMonth: _expiryMonth.toString(),
                        expiryYear: _expiryYear.toString(),
                        displayName: _displayName.toString(),
                      );
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    }
                  } else {
                    showErrorDialog(context, 'One or more field is empty');
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 95.0,
                    right: 95.0,
                    bottom: 10.0,
                  ),
                  child: Container(
                    width: screenWidth - 190,
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
                        'DONE',
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
          )
        ],
      ),
    );
  }
}
