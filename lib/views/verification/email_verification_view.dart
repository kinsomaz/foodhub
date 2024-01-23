import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/services/auth/auth_exception.dart';
import 'package:foodhub/services/bloc/food_hub_bloc.dart';
import 'package:foodhub/services/bloc/food_hub_event.dart';
import 'package:foodhub/services/bloc/food_hub_state.dart';
import 'package:foodhub/utilities/dialogs/verification_dialog.dart';

class EmailVerificationView extends StatefulWidget {
  const EmailVerificationView({super.key});

  @override
  State<EmailVerificationView> createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<EmailVerificationView> {
  @override
  void initState() {
    super.initState();
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
            if (state.exception is EmailNotVerifiedAuthException) {
              showVerificationDialog(context, 'Email Address not verified');
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
                      'Email Verification',
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
                    child: Wrap(children: [
                      Text(
                        'Please check your email address. A verification link will be sent to you shortly to verify your account',
                        style: TextStyle(
                          fontSize: screenWidth * 0.038,
                          fontFamily: 'SofiaPro',
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF9796A1),
                        ),
                      ),
                    ]),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                SizedBox(height: screenHeight * 0.04),
                Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.05,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "I didn't receive a link!",
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontFamily: 'SofiaPro',
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF5B5B5E),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<FoodHubBloc>().add(
                                const AuthEventResendEmailVerification(),
                              );
                        },
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
                ),
                SizedBox(height: screenHeight * 0.02),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      context.read<FoodHubBloc>().add(
                            const AuthEventPhoneView(),
                          );
                    },
                    child: Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: const Color(0xFFFE724C)),
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 10,
                        bottom: 10,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'NEXT',
                        style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFFFFFFFF)),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
