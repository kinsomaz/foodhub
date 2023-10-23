import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/services/bloc/food_hub_bloc.dart';
import 'package:foodhub/services/bloc/food_hub_event.dart';
import 'package:foodhub/services/bloc/food_hub_state.dart';
import 'package:foodhub/utilities/dialogs/error_dialog.dart';
import 'package:foodhub/utilities/dialogs/password_reset_email_sent_dialog.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  late final TextEditingController _email;
  final FocusNode _focusNodePassword = FocusNode();

  @override
  void initState() {
    _email = TextEditingController();
    _focusNodePassword.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _focusNodePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        context.read<FoodHubBloc>().add(const AuthEventShouldSignIn());
        return false;
      },
      child: BlocListener<FoodHubBloc, FoodHubState>(
        listener: (context, state) async {
          if (state is AuthStateForgotPassword) {
            if (state.hasSentEmail) {
              _email.clear();
              await showPasswordResetSentDialog(context);
            } else if (state.exception != null) {
              await showErrorDialog(
                context,
                'We could not process your request. Please make sure you are a registered user',
              );
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
                            .add(const AuthEventShouldSignIn());
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
                      'Resset Password',
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
                      'Please enter your email address to',
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
                      'request a password reset',
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
                        color: _focusNodePassword.hasFocus
                            ? const Color(0xFFFE724C)
                            : const Color(0xFFEEEEEE),
                      ),
                    ),
                    child: TextField(
                      controller: _email,
                      focusNode: _focusNodePassword,
                      keyboardType: TextInputType.emailAddress,
                      enableSuggestions: true,
                      autocorrect: false,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontFamily: 'SofiaPro',
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFC4C4C4),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(10.0),
                      ),
                      cursorColor: const Color(0xFFFE724C),
                    ),
                  ),
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
                          final email = _email.text;
                          context.read<FoodHubBloc>().add(
                                AuthEventForgotPassword(
                                  email: email,
                                ),
                              );
                        },
                        child: Text(
                          'SEND NEW PASSWORDS',
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
          ),
        ),
      ),
    );
  }
}
