import 'package:foodhub/views/verification/verification_exception.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

Future<void> sendVerificationEmailCode(
    {required String email, required String verificationCode}) async {
  final smtpServer = gmail('kinsomaz87@gmail.com', 'vrrzvnmdvmadoygw');

  final message = Message()
    ..from = const Address('kinsomaz87@gmail.com', 'FoodHub')
    ..recipients.add(email)
    ..subject = 'Verify your email for FoodHub App'
    ..text = '''Hello,Welcome to FoodHub 
    
Your verification code is: $verificationCode
    
If you didn't ask to verify this address, you can ignore this email
    
Thanks,
    
    
Your FoodHub App team''';

  try {
    await send(message, smtpServer);
  } on MailerException catch (_) {
    throw EmailVerificationCodeException();
  } catch (_) {
    throw EmailVerificationCodeException();
  }
}
