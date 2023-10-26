import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/services/auth/firebase_auth_provider.dart';
import 'package:foodhub/services/cloud/database/cloud_database_constants.dart';
import 'package:foodhub/services/cloud/database/cloud_profile.dart';
import 'package:foodhub/services/cloud/database/firebase_cloud_database.dart';
import 'package:foodhub/services/cloud/storage/firebase_cloud_storage.dart';
import 'package:foodhub/views/foodhub/conditional_network_image.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final FirebaseCloudDatabase _cloudServices;
  late final FirebaseCloudStorage _cloudStorage;
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phoneNumber;
  late final User? _user;
  final FocusNode _focusNodeName = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePhone = FocusNode();

  @override
  void initState() {
    _cloudServices = FirebaseCloudDatabase();
    _cloudStorage = FirebaseCloudStorage();
    _name = TextEditingController();
    _email = TextEditingController();
    _phoneNumber = TextEditingController();
    _user = FirebaseAuthProvider().currentUser;
    _focusNodeName.addListener(() {
      setState(() {});
    });
    _focusNodeEmail.addListener(() {
      setState(() {});
    });
    _focusNodePhone.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  void _nameTextControllerListener() async {
    final name = _name.text;
    final profileRef = await _cloudServices.getProfileRef(uid: _user!.uid);
    if (profileRef != null) {
      await profileRef.update({userNameFieldName: name});
    }
  }

  void _emailTextControllerListener() async {
    final email = _email.text;
    final profileRef = await _cloudServices.getProfileRef(uid: _user!.uid);
    if (profileRef != null) {
      await profileRef.update({emailFieldName: email});
    }
  }

  void _phoneNumberTextControllerListener() async {
    final phoneNumber = _phoneNumber.text;
    final profileRef = await _cloudServices.getProfileRef(uid: _user!.uid);
    if (profileRef != null) {
      await profileRef.update({phoneFieldName: phoneNumber});
    }
  }

  void _setUpTextControllerListener() {
    _name.removeListener(_nameTextControllerListener);
    _email.removeListener(_emailTextControllerListener);
    _phoneNumber.removeListener(_phoneNumberTextControllerListener);
    _name.addListener(_nameTextControllerListener);
    _email.addListener(_emailTextControllerListener);
    _phoneNumber.addListener(_phoneNumberTextControllerListener);
  }

  void _defaultTextControllerValues({
    required String name,
    required String email,
    required String phone,
  }) {
    _name.text = name;
    _email.text = email;
    _phoneNumber.text = phone;
  }

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final profileImageUrl = await _cloudStorage.uploadProfileImage(
        pickedFile: pickedFile,
        userId: _user!.uid,
      );
      final profileRef = await _cloudServices.getProfileRef(uid: _user!.uid);
      if (profileRef != null) {
        await profileRef.update({
          profileImageUrlFieldName: profileImageUrl,
        });
      }
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phoneNumber.dispose();
    _focusNodeName.dispose();
    _focusNodeEmail.dispose();
    _focusNodePhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder(
      stream: _cloudServices.userProfile(ownerUserId: _user!.uid),
      builder: (drawercontext, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
            _setUpTextControllerListener();
            if (snapshot.hasData) {
              final profiles = snapshot.data as List<CloudProfile>;
              final userProfile = profiles[0];
              _defaultTextControllerValues(
                name: userProfile.userName,
                email: userProfile.userEmail,
                phone: userProfile.phoneNumber,
              );
              return Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: screenHeight * 0.06,
                          left: screenWidth * 0.05,
                        ),
                        child: Container(
                          height: screenHeight * 0.045,
                          width: screenWidth * 0.1,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                )
                              ]),
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            padding: EdgeInsets.only(
                              left: screenWidth * 0.015,
                            ),
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: screenWidth * 0.05,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      GestureDetector(
                        onTap: () async {
                          await _pickImage();
                        },
                        child: Center(
                          child: Stack(
                            children: <Widget>[
                              ConditionalNetworkImage(
                                imageUrl: userProfile.profileImageUrl,
                                radius: screenWidth * 0.125,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: screenWidth * 0.05,
                                    color: const Color(0xFFB3B3B3),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      Center(
                        child: Text(
                          userProfile.userName,
                          style: TextStyle(
                            fontSize: screenWidth * 0.06,
                            fontFamily: 'SofiaPro',
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF000000),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.001),
                      Center(
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            fontFamily: 'SofiaPro',
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9796A1),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth * 0.05,
                        ),
                        child: SizedBox(
                          width: screenWidth * 0.25,
                          height: screenHeight * 0.03,
                          child: Text(
                            'Full name',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontFamily: 'SofiaPro',
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF9796A1),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth * 0.05,
                          right: screenWidth * 0.05,
                          top: screenHeight * 0.01,
                        ),
                        child: Container(
                          height: screenHeight * 0.07,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: _focusNodeName.hasFocus
                                  ? const Color(0xFFFE724C)
                                  : const Color(0xFFEEEEEE),
                            ),
                          ),
                          child: TextField(
                            controller: _name,
                            focusNode: _focusNodeName,
                            keyboardType: TextInputType.name,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10.0),
                            ),
                            cursorColor: const Color(0xFFFE724C),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth * 0.05,
                        ),
                        child: SizedBox(
                          width: screenWidth * 0.25,
                          height: screenHeight * 0.03,
                          child: Text(
                            'E-mail',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontFamily: 'SofiaPro',
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF9796A1),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth * 0.05,
                          right: screenWidth * 0.05,
                          top: screenHeight * 0.01,
                        ),
                        child: Container(
                          height: screenHeight * 0.07,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: _focusNodeEmail.hasFocus
                                  ? const Color(0xFFFE724C)
                                  : const Color(0xFFEEEEEE),
                            ),
                          ),
                          child: TextField(
                            controller: _email,
                            focusNode: _focusNodeEmail,
                            keyboardType: TextInputType.emailAddress,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10.0),
                            ),
                            cursorColor: const Color(0xFFFE724C),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth * 0.05,
                        ),
                        child: SizedBox(
                          width: screenWidth * 0.6,
                          height: screenHeight * 0.03,
                          child: Text(
                            'Phone Number',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontFamily: 'SofiaPro',
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF9796A1),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth * 0.05,
                          right: screenWidth * 0.05,
                          top: screenHeight * 0.01,
                        ),
                        child: Container(
                          height: screenHeight * 0.07,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: _focusNodePhone.hasFocus
                                  ? const Color(0xFFFE724C)
                                  : const Color(0xFFEEEEEE),
                            ),
                          ),
                          child: TextField(
                            controller: _phoneNumber,
                            focusNode: _focusNodePhone,
                            keyboardType: TextInputType.phone,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10.0),
                            ),
                            cursorColor: const Color(0xFFFE724C),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          default:
            return Center(
              child: Container(
                  constraints: const BoxConstraints(
                    maxHeight: 10,
                    maxWidth: 10,
                  ),
                  child: const CircularProgressIndicator()),
            );
        }
      },
    );
  }
}
