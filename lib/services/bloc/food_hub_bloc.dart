import 'package:bloc/bloc.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:foodhub/Google/google_sign_in.dart';
import 'package:foodhub/services/auth/auth_providers.dart';
import 'package:foodhub/services/auth/auth_user.dart';
import 'package:foodhub/services/bloc/food_hub_event.dart';
import 'package:foodhub/services/bloc/food_hub_state.dart';
import 'package:foodhub/services/cloud/cloud_storage.dart';
import 'package:foodhub/views/verification/send_verification_email_code.dart';
import 'package:foodhub/views/verification/email_verification_code_generator.dart';
import 'package:foodhub/views/verification/verification_exception.dart';

class FoodHubBloc extends Bloc<FoodHubEvent, FoodHubState> {
  final AuthProvider provider;
  final CloudStorage storage;
  final BuildContext context;
  FoodHubBloc(this.provider, this.storage, this.context)
      : super(const AuthStateUninitialized(isLoading: true)) {
    on<AuthEventShouldRegister>(
      (event, emit) {
        emit(const AuthStateRegistering(
          exception: null,
          isLoading: false,
        ));
      },
    );
    on<AuthEventShouldSignIn>(
      (event, emit) {
        emit(
          const AuthStateSigningIn(
            exception: null,
            isLoading: false,
          ),
        );
      },
    );
    // forgot password
    on<AuthEventForgotPassword>(
      (event, emit) async {
        emit(const AuthStateForgotPassword(
          exception: null,
          hasSentEmail: false,
          isLoading: false,
        ));
        final email = event.email;
        if (email == null) {
          return; // user just wants to go to forgot-password screen
        }

        // user wants to actually send a forgot-password email
        emit(const AuthStateForgotPassword(
          exception: null,
          hasSentEmail: false,
          isLoading: false,
        ));

        bool didSendEmail;
        Exception? exception;
        try {
          await provider.sendPasswordReset(toEmail: email);
          didSendEmail = true;
          exception = null;
        } on Exception catch (e) {
          didSendEmail = false;
          exception = e;
        }

        emit(AuthStateForgotPassword(
          exception: exception,
          hasSentEmail: didSendEmail,
          isLoading: false,
        ));
      },
    );
    // send email verification
    on<AuthEventVerifyEmailCode>(
      (event, emit) async {
        final verificationCode =
            "${event.codeOne}${event.codeTwo}${event.codeThree}${event.codeFour}";
        emit(
          const AuthStateEmailNeedsVerification(
            isLoading: true,
            exception: null,
          ),
        );
        try {
          final user = provider.currentUser;
          final originalVerificationCode =
              await storage.readVerificationCode(ownerUserId: user!.id);
          if (verificationCode == originalVerificationCode) {
            final HttpsCallable setVerifiedEmail =
                FirebaseFunctions.instance.httpsCallableFromUrl(
              'http://localhost:5000/foodhub-363a9/us-central1/setVerifiedEmail',
            );
            try {
              await setVerifiedEmail.call();
            } on FirebaseException catch (e) {
              emit(
                AuthStateEmailNeedsVerification(
                  isLoading: false,
                  exception: e,
                ),
              );
            }
            emit(
              const AuthStateEmailNeedsVerification(
                isLoading: false,
                exception: null,
              ),
            );
            emit(
              const AuthStatePhoneRegistration(
                isLoading: false,
                exception: null,
              ),
            );
          } else {
            Exception error = InvalidVerifiationCodeException();
            emit(
              AuthStateEmailNeedsVerification(
                isLoading: false,
                exception: error,
              ),
            );
          }
        } on Exception catch (e) {
          emit(
            AuthStateEmailNeedsVerification(
              isLoading: false,
              exception: e,
            ),
          );
        }
      },
    );
    // verify phone
    on<AuthEventVerifyPhone>(
      (event, emit) async {
        final phoneNumber = event.phoneNumber;
        final user = provider.currentUser;
        emit(const AuthStatePhoneRegistration(
          exception: null,
          isLoading: true,
        ));
        if (user != null) {
          try {
            await provider.verifyPhoneNumber(
                phoneNumber: phoneNumber, context: context);
            emit(const AuthStatePhoneRegistration(
              exception: null,
              isLoading: false,
            ));
            emit(
              const AuthStatePhoneNeedsVerification(
                exception: null,
                isLoading: false,
              ),
            );
          } on FirebaseAuthException catch (e) {
            emit(AuthStatePhoneRegistration(
              isLoading: false,
              exception: e,
            ));
          }
        }
      },
    );
    // user enter the code they received on their phone number and then we verify
    on<AuthEventVerifyPhoneCode>(
      (event, emit) async {
        final user = provider.currentUser;
        if (user != null) {
          final verificationCode =
              "${event.codeOne}${event.codeTwo}${event.codeThree}${event.codeFour}${event.codeFive}${event.codeSix}";
          if (event.codeOne == null && event.codeTwo == null) {
            emit(
              const AuthStatePhoneNeedsVerification(
                exception: null,
                isLoading: true,
              ),
            );
            emit(
              const AuthStatePhoneNeedsVerification(
                exception: null,
                isLoading: false,
              ),
            );
            emit(
              AuthStateLoggedIn(
                user: user,
                isLoading: false,
              ),
            );
          } else {
            emit(
              const AuthStatePhoneNeedsVerification(
                exception: null,
                isLoading: true,
              ),
            );
            final verificationId = provider.verificationId;
            final resendToken = provider.resendToken;
            if (verificationId != null) {
              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: verificationId, smsCode: verificationCode);
              await FirebaseAuth.instance.currentUser!
                  .linkWithCredential(credential);
              emit(
                AuthStateLoggedIn(
                  user: user,
                  isLoading: false,
                ),
              );
            }
          }
        }
      },
    );
    // register
    on<AuthEventRegister>(
      (event, emit) async {
        final name = event.name;
        final email = event.email;
        final password = event.password;
        emit(
          const AuthStateRegistering(
            exception: null,
            isLoading: true,
          ),
        );
        try {
          final user = await provider.createUser(
            email: email,
            password: password,
          );

          //store users profile in cloud
          await storage.createNewProfile(
            ownerUserId: user.id,
            name: name,
            email: email,
          );

          //send verificationCode to user email and store in cloud
          final verificationCode = generateRandomCode();
          await sendVerificationEmailCode(
              email: email, verificationCode: verificationCode);
          await storage.storeVerificationCode(
            ownerUserId: user.id,
            verificationCode: verificationCode,
          );
          emit(
            const AuthStateRegistering(
              exception: null,
              isLoading: false,
            ),
          );
          emit(
            const AuthStateEmailNeedsVerification(
              isLoading: false,
              exception: null,
            ),
          );
        } on Exception catch (e) {
          emit(
            AuthStateRegistering(
              exception: e,
              isLoading: false,
            ),
          );
        }
      },
    );
    // google sign in
    on<AuthEventGoogleSignIn>(
      (event, emit) async {
        emit(
          const AuthStateLoggedOut(
              exception: null,
              isLoading: true,
              loadingText: 'Please wait while I sign you in'),
        );
        try {
          final User? user = await googleSignIn();
          final authUser = AuthUser.fromFirebase(user!);

          final name = user.displayName;
          final email = user.email;
          final uid = user.uid;

          await storage.createNewProfile(
            ownerUserId: uid,
            name: name ?? '',
            email: email ?? '',
          );
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
          emit(
            AuthStateLoggedIn(
              user: authUser,
              isLoading: false,
            ),
          );
        } on Exception catch (e) {
          emit(
            AuthStateLoggedOut(
              exception: e,
              isLoading: false,
            ),
          );
        }
      },
    );
    // initialize
    on<AuthEventInitialize>(
      (event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
        } else if (!user.isEmailVerified) {
          emit(
            const AuthStateEmailNeedsVerification(
              isLoading: false,
              exception: null,
            ),
          );
        } else {
          emit(
            AuthStateLoggedIn(
              user: user,
              isLoading: false,
            ),
          );
        }
      },
    );
    // log in
    on<AuthEventLogIn>(
      (event, emit) async {
        emit(
          const AuthStateSigningIn(
            exception: null,
            isLoading: true,
            loadingText: 'Please wait while I log you in',
          ),
        );
        final email = event.email;
        final password = event.password;
        try {
          final user = await provider.logIn(
            email: email,
            password: password,
          );
          if (!user.isEmailVerified) {
            emit(
              const AuthStateSigningIn(
                exception: null,
                isLoading: false,
              ),
            );
            emit(
              const AuthStateEmailNeedsVerification(
                isLoading: false,
                exception: null,
              ),
            );
          } else {
            emit(
              const AuthStateSigningIn(
                exception: null,
                isLoading: false,
              ),
            );
          }
          emit(
            AuthStateLoggedIn(
              user: user,
              isLoading: false,
            ),
          );
        } on Exception catch (e) {
          emit(
            AuthStateSigningIn(
              exception: e,
              isLoading: false,
            ),
          );
        }
      },
    );
    // log out
    on<AuthEventLogOut>(
      (event, emit) async {
        try {
          await provider.logOut();
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
        } on Exception catch (e) {
          emit(
            AuthStateLoggedOut(
              exception: e,
              isLoading: false,
            ),
          );
        }
      },
    );
  }
}
