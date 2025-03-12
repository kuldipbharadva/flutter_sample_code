import 'package:flutter/material.dart';
import 'package:fluttersampleapp/core/utils/image_constants.dart';

class CommonContainerBgWidget extends StatelessWidget {
  const CommonContainerBgWidget({
    super.key,
    required this.child,
    this.height = double.infinity,
  });

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(icBgBlue),
        child,
      ],
    );
  }
}
