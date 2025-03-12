import 'package:flutter/material.dart';

class BgGradientWidget extends StatelessWidget {
  const BgGradientWidget({
    super.key,
    required this.child,
    this.borderRadius = 0,
  });

  final Widget child;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            /* todo static set your gradient color below */
            // colorBlueGradient1,
            // colorBlueGradient2,
            // colorBlueGradient3,
          ],
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}
