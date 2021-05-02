import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<void> sendMail(String userEmail, String bookingId) async {
  String username = 'grassrootrentals12@gmail.com';
  String password = 'Password@123';

  final smtpServer = gmail(username, password);
  // Use the SmtpServer class to configure an SMTP server:
  // final smtpServer = SmtpServer('smtp.domain.com');
  // See the named arguments of SmtpServer for further configuration
  // options.

  // Create our message.
  final message = Message()
    ..from = Address(username, "Car Rental")
    ..recipients.add(userEmail)
    ..subject = 'Car Rent'
    ..text = 'Thank you for working with Car Rental'
    ..html =
        "<h1>Car Rental</h1>\n<p>Thank you for renting a car</p>\n<p>Your Booking Id is: $bookingId</p>";

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    print(e);
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}
