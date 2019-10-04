import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:hpi_flutter/core/data/image.dart' as hpi;

class ImageWidget extends StatelessWidget {
  ImageWidget(
    this.image, {
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.fallbackShowLogo = true,
  }) : assert(fallbackShowLogo != null);

  final hpi.Image image;
  final double width;
  final double height;
  final BoxFit fit;
  final bool fallbackShowLogo;

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      if (fallbackShowLogo) {
        return SizedBox(
          width: width,
          height: height,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Image.asset('assets/logo/logo_text.png'),
          ),
        );
      }
      return Container();
    }

    return Semantics(
      label: image.alt,
      child: CachedNetworkImage(
        fit: fit,
        width: width,
        height: height,
        imageUrl: image.source,
      ),
    );
  }
}
