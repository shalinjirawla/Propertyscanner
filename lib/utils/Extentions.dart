import 'dart:math';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/custom_snackbar.dart';
import 'AnimatedFlipCounter.dart';
import 'colors.dart';
import 'config.dart';

extension CenterWidget on Widget {
  // center widget extension
  centerExtension() => Center(
        child: this,
      );

  // custom shimmer extension
  Widget customShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.black.withOpacity(0.2),
      highlightColor: transparentColor,
      child: this,
    );
  }
}

class AppGradients {
  // Primary Purple Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF5B4FE9), Color(0xFF8B5CF6)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Vertical variant
  static const LinearGradient primaryGradientVertical = LinearGradient(
    colors: [Color(0xFF5B4FE9), Color(0xFF8B5CF6)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Diagonal variant
  static const LinearGradient primaryGradientDiagonal = LinearGradient(
    colors: [Color(0xFF5B4FE9), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// Extension for applying gradient to text
extension GradientText on Text {
  Widget gradient(Gradient gradient) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: this,
    );
  }
}

extension GradientIcon on Icon {
  Widget gradient(Gradient gradient) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: this,
    );
  }
}

String generate24DigitNumber() {
  final rand = Random.secure();
  return List.generate(24, (_) => rand.nextInt(10).toString()).join();
}
/*extension StringDateExtension on String {
  String toMMDDYYYY() {
    try {
      DateTime date = DateTime.parse(this); // Parse the string to a DateTime
      final String month = date.month.toString().padLeft(2, '0');
      final String day = date.day.toString().padLeft(2, '0');
      final String year = date.year.toString();
      return '$month/$day/$year';
    } catch (e) {
      return '';
    }
  }
}*/
extension GlassWidget<T extends Widget> on T {
  /// .asGlass(): Converts the calling widget into a glass widget.
  ///
  /// Parameters:
  /// * [enabled]: Enable or disable all effects, defaults to true.
  /// * [blurX]: Amount of blur in the direction of the X axis, defaults to 10.0.
  /// * [blurY]: Amount of blur in the direction of the Y axis, defaults to 10.0.
  /// * [tintColor]: Tint color for the glass (defaults to Colors.white).
  /// * [frosted]: Whether this glass should be frosted or not, defaults to true.
  /// * [clipBorderRadius]: The border radius of the rounded corners.
  ///   Values are clamped so that horizontal and vertical radii sums do not exceed width/height.
  ///   This value is ignored if clipper is non-null.
  /// * [clipBehaviour]: Defaults to [Clip.antiAlias].
  /// * [tileMode]: Defines what happens at the edge of a gradient or the sampling of a source image in an [ImageFilter].
  /// * [clipper]: If non-null, determines which clip to use.
  Widget asGlass({
    bool enabled = true,
    double blurX = 10.0,
    double blurY = 10.0,
    Color tintColor = Colors.white,
    bool frosted = true,
    BorderRadius clipBorderRadius = BorderRadius.zero,
    Clip clipBehaviour = Clip.antiAlias,
    TileMode tileMode = TileMode.clamp,
    CustomClipper<RRect>? clipper,
  }) {
    return !enabled
        ? this
        : ClipRRect(
      clipper: clipper,
      clipBehavior: clipBehaviour,
      borderRadius: clipBorderRadius,
      child: BackdropFilter(
        filter: new ImageFilter.blur(
          sigmaX: blurX,
          sigmaY: blurY,
          tileMode: tileMode,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: (tintColor != Colors.transparent)
                ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                tintColor.withOpacity(0.1),
                tintColor.withOpacity(0.08),
              ],
            )
                : null,
            image: frosted
                ? DecorationImage(
              image: AssetImage('images/noise.png', package: 'glass'),
              fit: BoxFit.cover,
            )
                : null,
          ),
          child: this,
        ),
      ),
    );
  }
}
extension strCapitalize on String {
  String StrCapitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

extension priceEtx on double {
  Widget priceText({
    double? size,
    FontWeight? fontWeight,
    Color? color,
    Color? decorationColor,
    TextDecoration? decoration,
    double? letterSpacing,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    int? price,
    //bool? softWrap=true,
  }) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: AnimatedFlipCounter(
        duration: const Duration(milliseconds: 500),
        value: price ?? 0,
        textStyle: TextStyle(
          fontSize: size ?? 16.sp,
          fontWeight: fontWeight ?? FontWeight.w500,
          color: color ?? appBarColor,
          fontFamily: fontFamily,
          decorationColor: decorationColor ?? primaryColor,
          decoration: decoration ?? TextDecoration.none,
          letterSpacing: letterSpacing ?? 0.3,
        ),
        fractionDigits: 0,
        thousandSeparator: ',',
        /* fractionDigits: forDM
            ? 0
            : Get.find<SplashController>().configModel!.digitAfterDecimalPoint!,
        prefix: isRightSide
            ? ''
            : '${Get.find<SplashController>().configModel!.currencySymbol!} ',
        suffix: isRightSide
            ? '${Get.find<SplashController>().configModel!.currencySymbol!} '
            : '',*/
      ),
    );
  }
}

