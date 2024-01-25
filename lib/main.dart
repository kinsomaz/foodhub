import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/constants/routes.dart';
import 'package:foodhub/helpers/loading/loading_screen.dart';
import 'package:foodhub/services/auth/firebase_auth_provider.dart';
import 'package:foodhub/services/bloc/food_hub_bloc.dart';
import 'package:foodhub/services/bloc/food_hub_event.dart';
import 'package:foodhub/services/bloc/food_hub_state.dart';
import 'package:foodhub/services/cloud/database/firebase_cloud_database.dart';
import 'package:foodhub/views/foodhub/add_new_address_view.dart';
import 'package:foodhub/views/foodhub/address_search_body.dart';
import 'package:foodhub/views/foodhub/home_screen_view.dart';
import 'package:foodhub/views/foodhub/profile_view.dart';
import 'package:foodhub/views/foodhub/splash_screen.dart';
import 'package:foodhub/views/login_view.dart';
import 'package:foodhub/views/phone_registration_view.dart';
import 'package:foodhub/views/reset_password_view.dart';
import 'package:foodhub/views/sign_up_view.dart';
import 'package:foodhub/views/verification/email_verification_view.dart';
import 'package:foodhub/views/verification/phone_verification_view.dart';
import 'package:foodhub/views/welcome_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Food Hub',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFE724C)),
          useMaterial3: true,
          fontFamily: 'SofiaPro'),
      home: BlocProvider(
        create: (context) => FoodHubBloc(
          FirebaseAuthProvider(),
          FirebaseCloudDatabase(),
          context,
        ),
        child: const HomePage(),
      ),
      routes: {
        profileRoute: (context) => const ProfileView(),
        deliveryAddressRoute: (context) => const AddressView(),
        addressSearchRoute: (context) => const AddressSearchScreen(),
        homeRoute: (context) => const HomeScreenView(),
      },
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    context.read<FoodHubBloc>().add(const AuthEventInitialize());
    return BlocConsumer<FoodHubBloc, FoodHubState>(
      listener: (BuildContext context, FoodHubState state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const HomeScreenView();
        } else if (state is AuthStateEmailNeedsVerification) {
          return const EmailVerificationView();
        } else if (state is AuthStatePhoneRegistration) {
          return const PhoneRegistrationView();
        } else if (state is AuthStatePhoneNeedsVerification) {
          return const PhoneVerificationView();
        } else if (state is AuthStateLoggedOut) {
          return const WelcomeView();
        } else if (state is AuthStateForgotPassword) {
          return const ResetPasswordView();
        } else if (state is AuthStateRegistering) {
          return const SignUpView();
        } else if (state is AuthStateSigningIn) {
          return const LoginView();
        } else {
          return const SplashScreen();
        }
      },
    );
  }
}
