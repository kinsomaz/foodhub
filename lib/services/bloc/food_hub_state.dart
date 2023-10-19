import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

@immutable
abstract class FoodHubState {
  final bool isLoading;
  final String? loadingText;
  const FoodHubState({
    required this.isLoading,
    this.loadingText = 'Please wait a moment',
  });
}

class AuthStateUninitialized extends FoodHubState {
  const AuthStateUninitialized({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateRegistering extends FoodHubState {
  final Exception? exception;
  const AuthStateRegistering({required this.exception, required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateSigningIn extends FoodHubState {
  final Exception? exception;

  const AuthStateSigningIn({
    required this.exception,
    required bool isLoading,
    String? loadingText,
  }) : super(isLoading: isLoading, loadingText: loadingText);
}

class AuthStatePhoneRegistration extends FoodHubState {
  final Exception? exception;
  const AuthStatePhoneRegistration({
    required this.exception,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateForgotPassword extends FoodHubState {
  final Exception? exception;
  final bool hasSentEmail;

  const AuthStateForgotPassword({
    required this.exception,
    required this.hasSentEmail,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateLoggedIn extends FoodHubState {
  final User user;
  const AuthStateLoggedIn({
    required this.user,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateEmailNeedsVerification extends FoodHubState {
  final Exception? exception;
  final bool? isSuccessful;
  const AuthStateEmailNeedsVerification(
      {required this.exception,
      required bool isLoading,
      required this.isSuccessful})
      : super(isLoading: isLoading);
}

class AuthStatePhoneNeedsVerification extends FoodHubState {
  final Exception? exception;
  const AuthStatePhoneNeedsVerification(
      {required this.exception, required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLoggedOut extends FoodHubState with EquatableMixin {
  final Exception? exception;
  const AuthStateLoggedOut({
    required this.exception,
    required bool isLoading,
    String? loadingText,
  }) : super(
          isLoading: isLoading,
          loadingText: loadingText,
        );

  @override
  List<Object?> get props => [exception, isLoading];
}
