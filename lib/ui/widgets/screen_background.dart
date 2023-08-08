import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utilitys/assets_utils.dart';

class ScreenBackground extends StatelessWidget {
  final Widget child;
  const ScreenBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Stack(
      children: <Widget>[
        SizedBox(
          height: size.height,
          width: size.width,
          child: SvgPicture.asset(
            AssetsUtils.bgImageSVG,
            fit: BoxFit.cover,
          ),
        ),
        child,
      ],
    );
  }
}
