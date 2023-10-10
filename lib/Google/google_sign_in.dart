import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:foodhub/Google/google_sign_in_exception.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<User?> googleSignIn() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  try {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await auth.signInWithCredential(credential);
    final User? user = authResult.user;
    return user;
  } on PlatformException catch (e) {
    if (e.code == 'appleSignInNotSupported') {
      throw SignInWithAppleNotSupportedException();
    }
    if (e.code == 'accountNotFound') {
      throw GoogleSignInAccountNotFoundException();
    }
    if (e.code == 'authenticationFailed') {
      throw GoogleSignInAuthenticationException();
    } else {
      throw GoogleErrorException();
    }
  } catch (e) {
    throw GoogleErrorException();
  }
}