extension strEtx on String {
  Text customText({
    double? size,
    FontWeight? fontWeight,
    Color? color,
    Color? decorationColor,
    TextDecoration? decoration,
    double? letterSpacing,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    //bool? softWrap=true,
  }) {
    return Text(
      this,
      style: TextStyle(
        fontSize: size ?? 16.sp,
        fontWeight: fontWeight ?? FontWeight.w500,
        color: color ?? appBarColor,
        fontFamily: fontFamily,
        decorationColor: decorationColor ?? primaryColor,
        decoration: decoration ?? TextDecoration.none,
        letterSpacing: letterSpacing ?? 0.3,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      //softWrap: softWrap,
      //overflow: TextOverflow.ellipsis,
    );
  }
}

extension strImg on String {
  Widget customImage({
    double? scale,
    double? height,
    double? width,
    Color? color,
    BoxFit? fit,
  }) {
    return Image.asset(
      this,
      scale: scale,
      color: color,
      height: height,
      width: width,
      fit: fit,
    );
  }
}

extension DateFormatting on DateTime {
  String toMMDDYYYY() {
    final String month = this.month.toString().padLeft(2, '0');
    final String day = this.day.toString().padLeft(2, '0');
    final String year = this.year.toString();
    return '$month-$day-$year';
  }
}

extension DurationFormatting on Duration {
  String formatDuration() {
    String hours = inHours.toString().padLeft(2, '0');
    String minutes = (inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }
}

RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
String Function(Match) mathFunc = (Match match) => '${match[1]},';

extension WidgetExtension on Widget? {
  Padding paddingTop(double top) {
    return Padding(padding: EdgeInsets.only(top: top), child: this);
  }

  /// return padding left
  Padding paddingLeft(double left) {
    return Padding(padding: EdgeInsets.only(left: left), child: this);
  }

  /// return padding right
  Padding paddingRight(double right) {
    return Padding(padding: EdgeInsets.only(right: right), child: this);
  }

  /// return padding bottom
  Padding paddingBottom(double bottom) {
    return Padding(padding: EdgeInsets.only(bottom: bottom), child: this);
  }

  /// return padding all
  Padding paddingAll(double padding) {
    return Padding(padding: EdgeInsets.all(padding), child: this);
  }

  /// return custom padding from each side
  Padding paddingOnly({
    double top = 0.0,
    double left = 0.0,
    double bottom = 0.0,
    double right = 0.0,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: this,
    );
  }

  /// return padding symmetric
  Padding paddingSymmetric({double vertical = 0.0, double horizontal = 0.0}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
      child: this,
    );
  }
}

extension IntExtensions on int? {
  /// Leaves given height of space
  Widget get height => SizedBox(height: this?.toDouble());

  /// Leaves given width of space
  Widget get width => SizedBox(width: this?.toDouble());

