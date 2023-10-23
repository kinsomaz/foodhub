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
  const AuthStateUninitialized({required super.isLoading});
}

class AuthStateRegistering extends FoodHubState {
  final Exception? exception;
  const AuthStateRegistering(
      {required this.exception, required super.isLoading});
}

class AuthStateSigningIn extends FoodHubState {
  final Exception? exception;

  const AuthStateSigningIn({
    required this.exception,
    required super.isLoading,
    super.loadingText = null,
  });
}

class AuthStatePhoneRegistration extends FoodHubState {
  final Exception? exception;
  const AuthStatePhoneRegistration({
    required this.exception,
    required super.isLoading,
  });
}

class AuthStateForgotPassword extends FoodHubState {
  final Exception? exception;
  final bool hasSentEmail;

  const AuthStateForgotPassword({
    required this.exception,
    required this.hasSentEmail,
    required super.isLoading,
  });
}

class AuthStateLoggedIn extends FoodHubState {
  final User user;
  const AuthStateLoggedIn({
    required this.user,
    required super.isLoading,
  });
}

class AuthStateEmailNeedsVerification extends FoodHubState {
  final Exception? exception;
  final bool? isSuccessful;
  const AuthStateEmailNeedsVerification(
      {required this.exception,
      required super.isLoading,
      required this.isSuccessful});
}

class AuthStatePhoneNeedsVerification extends FoodHubState {
  final Exception? exception;
  const AuthStatePhoneNeedsVerification(
      {required this.exception, required super.isLoading});
}

class AuthStateLoggedOut extends FoodHubState with EquatableMixin {
  final Exception? exception;
  const AuthStateLoggedOut({
    required this.exception,
    required super.isLoading,
    super.loadingText = null,
  });

  @override
  List<Object?> get props => [exception, isLoading];
}
