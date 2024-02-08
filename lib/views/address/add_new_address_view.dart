// import 'package:country_state_city/country_state_city.dart' as csc;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:foodhub/services/auth/firebase_auth_provider.dart';
// import 'package:foodhub/services/cloud/database/cloud_database_constants.dart';
// import 'package:foodhub/services/cloud/database/cloud_profile.dart';
// import 'package:foodhub/services/cloud/database/firebase_cloud_database.dart';
// import 'package:foodhub/utilities/address/country.dart';
// import 'package:foodhub/views/address/address_search_body.dart';

// class AddressView extends StatefulWidget {
//   const AddressView({super.key});

//   @override
//   State<AddressView> createState() => _AddressViewState();
// }

// class _AddressViewState extends State<AddressView> {
//   late final FirebaseCloudDatabase _cloudServices;
//   late final TextEditingController _name;
//   late final TextEditingController _phoneNumber;
//   late final TextEditingController _street;

//   final FocusNode _focusNodeState = FocusNode();
//   final FocusNode _focusNodeCity = FocusNode();
//   final FocusNode _focusNodeStreet = FocusNode();
//   late final User? _user;
//   String selectedCountryIsoCode = '';
//   String? _userState;
//   String? _userCity;
//   List<csc.State>? countryState;
//   List<csc.City>? stateCities;
//   String? selectedState;
//   String? selectedCity;

//   @override
//   void initState() {
//     _cloudServices = FirebaseCloudDatabase();
//     _user = FirebaseAuthProvider().currentUser;
//     _name = TextEditingController();
//     _phoneNumber = TextEditingController();
//     _street = TextEditingController();

//     _focusNodeState.addListener(() {
//       setState(() {});
//     });
//     _focusNodeCity.addListener(() {
//       setState(() {});
//     });
//     _focusNodeStreet.addListener(
//       () {
//         setState(() {});
//       },
//     );
//     super.initState();
//   }

//   void _getCountryCode({required String phoneNumber}) async {
//     Map<String, String> foundedCountry = {};
//     for (var country in Countries.allCountries) {
//       String dialCode = country["dial_code"].toString();
//       if (phoneNumber.contains(dialCode)) {
//         foundedCountry = country;
//         selectedCountryIsoCode = foundedCountry['code']!;
//       }
//     }
//     return null;
//   }

//   void _defaultTextControllerValues({
//     required String name,
//     required String phone,
//   }) {
//     _name.text = name;
//     _phoneNumber.text = phone;
//   }

//   void _updateStateInDatabase({
//     required String state,
//   }) async {
//     final profileRef = await _cloudServices.getProfileRef(uid: _user!.uid);
//     if (profileRef != null) {
//       await profileRef.update({stateFieldName: state});
//     }
//   }

//   void _updateCityInDatabase({
//     required String city,
//   }) async {
//     final profileRef = await _cloudServices.getProfileRef(uid: _user!.uid);
//     if (profileRef != null) {
//       await profileRef.update({cityFieldName: city});
//     }
//   }

//   void _onStreetFieldFocus() {
//     Navigator.of(context).push(MaterialPageRoute(
//       builder: (context) => const AddressSearchScreen(),
//     ));
//   }

//   Future<List<csc.State>> _getStatesOfCountry() async {
//     return countryState = await csc.getStatesOfCountry(selectedCountryIsoCode);
//   }

//   Future<List<csc.City>> _getCitiesOfState() async {
//     return stateCities =
//         await csc.getStateCities(selectedCountryIsoCode, _userState!);
//   }