  // returns month name from the given int
  String toMonthName({bool isHalfName = false}) {
    String status = '';
    if (!(this! >= 1 && this! <= 12)) {
      throw Exception('Invalid day of month');
    }
    if (this == 1) {
      return status = isHalfName ? 'Jan' : 'January';
    } else if (this == 2) {
      return status = isHalfName ? 'Feb' : 'February';
    } else if (this == 3) {
      return status = isHalfName ? 'Mar' : 'March';
    } else if (this == 4) {
      return status = isHalfName ? 'Apr' : 'April';
    } else if (this == 5) {
      return status = isHalfName ? 'May' : 'May';
    } else if (this == 6) {
      return status = isHalfName ? 'Jun' : 'June';
    } else if (this == 7) {
      return status = isHalfName ? 'Jul' : 'July';
    } else if (this == 8) {
      return status = isHalfName ? 'Aug' : 'August';
    } else if (this == 9) {
      return status = isHalfName ? 'Sept' : 'September';
    } else if (this == 10) {
      return status = isHalfName ? 'Oct' : 'October';
    } else if (this == 11) {
      return status = isHalfName ? 'Nov' : 'November';
    } else if (this == 12) {
      return status = isHalfName ? 'Dec' : 'December';
    }
    return status;
  }

  // returns WeekDay from the given int
  String toWeekDay({bool isHalfName = false}) {
    if (!(this! >= 1 && this! <= 7)) {
      throw Exception('Invalid day of month');
    }
    String weekName = '';

    if (this == 1) {
      return weekName = isHalfName ? "Mon" : "Monday";
    } else if (this == 2) {
      return weekName = isHalfName ? "Tue" : "Tuesday";
    } else if (this == 3) {
      return weekName = isHalfName ? "Wed" : "Wednesday";
    } else if (this == 4) {
      return weekName = isHalfName ? "Thu" : "Thursday";
    } else if (this == 5) {
      return weekName = isHalfName ? "Fri" : "Friday";
    } else if (this == 6) {
      return weekName = isHalfName ? "Sat" : "Saturday";
    } else if (this == 7) {
      return weekName = isHalfName ? "Sun" : "Sunday";
    }
    return weekName;
  }

  /// Returns true if given value is 1, else returns false
  bool getBoolInt() {
    if (this == 1) {
      return true;
    }
    return false;
  }
}

TextStyle primaryTextStyle({
  int? size,
  Color? color,
  FontWeight? weight,
  //String? fontFamily,
  double? letterSpacing,
  FontStyle? fontStyle,
  double? wordSpacing,
  TextDecoration? decoration,
  TextDecorationStyle? textDecorationStyle,
  TextBaseline? textBaseline,
  Color? decorationColor,
  Color? backgroundColor,
  double? height,
}) {
  return TextStyle(
    fontSize: size != null ? size.toDouble() : 13,
    color: color ?? appBarColor,
    fontWeight: weight ?? FontWeight.w400,
    fontFamily: fontFamily,
    letterSpacing: letterSpacing,
    fontStyle: fontStyle,
    decoration: decoration,
    decorationStyle: textDecorationStyle,
    decorationColor: decorationColor,
    wordSpacing: wordSpacing,
    textBaseline: textBaseline,
    backgroundColor: backgroundColor,
    height: height,
  );
}

TextStyle secondaryTextStyle({
  int? size,
  Color? color,
  FontWeight? weight,
  //String? fontFamily,
  double? letterSpacing,
  FontStyle? fontStyle,
  double? wordSpacing,
  TextDecoration? decoration,
  TextDecorationStyle? textDecorationStyle,
  TextBaseline? textBaseline,
  Color? decorationColor,
  Color? backgroundColor,
  double? height,
}) {
  return TextStyle(
    fontSize: size != null ? size.toDouble() : 13,
    color: color ?? appBarColor,
    fontWeight: weight ?? FontWeight.w400,
    fontFamily: fontFamily,
    letterSpacing: letterSpacing,
    fontStyle: fontStyle,
    decoration: decoration,
    decorationStyle: textDecorationStyle,
    decorationColor: decorationColor,
    wordSpacing: wordSpacing,
    textBaseline: textBaseline,
    backgroundColor: backgroundColor,
    height: height,
  );
}

class CircleThumbShape extends RangeSliderThumbShape {
  const CircleThumbShape({this.thumbRadius = 10.0});

