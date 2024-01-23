import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/firebase_options.dart';
import 'package:foodhub/services/auth/auth_exception.dart';
import 'package:foodhub/services/auth/auth_providers.dart';
import 'package:foodhub/services/bloc/food_hub_bloc.dart';
import 'package:foodhub/services/bloc/food_hub_event.dart';
import 'package:foodhub/views/verification/verification_exception.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class FirebaseAuthProvider implements AuthenticationProvider {
  static final FirebaseAuthProvider _shared =
      FirebaseAuthProvider._sharedInstance();
  FirebaseAuthProvider._sharedInstance();
  factory FirebaseAuthProvider() => _shared;

  @override
  int? resendToken;

  @override
  String? verificationId;

  @override
  Future<User> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  User? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    user?.reload();
    if (user != null) {
      return user;
    } else {
      return null;
    }
  }

  @override
  Future<User> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'firebase_auth/invalid-email':
          throw InvalidEmailAuthException();
        case 'firebase_auth/user-not-found':
          throw UserNotFoundAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user!.sendEmailVerification();
    } catch (e) {
      throw UpdateIsEmailVerifiedException();
    }
  }

  @override
  Future<void> verifyPhoneNumber({
    required PhoneNumber phoneNumber,
    required BuildContext context,
  }) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          await FirebaseAuth.instance.currentUser!
              .linkWithCredential(credential);
        } on FirebaseAuthException catch (e) {
          switch (e.code) {
            case "provider-already-linked":
              throw PhoneAlreadyLinkedAuthException();
            case "invalid-credential":
              throw InvalidCredentialAuthException();
            case "credential-already-in-use":
              throw CredentialAlreadyInUseAuthException();
            default:
              throw GenericAuthException();
          }
        } catch (_) {
          throw GenericAuthException();
        }
        // ignore: use_build_context_synchronously
        context.read<FoodHubBloc>().add(
              const AuthEventVerifyPhoneCode(
                codeOne: null,
                codeTwo: null,
                codeThree: null,
                codeFour: null,
                codeFive: null,
                codeSix: null,
              ),
            );
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          throw InvalidPhoneNumberAuthException();
        } else {
          throw SMSQuotaExceededAuthException();
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        this.verificationId = verificationId;
        this.resendToken = resendToken;
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {
        this.verificationId = verificationId;
      },
    );
  }

  @override
  Future<void> verifyPhoneCode({
    required String verificationId,
    required String verificationCode,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: verificationCode,
      );
      await FirebaseAuth.instance.currentUser!.linkWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        throw InvalidVerifiationCodeException();
      } else if (e.code == 'invalid-verification-id') {
        throw InvalidVerificationIdException();
      } else if (e.code == 'too-many-requests') {
        throw TooManyRequestException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }
}
