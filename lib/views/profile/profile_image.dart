import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String? imageUrl;
  final double radius;

  const ProfileImage({
    super.key,
    required this.imageUrl,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl == "") {
      return CircleAvatar(
        radius: radius,
        backgroundImage: const AssetImage(
          "assets/profile_avatar.jpg",
        ),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          backgroundImage: imageProvider,
          radius: radius,
        ),
        placeholder: (context, url) => CircleAvatar(
          backgroundImage: const AssetImage("assets/profile_avatar.jpg"),
          radius: radius,
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    }
  }
}