  final double thumbRadius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required SliderThemeData sliderTheme,
    bool? isDiscrete,
    bool? isEnabled,
    bool? isOnTop,
    TextDirection? textDirection,
    Thumb? thumb,
    bool? isPressed,
  }) {
    final Canvas canvas = context.canvas;

    final Paint fillPaint = Paint()
      ..color = white
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    canvas
      ..drawCircle(center, thumbRadius, fillPaint)
      ..drawCircle(center, thumbRadius, borderPaint);
  }
}

String extractedVideoId(String url) {
  final RegExp regExp = RegExp(
    r'((?<=(v|V)/)|(?<=be/)|(?<=(\?|&)v=)|(?<=embed/)|(?<=watch\?v=)|(?<=\?v=)|(?<=&v=)|(?<=/v/)|(?<=youtu.be/)|(?<=/embed/)|(?<=/shorts/))([^#&?]*)(?:(?=[?&])|$)',
  );
  final match = regExp.firstMatch(url);
  return match?.group(0) ?? 'Video ID not found';
}

class HorizontalList extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double? spacing;
  final double? runSpacing;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final bool reverse;
  final ScrollController? controller;

  final WrapAlignment? wrapAlignment;
  final WrapCrossAlignment? crossAxisAlignment;

  HorizontalList({
    required this.itemCount,
    required this.itemBuilder,
    this.spacing,
    this.runSpacing,
    this.padding,
    this.physics,
    this.controller,
    this.reverse = false,
    this.wrapAlignment,
    this.crossAxisAlignment,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: physics,
      padding: padding ?? EdgeInsets.all(8),
      scrollDirection: Axis.horizontal,
      reverse: reverse,
      controller: controller,
      child: Wrap(
        spacing: spacing ?? 8,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        direction: Axis.horizontal,
        runAlignment: wrapAlignment ?? WrapAlignment.start,
        crossAxisAlignment: crossAxisAlignment ?? WrapCrossAlignment.start,
        runSpacing: runSpacing ?? 8,
        children: List.generate(
          itemCount,
          (index) => itemBuilder(context, index),
        ),
      ),
    );
  }
}

