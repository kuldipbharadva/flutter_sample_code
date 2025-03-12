import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttersampleapp/core/utils/app_colors.dart';
import 'package:fluttersampleapp/core/utils/app_extensions.dart';
import 'package:fluttersampleapp/core/utils/app_size_constants.dart';
import 'package:fluttersampleapp/core/widgets/circle_loading_indicator_widget.dart';

class CommonButtonWidget extends StatelessWidget {
  const CommonButtonWidget({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.buttonBgColor,
    this.buttonTextColor,
    this.fontSize,
    this.fontWeight,
    this.isLoading = false,
  });

  final bool isLoading;
  final String buttonText;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? buttonBgColor;
  final Color? buttonTextColor;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return _buttonIcon();
  }

  Widget _buttonIcon() {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: isLoading
          ? const CircleLoadingIndicatorWidget(isDimBg: false)
          : Container(
              decoration: BoxDecoration(
                color: buttonBgColor ?? colorBlue,
                borderRadius: BorderRadius.circular(commonButtonRadius.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
              child: Center(
                child: buttonText.textWidget(
                  color: buttonTextColor ?? colorWhite,
                  fontSize: fontSize ?? fontSizeMedium,
                  fontWeight: fontWeight ?? FontWeight.bold,
                ),
              ),
            ),
    );
  }
}
