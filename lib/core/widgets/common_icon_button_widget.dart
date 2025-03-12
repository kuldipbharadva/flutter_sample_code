import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttersampleapp/core/utils/app_colors.dart';
import 'package:fluttersampleapp/core/utils/app_extensions.dart';
import 'package:fluttersampleapp/core/utils/app_size_constants.dart';
import 'package:fluttersampleapp/core/widgets/circle_loading_indicator_widget.dart';

class CommonIconButtonWidget extends StatelessWidget {
  const CommonIconButtonWidget({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.verticalPadding,
    this.horizontalPadding,
    this.buttonIconData,
    this.buttonBgColor = colorBlue,
    this.buttonTextColor = colorWhite,
    this.buttonIconColor = colorWhite,
    this.isLoading = false,
    this.imageAsset,
  });

  final String buttonText;
  final String? imageAsset;
  final double? verticalPadding;
  final double? horizontalPadding;
  final bool isLoading;
  final Color buttonBgColor;
  final Color buttonTextColor;
  final Color buttonIconColor;
  final IconData? buttonIconData;
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
          ? _showLoader()
          : Container(
              decoration: BoxDecoration(
                color: buttonBgColor,
                borderRadius: BorderRadius.circular(commonButtonRadius.r),
              ),
              padding: EdgeInsets.symmetric(
                  vertical: verticalPadding ?? 10.h,
                  horizontal: horizontalPadding ?? 15.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buttonText.textWidget(
                      fontWeight: FontWeight.bold, color: buttonTextColor),
                  (buttonText.isNotEmpty ? 4 : 0).toSizedBoxWidth,
                  (imageAsset != null)
                      ? Image.asset(
                          imageAsset ?? '',
                          height: 24,
                          width: 24,
                          color: buttonIconColor,
                        )
                      : Icon(buttonIconData, color: buttonIconColor, size: 22),
                ],
              ),
            ),
    );
  }

  Widget _showLoader() {
    return const Center(
      child: CircleLoadingIndicatorWidget(isDimBg: false),
    );
  }
}
