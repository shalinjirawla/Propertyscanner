import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:property_scan_pro/utils/Extentions.dart';

class CustomNetworkAvatar extends StatelessWidget {
  String? imageUrl;
  double? radius;

  CustomNetworkAvatar({
    super.key,
    this.imageUrl,
    this.radius = 25,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl!,
      alignment: Alignment.topCenter,
      placeholder: (context, url) => CircleAvatar(
        backgroundImage: const AssetImage("assets/default_profileImage.png"),
        radius: radius,
      ).customShimmer(),
      imageBuilder: (context, image) => CircleAvatar(
        backgroundImage: image,
        radius: radius,
      ),
      errorWidget: (context, url, error) => CircleAvatar(
        backgroundImage: const AssetImage("assets/default_profileImage.png"),
        radius: radius,
      ),
    );
  }
}
