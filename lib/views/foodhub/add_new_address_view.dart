import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/services/auth/firebase_auth_provider.dart';
import 'package:foodhub/services/cloud/database/cloud_database_constants.dart';
import 'package:foodhub/services/cloud/database/cloud_profile.dart';
import 'package:foodhub/services/cloud/database/firebase_cloud_database.dart';
import 'package:foodhub/utilities/address/country.dart';
import 'package:foodhub/views/foodhub/address_search_screen.dart';

class AddressView extends StatefulWidget {
  const AddressView({super.key});

  @override
  State<AddressView> createState() => _AddressViewState();
}

class _AddressViewState extends State<AddressView> {
  late final FirebaseCloudDatabase _cloudServices;
  late final TextEditingController _name;
  late final TextEditingController _phoneNumber;
  late final TextEditingController _street;

  final FocusNode _focusNodeState = FocusNode();
  final FocusNode _focusNodeCity = FocusNode();
  final FocusNode _focusNodeStreet = FocusNode();
  late final User? _user;
  String selectedCountryCode = '';
  List<csc.State>? countryState;
  String selectedState = '';
  List<csc.City> selectedCity = [];

  @override
  void initState() {
    _cloudServices = FirebaseCloudDatabase();
    _user = FirebaseAuthProvider().currentUser;
    _name = TextEditingController();
    _phoneNumber = TextEditingController();
    _street = TextEditingController();

    _focusNodeState.addListener(() {
      setState(() {});
    });
    _focusNodeCity.addListener(() {
      setState(() {});
    });
    _focusNodeStreet.addListener(
      () {
        setState(() {});
      },
    );
    _getStatesOfCountry().then((state) {
      setState(() {
        countryState = state;
      });
    });
    super.initState();
  }

  void _getCountryCode({required String phoneNumber}) {
    Map<String, String> foundedCountry = {};
    for (var country in Countries.allCountries) {
      String dialCode = country["dial_code"].toString();
      if (phoneNumber.contains(dialCode)) {
        foundedCountry = country;
        selectedCountryCode = foundedCountry['code']!;
      }
    }
  }

  void _nameTextControllerListener() async {
    final name = _name.text;
    final profileRef = await _cloudServices.getProfileRef(uid: _user!.uid);
    if (profileRef != null) {
      await profileRef.update({userNameFieldName: name});
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
    _phoneNumber.removeListener(_phoneNumberTextControllerListener);
    _name.addListener(_nameTextControllerListener);
    _phoneNumber.addListener(_phoneNumberTextControllerListener);
  }

  void _defaultTextControllerValues({
    required String name,
    required String phone,
  }) {
    _name.text = name;
    _phoneNumber.text = phone;
  }

  void _onStreetFieldFocus() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const AddressSearchScreen(),
    ));
  }

  Future<List<csc.State>> _getStatesOfCountry() async {
    return countryState = await csc.getStatesOfCountry(selectedCountryCode);
  }

  @override
  void dispose() {
    _name.dispose();
    _phoneNumber.dispose();
    _street.dispose();
    _focusNodeState.dispose();
    _focusNodeStreet.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return FutureBuilder(
      future: () async {
        final userProfile =
            await _cloudServices.userProfile(ownerUserId: _user!.uid).first;
        final stateData = await _getStatesOfCountry();
        return [userProfile, stateData];
      }(),
      builder: (context, snapshot) {
        _setUpTextControllerListener();
        if (snapshot.hasData) {
          final List data = snapshot.data as List;
          final profiles = data[0] as List<CloudProfile>;
          final userProfile = profiles[0];
          _getCountryCode(phoneNumber: userProfile.phoneNumber);
          _defaultTextControllerValues(
            name: userProfile.userName,
            phone: userProfile.phoneNumber,
          );
          return Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.only(
                  right: 5,
                  left: 16,
                  top: 12,
                  bottom: 11,
                ),
                child: Container(
                  height: screenHeight * 0.04,
                  width: screenWidth * 0.1,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.7),
                          spreadRadius: 1.5,
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
              title: const Text(
                'Add new address',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF111719)),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.02),
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
                          color: const Color(0xFFEEEEEE),
                        ),
                      ),
                      child: Center(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _name.text,
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontFamily: 'SofiaPro',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
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
                        'Mobile Number',
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
                          color: const Color(0xFFEEEEEE),
                        ),
                      ),
                      child: Center(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _phoneNumber.text,
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontFamily: 'SofiaPro',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
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
                        'State',
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
                      width: screenWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: _focusNodeState.hasFocus
                              ? const Color(0xFFFE724C)
                              : const Color(0xFFEEEEEE),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          padding: EdgeInsets.only(
                            left: screenWidth * 0.03,
                            right: screenWidth * 0.03,
                          ),
                          hint: Text(
                            'Select State',
                            style: TextStyle(
                              fontSize: screenWidth * 0.043,
                              fontFamily: 'SofiaPro',
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF111719),
                            ),
                          ),
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            size: screenWidth * 0.04,
                          ),
                          items: countryState!.map((csc.State state) {
                            return DropdownMenuItem(
                              value: state.isoCode,
                              alignment: Alignment.center,
                              child: Text(state.name),
                            );
                          }).toList(),
                          onChanged: (String? newValue) async {
                            if (newValue != null) {
                              selectedState = newValue;
                            }
                            final country = await csc
                                .getCountryFromCode(selectedCountryCode);
                            final selected = await csc.getStateCities(
                                country!.isoCode, selectedState);
                            setState(() {
                              selectedCity = selected;
                            });
                          },
                        ),
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
                        'City',
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
                      width: screenWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: _focusNodeCity.hasFocus
                              ? const Color(0xFFFE724C)
                              : const Color(0xFFEEEEEE),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          padding: EdgeInsets.only(
                            left: screenWidth * 0.03,
                            right: screenWidth * 0.03,
                          ),
                          hint: Text(
                            'Select City',
                            style: TextStyle(
                              fontSize: screenWidth * 0.043,
                              fontFamily: 'SofiaPro',
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF111719),
                            ),
                          ),
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            size: screenWidth * 0.04,
                          ),
                          items: selectedCity.map((csc.City city) {
                            return DropdownMenuItem(
                              value: city.name,
                              alignment: Alignment.center,
                              child: Text(city.name),
                            );
                          }).toList(),
                          onChanged: (String? value) {},
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Padding(
                    padding: EdgeInsets.only(
                      left: screenWidth * 0.05,
                    ),
                    child: SizedBox(
                        width: screenWidth * 0.8,
                        height: screenHeight * 0.03,
                        child: Text(
                          'Street (include house number)',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontFamily: 'SofiaPro',
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9796A1),
                          ),
                        )),
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
                          color: _focusNodeStreet.hasFocus
                              ? const Color(0xFFFE724C)
                              : const Color(0xFFEEEEEE),
                        ),
                      ),
                      child: TextField(
                        controller: _street,
                        focusNode: _focusNodeStreet,
                        keyboardType: TextInputType.streetAddress,
                        enableSuggestions: true,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          hintText: 'Street',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10.0),
                        ),
                        cursorColor: const Color(0xFFFE724C),
                        onTap: _onStreetFieldFocus,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
