import 'package:flutter/material.dart' show immutable;

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

class AuthEventSendEmailVerification extends FoodHubEvent {
  const AuthEventSendEmailVerification();
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

class AuthEventForgotPassword extends FoodHubEvent {
  final String? email;
  const AuthEventForgotPassword({this.email});
}

class AuthEventLogOut extends FoodHubEvent {
  const AuthEventLogOut();
}
