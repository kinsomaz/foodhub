import 'package:foodhub/utilities/address/country.dart';

class CountryCodeClass {
  static final CountryCodeClass _shared = CountryCodeClass._sharedInstances();
  CountryCodeClass._sharedInstances();
  factory CountryCodeClass() => _shared;

  String? getCountryCode({required String phoneNumber}) {
    Map<String, String> foundedCountry = {};
    for (var country in Countries.allCountries) {
      String dialCode = country["dial_code"].toString();
      if (phoneNumber.contains(dialCode)) {
        foundedCountry = country;
        return foundedCountry['code']!;
      }
    }
    return null;
  }
}
