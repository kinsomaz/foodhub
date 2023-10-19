import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/services/auth/auth_exception.dart';
import 'package:foodhub/services/bloc/food_hub_bloc.dart';
import 'package:foodhub/services/bloc/food_hub_event.dart';
import 'package:foodhub/services/bloc/food_hub_state.dart';
import 'package:foodhub/utilities/dialogs/error_dialog.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneRegistrationView extends StatefulWidget {
  const PhoneRegistrationView({super.key});

  @override
  State<PhoneRegistrationView> createState() => _PhoneRegistrationViewState();
}

class _PhoneRegistrationViewState extends State<PhoneRegistrationView> {
  late final TextEditingController _phone;
  final FocusNode _focusNodePhoneNumber = FocusNode();
  PhoneNumber _number = PhoneNumber(isoCode: 'NG');

  @override
  void initState() {
    _phone = TextEditingController();
    _focusNodePhoneNumber.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _phone.dispose();
    _focusNodePhoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocListener<FoodHubBloc, FoodHubState>(
      listener: (context, state) {
        if (state is AuthStatePhoneRegistration) {
          if (state.exception is PhoneAlreadyLinkedAuthException) {
            showErrorDialog(
                context, 'Phone number has already been linked with this user');
          } else if (state.exception is InvalidCredentialAuthException) {
            showErrorDialog(context, "The provider's credential is not valid");
          } else if (state.exception is CredentialAlreadyInUseAuthException) {
            showErrorDialog(context,
                'Phone number has already been linked with another user');
          } else if (state.exception is InvalidPhoneNumberAuthException) {
            showErrorDialog(context, 'Enter a valid Phone Number');
          } else if (state.exception is SMSQuotaExceededAuthException) {
            showErrorDialog(context, 'SMS Quota Exceeded');
          } else if (state.exception is GenericAuthException) {
            showErrorDialog(context, 'Check your internet connection');
          }
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.06,
                left: screenWidth * 0.05,
              ),
              child: Container(
                height: screenHeight * 0.045,
                width: screenWidth * 0.1,
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
                  onPressed: () {},
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
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.19),
                  Padding(
                    padding: EdgeInsets.only(
                      left: screenWidth * 0.05,
                    ),
                    child: SizedBox(
                      width: screenWidth * 0.75,
                      height: screenHeight * 0.06,
                      child: Text(
                        'Registration',
                        style: TextStyle(
                          fontSize: screenWidth * 0.09,
                          fontFamily: 'SofiaPro',
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF000000),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.013),
                  Padding(
                    padding: EdgeInsets.only(
                      left: screenWidth * 0.05,
                    ),
                    child: SizedBox(
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.03,
                      child: Text(
                        'Enter your phone number to verify',
                        style: TextStyle(
                          fontSize: screenWidth * 0.038,
                          fontFamily: 'SofiaPro',
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF9796A1),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: screenWidth * 0.05,
                    ),
                    child: SizedBox(
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.03,
                      child: Text(
                        'your account',
                        style: TextStyle(
                          fontSize: screenWidth * 0.038,
                          fontFamily: 'SofiaPro',
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF9796A1),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Padding(
                    padding: EdgeInsets.only(
                      left: screenWidth * 0.05,
                      right: screenWidth * 0.05,
                      top: screenHeight * 0.01,
                    ),
                    child: Container(
                        height: screenHeight * 0.07,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: _focusNodePhoneNumber.hasFocus
                                ? const Color(0xFFFE724C)
                                : const Color(0xFFEEEEEE),
                          ),
                        ),
                        child: InternationalPhoneNumberInput(
                          formatInput: true,
                          ignoreBlank: false,
                          autoValidateMode: AutovalidateMode.disabled,
                          focusNode: _focusNodePhoneNumber,
                          initialValue: _number,
                          onInputChanged: (PhoneNumber number) {
                            _number = number;
                          },
                          selectorConfig: const SelectorConfig(
                              selectorType: PhoneInputSelectorType.DROPDOWN,
                              trailingSpace: false,
                              useEmoji: true),
                          inputDecoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        )),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: screenHeight * 0.030,
                        bottom: screenHeight * 0.02,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: const Color(0xFFFE724C),
                            border: Border.all(color: const Color(0xFFFFFFFF))),
                        width: screenWidth * 0.7,
                        height: screenHeight * 0.08,
                        child: TextButton(
                          onPressed: () {
                            final phoneNumber = _number;
                            context
                                .read<FoodHubBloc>()
                                .add(AuthEventVerifyPhone(
                                  phoneNumber: phoneNumber,
                                ));
                          },
                          child: Text(
                            'SEND',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontFamily: 'SofiaPro',
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