/*
final Map<String, int> countryPhoneLengths = {
  '1': 10, // USA, Canada, etc.
  '91': 10, // India
  '44': 10, // UK
  '61': 9, // Australia
  '49': 11, // Germany
  '33': 9, // France
  '39': 10, // Italy
  '81': 10, // Japan
  '86': 11, // China
  '7': 10, // Russia
  '55': 11, // Brazil
  '34': 9, // Spain
  '27': 9, // South Africa
  '82': 10, // South Korea
  '46': 9, // Sweden
  '31': 9, // Netherlands
  '351': 9, // Portugal
  '90': 10, // Turkey
  '52': 10, // Mexico
  '234': 10, // Nigeria
  '62': 10, // Indonesia
  '63': 10, // Philippines
  '60': 10, // Malaysia
  '65': 8, // Singapore
  '41': 9, // Switzerland
  '353': 9, // Ireland
  '98': 10, // Iran
  '964': 10, // Iraq
  '971': 9, // UAE
  '92': 10, // Pakistan
  '94': 9, // Sri Lanka
  '66': 9, // Thailand
  '372': 8, // Estonia
  '48': 9, // Poland
  '45': 8, // Denmark
  '43': 10, // Austria
  '36': 9, // Hungary
  '358': 9, // Finland
  '64': 9, // New Zealand
};
*/
/*
final Map<String, int> countryPhoneLengthRange = {
  '1': 10, // 1 + 10 digits
  '91': 10, // 91 + 10 digits
  '44': 10, // 44 + 10 digits
  '43': 10, // 43 + 10 digits
  '32': 9, // 32 + 9 digits
  '359': 9, // 359 + 9 digits
  '385': 9, // 385 + 9 digits
  '357': 8, // 357 + 8 digits
  '420': 9, // 420 + 9 digits
  '45': 8, // 45 + 8 digits
  '372': 8, // 372 + 8 digits
  '358': 10, // 358 + 10 digits
  '33': 9, // 33 + 9 digits
  '49': 11, // 49 + 11 digits
  '30': 10, // 30 + 10 digits
  '36': 9, // 36 + 9 digits
};
*/
final Map<String, int> countryPhoneLengthRange = {
  '1': 10, // US, Canada (NANP: +1 + 10 digits)
  '91': 10, // India: +91 + 10 digits
  '44': 10, // United Kingdom: +44 + 10 digits
  '43': 9, // Austria: +43 + 9 digits
  '32': 9, // Belgium: +32 + 9 digits
  '359': 9, // Bulgaria: +359 + 9 digits
  '385': 9, // Croatia: +385 + 9 digits
  '357': 8, // Cyprus: +357 + 8 digits
  '420': 9, // Czechia: +420 + 9 digits
  '45': 8, // Denmark: +45 + 8 digits
  '372': 8, // Estonia: +372 + 8 digits
  '358': 10, // Finland: +358 + 10 digits
  '33': 9, // France: +33 + 9 digits
  '49': 11, // Germany: +49 + 11 digits
  '30': 10, // Greece: +30 + 10 digits
  '36': 9, // Hungary: +36 + 9 digits
  '353': 9, // Ireland: +353 + 9 digits
  '39': 10, // Italy: +39 + 10 digits
  '371': 8, // Latvia: +371 + 8 digits
  '370': 8, // Lithuania: +370 + 8 digits
  '352': 8, // Luxembourg: +352 + 8 digits
  '356': 8, // Malta: +356 + 8 digits
  '31': 9, // Netherlands: +31 + 9 digits
  '48': 9, // Poland: +48 + 9 digits
  '351': 9, // Portugal: +351 + 9 digits
  '40': 9, // Romania: +40 + 9 digits
  '421': 9, // Slovakia: +421 + 9 digits
  '386': 8, // Slovenia: +386 + 8 digits
  '34': 9, // Spain: +34 + 9 digits
  '46': 9, // Sweden: +46 + 9 digits
  '52': 10, // Mexico: +52 + 10 digits
  '55': 10 // Brazil: +55 + 10 digits
};

getCountryCode(
    {BuildContext? context,
      List<String>? countryFilter,
      void Function(Country)? onSelect}) {

  showCountryPicker(
    context: context!,
    countryFilter: countryFilter,
    countryListTheme: CountryListThemeData(
      flagSize: 30,
      backgroundColor: Colors.white,
      textStyle: TextStyle(
        fontSize: 13.sp,
        color: appBarColor,
        fontFamily: fontFamily,
        fontWeight: FontWeight.w500,
      ),
      bottomSheetHeight: 500,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      inputDecoration: InputDecoration(
        hintText: 'Search...',
        hintStyle: const TextStyle(fontFamily: fontFamily, letterSpacing: 0.4),
        prefixIcon: const Icon(Icons.search, color: appBarColor),
        fillColor: containerColor,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
    onSelect: onSelect!,
  );
}

String generateTimestampFilename() {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  return 'image_$timestamp.png';
}

Future<bool> checkInternetConnection() async {
  final connectivityResult = await Connectivity().checkConnectivity();

  if (connectivityResult.contains(ConnectivityResult.none)) {
    showWarningSnackBar(
      message: 'Please check your internet connection',
    );
    return false;
  }

  return true;
}


Future<void> openUrl(String url) async {
  try {
    if (!url.startsWith('http')) {
      url = 'https://$url';
    }

    final uri = Uri.parse(url);

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      showWarningSnackBar(message: 'Unable to open link');
    }
  } catch (e) {
    showWarningSnackBar(message: 'Invalid link');
  }
}
