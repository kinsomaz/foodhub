import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

abstract class AuthenticationProvider {
  String? verificationId;
  int? resendToken;
  Future<void> initialize();
  User? get currentUser;
  Future<User> logIn({
    required String email,
    required String password,
  });
  Future<User> createUser({
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendPasswordReset({required String toEmail});
  Future<void> sendEmailVerification();
  Future<void> verifyPhoneNumber({
    required PhoneNumber phoneNumber,
    required BuildContext context,
  });
  Future<void> verifyPhoneCode({
    required String verificationId,
    required String verificationCode,
  });
}
