import 'package:flutter/material.dart';
import 'package:fluttersampleapp/core/utils/app_colors.dart';

class CircleLoadingIndicatorWidget extends StatelessWidget {
  const CircleLoadingIndicatorWidget({
    super.key,
    this.height,
    this.width,
    this.heightDimBg,
    this.widthDimBg,
    this.isDimBg = true,
  });

  final double? height;
  final double? width;
  final double? heightDimBg;
  final double? widthDimBg;
  final bool isDimBg;

  @override
  Widget build(BuildContext context) {
    if (isDimBg) {
      return Container(
        height: double.infinity,
        color: colorTransparent,
        child: _loadingView(),
      );
    }
    return _loadingView();
  }

  Widget _loadingView() {
    return Center(
      child: Container(
        width: isDimBg ? (widthDimBg ?? 80) : (width ?? 24),
        height: isDimBg ? (heightDimBg ?? 80) : (height ?? 24),
        margin: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
            color: isDimBg ? Colors.black26 : Colors.transparent,
            borderRadius: BorderRadius.circular(8.0)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: width ?? 24,
              height: height ?? 24,
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(colorBlue),
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
