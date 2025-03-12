import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttersampleapp/core/utils/app_colors.dart';
import 'package:fluttersampleapp/core/utils/app_extensions.dart';
import 'package:fluttersampleapp/core/utils/app_size_constants.dart';
import 'package:fluttersampleapp/core/utils/image_constants.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    super.key,
    this.title,
    this.isBackVisible = true,
    this.onBackPressed,
  });

  final String? title;
  final bool isBackVisible;
  final Function? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 45.h,
      padding: 16.paddingHorizontal,
      color: colorBlue,
      child: Stack(
        children: [
          Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                  onTap: () {
                    if (onBackPressed != null) {
                      onBackPressed!();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: icBack.imageAssetWidget(
                      height: 13.h,
                      width: 13.h,
                      iconColor: colorWhite,
                    ),
                  ))).toVisibility(isBackVisible),
          (isBackVisible ? 20 : 0).toSizedBoxWidth,
          Center(
            child: (title ?? '').textWidget(
              fontSize: fontSizeTitle + 1,
              fontWeight: FontWeight.bold,
              color: colorWhite,
            ),
          ),
        ],
      ),
    );
  }
}
