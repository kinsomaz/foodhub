import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:foodhub/Google/google_sign_in.dart';
import 'package:foodhub/services/auth/auth_providers.dart';
import 'package:foodhub/services/bloc/food_hub_event.dart';
import 'package:foodhub/services/bloc/food_hub_state.dart';
import 'package:foodhub/services/cloud/database/cloud_database.dart';
import 'package:foodhub/services/cloud/database/cloud_database_constants.dart';
import 'package:foodhub/views/verification/send_verification_email_code.dart';
import 'package:foodhub/views/verification/email_verification_code_generator.dart';
import 'package:foodhub/views/verification/verification_exception.dart';

class FoodHubBloc extends Bloc<FoodHubEvent, FoodHubState> {
  final AuthProvider provider;
  final CloudDatabase database;
  final BuildContext context;
  FoodHubBloc(this.provider, this.database, this.context)
      : super(const AuthStateUninitialized(isLoading: true)) {
    // go to the register screen
    on<AuthEventShouldRegister>(
      (event, emit) {
        emit(const AuthStateRegistering(
          exception: null,
          isLoading: false,
        ));
      },
    );
    // go to the sign in screen
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
            isSuccessful: null,
          ),
        );
        try {
          final user = provider.currentUser;
          final originalVerificationCode =
              await database.readVerificationCode(ownerUserId: user!.uid);
          if (verificationCode == originalVerificationCode) {
            emit(
              const AuthStateEmailNeedsVerification(
                isLoading: false,
                exception: null,
                isSuccessful: true,
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
                isSuccessful: null,
              ),
            );
          }
        } on Exception catch (e) {
          emit(
            AuthStateEmailNeedsVerification(
              isLoading: false,
              exception: e,
              isSuccessful: null,
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
        if (phoneNumber == null) {
          emit(const AuthStatePhoneRegistration(
            exception: null,
            isLoading: false,
          ));
        } else {
          emit(const AuthStatePhoneRegistration(
            exception: null,
            isLoading: true,
          ));
        }

        if (user != null && phoneNumber != null) {
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
        User? user = provider.currentUser;
        if (user != null) {
          final verificationCode =
              "${event.codeOne}${event.codeTwo}${event.codeThree}${event.codeFour}${event.codeFive}${event.codeSix}";
          if (event.codeOne == null && event.codeTwo == null) {
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
            if (verificationId != null) {
              try {
                await provider.verifyPhoneCode(
                    verificationId: verificationId,
                    verificationCode: verificationCode);
                final user = provider.currentUser;
                final profileRef = await database.getProfileRef(uid: user!.uid);
                if (profileRef != null) {
                  await profileRef.update({
                    phoneFieldName: user.phoneNumber,
                  });
                }
                emit(
                  AuthStateLoggedIn(
                    user: user,
                    isLoading: false,
                  ),
                );
              } on FirebaseAuthException catch (e) {
                emit(
                  AuthStatePhoneNeedsVerification(
                    exception: e,
                    isLoading: false,
                  ),
                );
              }
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
          await database.createNewProfile(
            ownerUserId: user.uid,
            name: name,
            email: email,
            phone: '',
          );

          //send verificationCode to user email and store in cloud
          final verificationCode = generateRandomCode();
          await sendVerificationEmailCode(
              email: email, verificationCode: verificationCode);
          await database.storeVerificationCode(
            ownerUserId: user.uid,
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
              isSuccessful: null,
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
          User? user = await googleSignIn();
          final name = user!.displayName;
          final email = user.email;
          final uid = user.uid;

          final profileRef = await database.getProfileRef(uid: user.uid);
          if (profileRef == null) {
            await database.createNewProfile(
              ownerUserId: uid,
              name: name ?? '',
              email: email ?? '',
              phone: '',
            );
          }

          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
          if (user.phoneNumber == null || user.phoneNumber == '') {
            emit(
              const AuthStatePhoneRegistration(
                exception: null,
                isLoading: false,
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
        } else if (!user.emailVerified) {
          emit(
            const AuthStateEmailNeedsVerification(
              isLoading: false,
              exception: null,
              isSuccessful: null,
            ),
          );
        } else if (user.phoneNumber == null || user.phoneNumber == "") {
          emit(
            const AuthStatePhoneRegistration(
              exception: null,
              isLoading: false,
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
          if (!user.emailVerified) {
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
                isSuccessful: null,
              ),
            );
          } else if (user.phoneNumber == null || user.phoneNumber == "") {
            emit(
              const AuthStateSigningIn(
                exception: null,
                isLoading: false,
              ),
            );
            emit(
              const AuthStatePhoneRegistration(
                exception: null,
                isLoading: false,
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
