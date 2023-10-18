import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/Google/google_sign_in_exception.dart';
import 'package:foodhub/services/bloc/food_hub_bloc.dart';
import 'package:foodhub/services/bloc/food_hub_event.dart';
import 'package:foodhub/services/bloc/food_hub_state.dart';
import 'package:foodhub/utilities/dialogs/error_dialog.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocListener<FoodHubBloc, FoodHubState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is SignInWithAppleNotSupportedException) {
            await showErrorDialog(context, 'Apple sign in not supported');
          } else if (state.exception is GoogleSignInAccountNotFoundException) {
            await showErrorDialog(context, 'Account not found');
          } else if (state.exception is GoogleSignInAuthenticationException) {
            await showErrorDialog(context, 'Authentication Failed');
          } else if (state.exception is GoogleErrorException) {
            await showErrorDialog(context, 'Try signing in again');
          }
        }
      },
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/homebackground.jpg"),
              fit: BoxFit.cover,
            )),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.0),
                    Colors.black.withOpacity(1.0),
                  ]),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.08),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    height: 35.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          )
                        ]),
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Skip',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFFFE724C)),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.045),
              Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.05,
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Wrap(spacing: 10, children: <Widget>[
                    SizedBox(
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.073,
                      child: Text(
                        'Welcome to',
                        style: TextStyle(
                          fontSize: screenWidth * 0.13,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'SofiaPro',
                          color: const Color(0xFF111719),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.073,
                      child: Text(
                        'FoodHub',
                        style: TextStyle(
                          fontSize: screenWidth * 0.13,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'SofiaPro',
                          color: const Color(0xFFFE724C),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.055,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    children: <Widget>[
                      SizedBox(
                        width: screenWidth * 0.7,
                        height: screenHeight * 0.08,
                        child: Text(
                          'Your favourite foods delivered fast at your door',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontFamily: 'SofiaPro',
                            color: const Color(0xFF30384F),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.273),
              Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.08,
                  right: screenWidth * 0.08,
                  bottom: screenHeight * 0.016,
                ),
                child: Row(
                  children: <Widget>[
                    const Expanded(
                      child: Divider(
                        color: Color(0xFFFFFFFF),
                        thickness: 0.5,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.05,
                        right: screenWidth * 0.05,
                      ),
                      child: Text(
                        'sign in with',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontFamily: 'SofiaPro',
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFFFFFFF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: Color(0xFFFFFFFF),
                        thickness: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.face,
                      size: screenWidth * 0.09,
                    ),
                    label: Text(
                      'FACEBOOK',
                      style: TextStyle(
                          fontSize: screenWidth * 0.036,
                          fontFamily: 'SofiaPro',
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF000000)),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFFFFFFF),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      context.read<FoodHubBloc>().add(
                            const AuthEventGoogleSignIn(),
                          );
                    },
                    icon: Icon(
                      Icons.face,
                      size: screenWidth * 0.09,
                    ),
                    label: Text(
                      ' GOOGLE ',
                      style: TextStyle(
                          fontSize: screenWidth * 0.036,
                          fontFamily: 'SofiaPro',
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF000000)),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFFFFFFF),
                    ),
                  ),
                ],
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: screenHeight * 0.035,
                    bottom: screenHeight * 0.02,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22.0),
                        color: const Color(0x36FFFFFF),
                        border: Border.all(color: const Color(0xFFFFFFFF))),
                    width: screenWidth * 0.875,
                    child: TextButton(
                      onPressed: () {
                        context.read<FoodHubBloc>().add(
                              const AuthEventShouldRegister(),
                            );
                      },
                      child: Text(
                        'Start with email or phone',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontFamily: 'SofiaPro',
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFFEFEFE),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                      fontSize: screenWidth * 0.044,
                      fontFamily: 'SofiaPro',
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFFFFFFF),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<FoodHubBloc>().add(
                            const AuthEventShouldSignIn(),
                          );
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                          fontSize: screenWidth * 0.044,
                          fontFamily: 'SofiaPro',
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFFFFFFF),
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      )),
    );
  }
}
