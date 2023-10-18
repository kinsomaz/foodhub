import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/services/auth/auth_exception.dart';
import 'package:foodhub/services/bloc/food_hub_bloc.dart';
import 'package:foodhub/services/bloc/food_hub_event.dart';
import 'package:foodhub/services/bloc/food_hub_state.dart';
import 'package:foodhub/utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _focusNodeEmail.addListener(() {
      setState(() {});
    });
    _focusNodePassword.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocListener<FoodHubBloc, FoodHubState>(
      listener: (context, state) async {
        if (state is AuthStateSigningIn) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
                context, 'Cannot find a user with the entered credentials!');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication error');
          }
        }
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
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
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.06,
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: screenWidth * 0.09,
                        fontFamily: 'SofiaPro',
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF000000),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.025),
                Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.05,
                  ),
                  child: SizedBox(
                    width: screenWidth * 0.25,
                    height: screenHeight * 0.03,
                    child: Text(
                      'E-mail',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
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
                    right: screenWidth * 0.05,
                    top: screenHeight * 0.01,
                  ),
                  child: Container(
                    height: screenHeight * 0.07,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: _focusNodeEmail.hasFocus
                            ? const Color(0xFFFE724C)
                            : const Color(0xFFEEEEEE),
                      ),
                    ),
                    child: TextField(
                      controller: _email,
                      focusNode: _focusNodeEmail,
                      keyboardType: TextInputType.emailAddress,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        hintText: 'Your email or phone',
                        hintStyle: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontFamily: 'SofiaPro',
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFC4C4C4),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10.0),
                      ),
                      cursorColor: const Color(0xFFFE724C),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.025),
                Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.05,
                  ),
                  child: SizedBox(
                    width: screenWidth * 0.25,
                    height: screenHeight * 0.03,
                    child: Text(
                      'Password',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
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
                      controller: _password,
                      focusNode: _focusNodePassword,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: !_isPasswordVisible,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontFamily: 'SofiaPro',
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFFC4C4C4),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(10.0),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          )),
                      cursorColor: const Color(0xFFFE724C),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.025),
                Center(
                  child: TextButton(
                    onPressed: () {
                      context.read<FoodHubBloc>().add(
                            const AuthEventForgotPassword(),
                          );
                    },
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontFamily: 'SofiaPro',
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(254, 114, 76, 1),
                          decorationColor: Colors.white),
                    ),
                  ),
                ),
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
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          if (email.isEmpty || password.isEmpty) {
                            await showErrorDialog(
                                context, 'Field must not be empty');
                          } else {
                            context.read<FoodHubBloc>().add(
                                  AuthEventLogIn(
                                    email,
                                    password,
                                  ),
                                );
                          }
                        },
                        child: Text(
                          'LOGIN',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Don't have an account?",
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
                              const AuthEventShouldRegister(),
                            );
                      },
                      child: Text(
                        'Sign Up',
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
                SizedBox(height: screenHeight * 0.025),
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
                          color: Color(0x80B3B3B3),
                          thickness: 0.5,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth * 0.05,
                          right: screenWidth * 0.05,
                        ),
                        child: Text(
                          'Sign in with',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontFamily: 'SofiaPro',
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF5B5B5E),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          color: Color(0x80B3B3B3),
                          thickness: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      height: screenHeight * 0.065,
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
                      child: TextButton.icon(
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
                    ),
                    Container(
                      height: screenHeight * 0.065,
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
                      child: TextButton.icon(
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
                    ),
                  ],
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
