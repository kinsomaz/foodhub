import 'dart:math';

String generateRandomCode() {
  final random = Random();
  final code =
      random.nextInt(10000); //generate a random integer between 0 and 9999

  //Ensure that the code is 4 digits
  return code.toString().padLeft(4, '0');
}
