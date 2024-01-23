import 'package:flutter/material.dart' show immutable;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

@immutable
abstract class FoodHubEvent {
  const FoodHubEvent();
}

class AuthEventInitialize extends FoodHubEvent {
  const AuthEventInitialize();
}

class AuthEventLogIn extends FoodHubEvent {
  final String email;
  final String password;
  const AuthEventLogIn(this.email, this.password);
}

class AuthEventResendEmailVerification extends FoodHubEvent {
  const AuthEventResendEmailVerification();
}

class AuthEventVerifyPhoneCode extends FoodHubEvent {
  final String? codeOne;
  final String? codeTwo;
  final String? codeThree;
  final String? codeFour;
  final String? codeFive;
  final String? codeSix;

  const AuthEventVerifyPhoneCode({
    required this.codeOne,
    required this.codeTwo,
    required this.codeThree,
    required this.codeFour,
    required this.codeFive,
    required this.codeSix,
  });
}

class AuthEventVerifyPhone extends FoodHubEvent {
  final PhoneNumber? phoneNumber;

  const AuthEventVerifyPhone({
    required this.phoneNumber,
  });
}

class AuthEventPhoneView extends FoodHubEvent {
  const AuthEventPhoneView();
}

class AuthEventRegister extends FoodHubEvent {
  final String email;
  final String password;
  final String name;
  const AuthEventRegister({
    required this.name,
    required this.email,
    required this.password,
  });
}

class AuthEventGoogleSignIn extends FoodHubEvent {
  const AuthEventGoogleSignIn();
}

class AuthEventShouldRegister extends FoodHubEvent {
  const AuthEventShouldRegister();
}

class AuthEventShouldSignIn extends FoodHubEvent {
  const AuthEventShouldSignIn();
}

class AuthEventForgotPassword extends FoodHubEvent {
  final String? email;
  const AuthEventForgotPassword({this.email});
}

class AuthEventLogOut extends FoodHubEvent {
  const AuthEventLogOut();
}
