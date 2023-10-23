import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/services/auth/auth_exception.dart';
import 'package:foodhub/services/bloc/food_hub_bloc.dart';
import 'package:foodhub/services/bloc/food_hub_event.dart';
import 'package:foodhub/services/bloc/food_hub_state.dart';
import 'package:foodhub/utilities/dialogs/error_dialog.dart';
import 'package:foodhub/utilities/dialogs/success_dialog.dart';
import 'package:foodhub/views/verification/verification_exception.dart';

class EmailVerificationView extends StatefulWidget {
  const EmailVerificationView({super.key});

  @override
  State<EmailVerificationView> createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<EmailVerificationView> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    _focusNodes = List.generate(4, (index) => FocusNode());
    _controllers = List.generate(4, (index) => TextEditingController());
    super.initState();
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        context.read<FoodHubBloc>().add(const AuthEventShouldRegister());
        return false;
      },
      child: BlocListener<FoodHubBloc, FoodHubState>(
        listener: (context, state) {
          if (state is AuthStateEmailNeedsVerification) {
            if (state.isSuccessful == true) {
              showSuccessDialog(context, 'Verification Successful');
            }
            if (state.exception is InvalidVerifiationCodeException) {
              showErrorDialog(context, 'Invalid verification Code');
            } else if (state.exception is UpdateIsEmailVerifiedException) {
              showErrorDialog(context, 'Could not verify email');
            }
          }
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
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
                      onPressed: () {
                        context
                            .read<FoodHubBloc>()
                            .add(const AuthEventShouldRegister());
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
                SizedBox(height: screenHeight * 0.10),
                Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.05,
                  ),
                  child: SizedBox(
                    width: screenWidth * 0.75,
                    height: screenHeight * 0.06,
                    child: Text(
                      'Verification Code',
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
                      'Please type the verification code sent to',
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
                      '',
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
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      for (var i = 0; i < 4; i++) buildCodeTextField(i),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "I don't receive a code!",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontFamily: 'SofiaPro',
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF5B5B5E),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Please resend',
                        style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontFamily: 'SofiaPro',
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(254, 114, 76, 1),
                            decorationColor: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCodeTextField(int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth * 0.13,
      height: screenHeight * 0.07,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: _focusNodes[index].hasFocus
              ? const Color(0xFFFE724C)
              : const Color(0xFFEEEEEE),
        ),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
        ),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        onChanged: (value) async {
          if (value.length == 1 && index < 3) {
            _focusNodes[index].unfocus();
            _focusNodes[index + 1].requestFocus();
          }
          if (value.length == 1 && index == 3) {
            context.read<FoodHubBloc>().add(
                  AuthEventVerifyEmailCode(
                    codeOne: _controllers[0].text,
                    codeTwo: _controllers[1].text,
                    codeThree: _controllers[2].text,
                    codeFour: _controllers[3].text,
                  ),
                );
          }
        },
      ),
    );
  }
}
