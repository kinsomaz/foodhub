import 'package:flutter/material.dart';
import 'package:foodhub/services/auth/auth_user.dart';

abstract class AuthProvider {
  String? verificationId;
  int? resendToken;
  Future<void> initialize();
  AuthUser? get currentUser;
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendPasswordReset({required String toEmail});
  Future<void> updateIsEmailVerified();
  Future<void> verifyPhoneNumber({
    required phoneNumber,
    required BuildContext context,
  });
}
