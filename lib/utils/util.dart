import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:url_launcher/url_launcher.dart';

Future<XFile> PickFile({bool? isImage, bool? isCamera = false}) async {
  final ImagePicker picker = ImagePicker();

  if (isCamera!) {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    return image!;
  } else {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );
    return image!;
  }
}

Future<void> launchUrls({String? url}) async {
  if (await canLaunchUrl(Uri.parse(url!))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}

extension CurrencyFormatting on int {
  String toCurrency({String locale = 'en_US'}) {
    return NumberFormat.currency(
      locale: locale,
      symbol: '',
      decimalDigits: 0,
    ).format(this);
  }
}

extension CurrencyDoubleFormatting on double {
  String toCurrencyDouble({String locale = 'en_US', int? isDigit}) {
    return NumberFormat.currency(
      locale: locale,
      symbol: '',
      decimalDigits: isDigit ?? 2,
    ).format(this);
  }
}

String formatNumber(double marketCap) {
  if ((marketCap / 1000000).toInt() > 0) {
    marketCap /= 1000000;
    return '${marketCap.toCurrencyDouble()}T';
  } else if ((marketCap / 100).toInt() > 0) {
    marketCap /= 1000;
    return '${marketCap.toCurrencyDouble()}B';
  } else {
    return '${marketCap.toCurrencyDouble()}M';
  }
}

/*void openWhatsapp(
    {required BuildContext context,
    required String text,
    required String number}) async {
  var whatsapp = number;
  var whatsappURlAndroid = "whatsapp://send?text=$text"; //phone=$whatsapp&
  var whatsappURLIos = "https://wa.me/$whatsapp?text=${Uri.tryParse(text)}";
  if (GetPlatform.isIOS) {
    // for iOS phone only
    if (await canLaunchUrl(Uri.parse(whatsappURLIos))) {
      await launchUrl(Uri.parse(
        whatsappURLIos,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Whatsapp not installed")));
    }
  } else {
    // android , web
    if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
      await launchUrl(Uri.parse(whatsappURlAndroid));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Whatsapp not installed")));
    }
  }
}*/
void openWhatsapp(String text) async {
  String url = "https://wa.me/?text=${Uri.encodeComponent(text)}";
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } else {
    print("Could not open WhatsApp");
  }
}
/*void launchEmailSubmission({String? attachmentPath, body, subject}) async {
  final Email email = Email(
    body: body,
    subject: subject,
    recipients: ['capermint2024@gmail.com'],
    attachmentPaths: attachmentPath != null ? [attachmentPath!] : null,
    isHTML: false,
  );

  try {
    await FlutterEmailSender.send(email);
    print('Email sent successfully');
  } catch (error) {
    print('Error sending email: $error');
  }
}*/

void launchWhatsApp({required String phone}) async {
  final String url = 'https://wa.me/$phone';
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> openLocationSettings() async {
  const url = 'app-settings:location';
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}

void sendSMS({required String phone, required String message}) async {
  final String encodedMessage = message.replaceAll('\n', '%0A');
  final Uri uri = Uri.parse("sms:?body=$encodedMessage"); //$phone
  /*final Uri uri = Uri(
      scheme: 'sms',
      path: phone,
      queryParameters: {'body': Uri.encodeComponent(message)}
      //queryParameters: {'body': message},
      );*/
  if (await canLaunchUrl(Uri.parse(uri.toString()))) {
    await launchUrl(Uri.parse(uri.toString()));
  } else {
    throw 'Could not launch $uri';
  }
}