//   @override
//   void dispose() {
//     _name.dispose();
//     _phoneNumber.dispose();
//     _street.dispose();
//     _focusNodeState.dispose();
//     _focusNodeCity.dispose();
//     _focusNodeStreet.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       appBar: AppBar(
//         leading: Padding(
//           padding: const EdgeInsets.only(
//             right: 9,
//             left: 16,
//             top: 10,
//             bottom: 16,
//           ),
//           child: Container(
//             height: screenHeight * 0.04,
//             width: screenWidth * 0.08,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5.0),
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.7),
//                     spreadRadius: 1.5,
//                     blurRadius: 7,
//                     offset: const Offset(0, 3),
//                   )
//                 ]),
//             child: IconButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               padding: EdgeInsets.only(
//                 left: screenWidth * 0.015,
//               ),
//               icon: Icon(
//                 Icons.arrow_back_ios,
//                 size: screenWidth * 0.05,
//               ),
//             ),
//           ),
//         ),
//         title: const Text(
//           'Add new address',
//           style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w400,
//               color: Color(0xFF111719)),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: StreamBuilder<Object>(
//             stream: _cloudServices.userProfile(ownerUserId: _user!.uid),
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 final profiles = snapshot.data as List<CloudProfile>;
//                 final userProfile = profiles[0];
//                 _defaultTextControllerValues(
//                   name: userProfile.userName,
//                   phone: userProfile.phoneNumber,
//                 );
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     SizedBox(height: screenHeight * 0.02),
//                     Padding(
//                       padding: EdgeInsets.only(
//                         left: screenWidth * 0.05,
//                       ),
//                       child: SizedBox(
//                         width: screenWidth * 0.25,
//                         height: screenHeight * 0.03,
//                         child: Text(
//                           'Full name',
//                           style: TextStyle(
//                             fontSize: screenWidth * 0.04,
//                             fontFamily: 'SofiaPro',
//                             fontWeight: FontWeight.w400,
//                             color: const Color(0xFF9796A1),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(
//                         left: screenWidth * 0.05,
//                         right: screenWidth * 0.05,
//                         top: screenHeight * 0.01,
//                       ),
//                       child: Container(
//                         height: screenHeight * 0.07,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10.0),
//                           border: Border.all(
//                             color: const Color(0xFFEEEEEE),
//                           ),
//                         ),
//                         child: Center(
//                           child: Align(
//                             alignment: Alignment.centerLeft,
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 _name.text,
//                                 style: TextStyle(
//                                   fontSize: screenWidth * 0.045,
//                                   fontFamily: 'SofiaPro',
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: screenHeight * 0.03),
//                     Padding(
//                       padding: EdgeInsets.only(
//                         left: screenWidth * 0.05,
//                       ),
//                       child: SizedBox(
//                         width: screenWidth * 0.6,
//                         height: screenHeight * 0.03,
//                         child: Text(
//                           'Mobile Number',
//                           style: TextStyle(
//                             fontSize: screenWidth * 0.04,
//                             fontFamily: 'SofiaPro',
//                             fontWeight: FontWeight.w400,
//                             color: const Color(0xFF9796A1),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(
//                         left: screenWidth * 0.05,
//                         right: screenWidth * 0.05,
//                         top: screenHeight * 0.01,
//                       ),
//                       child: Container(
//                         height: screenHeight * 0.07,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10.0),
//                           border: Border.all(
//                             color: const Color(0xFFEEEEEE),
//                           ),
//                         ),
//                         child: Center(
//                           child: Align(
//                             alignment: Alignment.centerLeft,
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 _phoneNumber.text,
//                                 style: TextStyle(
//                                   fontSize: screenWidth * 0.045,
//                                   fontFamily: 'SofiaPro',
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: screenHeight * 0.03),
//                     Padding(
//                       padding: EdgeInsets.only(
//                         left: screenWidth * 0.05,
//                       ),
//                       child: SizedBox(
//                         width: screenWidth * 0.25,
//                         height: screenHeight * 0.03,
//                         child: Text(
//                           'State',
//                           style: TextStyle(
//                             fontSize: screenWidth * 0.04,
//                             fontFamily: 'SofiaPro',
//                             fontWeight: FontWeight.w400,
//                             color: const Color(0xFF9796A1),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(
//                         left: screenWidth * 0.05,
//                         right: screenWidth * 0.05,
//                         top: screenHeight * 0.01,
//                       ),
//                       child: Container(
//                           height: screenHeight * 0.07,
//                           width: screenWidth,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10.0),
//                             border: Border.all(
//                               color: _focusNodeState.hasFocus
//                                   ? const Color(0xFFFE724C)
//                                   : const Color(0xFFEEEEEE),
//                             ),
//                           ),
//                           child: const TextField()),
//                     ),
//                     SizedBox(height: screenHeight * 0.03),
//                     Padding(
//                       padding: EdgeInsets.only(
//                         left: screenWidth * 0.05,
//                       ),
//                       child: SizedBox(
//                         width: screenWidth * 0.25,
//                         height: screenHeight * 0.03,
//                         child: Text(
//                           'City',
//                           style: TextStyle(
//                             fontSize: screenWidth * 0.04,
//                             fontFamily: 'SofiaPro',
//                             fontWeight: FontWeight.w400,
//                             color: const Color(0xFF9796A1),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(
//                         left: screenWidth * 0.05,
//                         right: screenWidth * 0.05,
//                         top: screenHeight * 0.01,
//                       ),
//                       child: Container(
//                           height: screenHeight * 0.07,
//                           width: screenWidth,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10.0),
//                             border: Border.all(
//                               color: _focusNodeState.hasFocus
//                                   ? const Color(0xFFFE724C)
//                                   : const Color(0xFFEEEEEE),
//                             ),
//                           ),
//                           child: const TextField()),
//                     ),
//                     SizedBox(height: screenHeight * 0.03),
//                     Padding(
//                       padding: EdgeInsets.only(
//                         left: screenWidth * 0.05,
//                       ),
//                       child: SizedBox(
//                           width: screenWidth * 0.8,
//                           height: screenHeight * 0.03,
//                           child: Text(
//                             'Street (include house number)',
//                             style: TextStyle(
//                               fontSize: screenWidth * 0.04,
//                               fontFamily: 'SofiaPro',
//                               fontWeight: FontWeight.w400,
//                               color: const Color(0xFF9796A1),
//                             ),
//                           )),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(
//                         left: screenWidth * 0.05,
//                         right: screenWidth * 0.05,
//                         top: screenHeight * 0.01,
//                       ),
//                       child: Container(
//                         height: screenHeight * 0.07,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10.0),
//                           border: Border.all(
//                             color: _focusNodeStreet.hasFocus
//                                 ? const Color(0xFFFE724C)
//                                 : const Color(0xFFEEEEEE),
//                           ),
//                         ),
//                         child: TextField(
//                           controller: _street,
//                           focusNode: _focusNodeStreet,
//                           keyboardType: TextInputType.streetAddress,
//                           enableSuggestions: true,
//                           autocorrect: false,
//                           decoration: const InputDecoration(
//                             hintText: 'Street',
//                             border: InputBorder.none,
//                             contentPadding: EdgeInsets.all(10.0),
//                           ),
//                           cursorColor: const Color(0xFFFE724C),
//                           onTap: _onStreetFieldFocus,
//                           onTapOutside: (event) {
//                             _focusNodeStreet.unfocus();
//                           },
//                         ),
//                       ),
//                     )
//                   ],
//                 );
//               } else {
//                 return Container();
//               }
//             }),
//       ),
//     );
//   }
// }
