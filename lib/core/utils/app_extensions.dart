import 'dart:convert';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttersampleapp/core/utils/app_colors.dart';
import 'package:fluttersampleapp/core/utils/app_size_constants.dart';
import 'package:fluttersampleapp/core/utils/image_constants.dart';
import 'package:fluttersampleapp/core/widgets/circle_loading_indicator_widget.dart';
import 'package:google_fonts/google_fonts.dart';

extension AppExtensions on String {
  Widget textWidget({
    double? fontSize,
    FontWeight fontWeight = FontWeight.normal,
    TextOverflow? overflow,
    int? maxLine,
    TextAlign? textAlign,
    Color? color = colorBlackText,
    String? fontFamily,
    double? height,
    double? latterSpacing,
  }) =>
      Text(
        this,
        overflow: overflow,
        maxLines: maxLine,
        textAlign: textAlign,
        style: GoogleFonts.getFont(
          'Cairo',
          fontSize: (fontSize ?? fontSizeNormal).sp,
          color: color,
          fontWeight: fontWeight,
          height: height ?? 1.35,
          // fontFamily: fontFamily ?? fontFamilyRegular,
        ),
        /*style: TextStyle(
          fontSize: fontSize.sp,
          color: color,
          fontWeight: fontWeight,
          height: height ?? 1.35,
          fontFamily: fontFamily ?? fontFamilyRegular,
        ),*/
      );

  Widget richTextView({
    double fontSize = fontSizeNormal,
    FontWeight fontWeight = FontWeight.normal,
    TextOverflow? overflow,
    int? maxLine,
    TextAlign? textAlign,
    Color color = colorBlack,
    String? fontFamily,
    double? height,
    List<InlineSpan>? textSpanList,
  }) =>
      RichText(
          text: TextSpan(
        text: this,
        style: GoogleFonts.getFont(
          'Cairo',
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
        ),
        /*TextStyle(
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight,
            height: height ?? 1.4,
            fontFamily: fontFamily ?? fontFamilyRoboto),*/
        children: textSpanList ?? [],
      ));

  Widget imageAssetWidget({
    double? height,
    double? width,
    double? padding,
    BoxFit? boxFit,
    Color? iconColor,
  }) =>
      Container(
        padding: EdgeInsets.all(padding ?? 0),
        child: Image.asset(
          this,
          height: height ?? 24,
          width: width ?? 24,
          fit: boxFit ?? BoxFit.contain,
          color: iconColor,
        ),
      );

  Widget toNetWorkImage({
    double height = 50,
    double width = 50,
    num borderRadius = 20,
    bool isAllRounded = true,
    double topLeftBorder = 10.0,
    double topRightBorder = 10.0,
    double bottomLeftBorder = 10.0,
    double bottomRightBorder = 10.0,
    BoxFit fit = BoxFit.cover,
    String? placeHolderAssets,
    VoidCallback? onTap,
    double? errorPaddingAll,
  }) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: this,
            height: height,
            width: width,
            fit: fit,
            imageBuilder: (context, imageProvider) => Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                borderRadius: isAllRounded
                    ? BorderRadius.circular(borderRadius.toDouble())
                    : BorderRadius.only(
                        bottomLeft: Radius.circular(bottomLeftBorder),
                        bottomRight: Radius.circular(bottomRightBorder),
                        topLeft: Radius.circular(topLeftBorder),
                        topRight: Radius.circular(topRightBorder),
                      ),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
                decoration: BoxDecoration(
                  borderRadius: isAllRounded
                      ? BorderRadius.circular(borderRadius.toDouble())
                      : BorderRadius.only(
                          bottomLeft: Radius.circular(bottomLeftBorder),
                          bottomRight: Radius.circular(bottomRightBorder),
                          topLeft: Radius.circular(topLeftBorder),
                          topRight: Radius.circular(topRightBorder),
                        ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(errorPaddingAll ?? 5.0),
                  child: (placeHolderAssets ?? icLogo).imageAssetWidget(),
                )),
            progressIndicatorBuilder: (_, __, ___) =>
                const CircleLoadingIndicatorWidget(
              isDimBg: false,
            ),
          ),
        ],
      );

  Widget imageBase64({
    double? height,
    double? width,
    BoxFit fit = BoxFit.contain,
  }) =>
      (isEmpty)
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: (icLogo).imageAssetWidget(height: height, width: width),
            )
          : /*Image.memory(
              height: height,
              width: width,
              const Base64Decoder().convert(this),
              fit: fit,
            )*/
          CachedMemoryImage(
              uniqueKey: this,
              height: height,
              width: width,
              fit: fit,
              errorWidget:
                  (icLogo).imageAssetWidget(height: height, width: width),
              bytes: const Base64Decoder().convert(this),
            );

  Widget dateView({required Function callBack}) {
    return GestureDetector(
      onTap: () {
        callBack();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: colorPrimary),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.calendar_month_rounded,
              color: colorWhite,
              size: 20,
            ),
            8.toSizedBoxWidth,
            (this).textWidget(color: colorWhite),
          ],
        ),
      ),
    );
  }
}

extension AppWidgetExtension on Widget {
  Widget toVisibility(bool value) => Visibility(
        visible: value,
        child: this,
      );
}

extension AppIntExtension on num {
  SizedBox get toSizedBox => SizedBox(height: toDouble(), width: toDouble());

  SizedBox get toSizedBoxHeight => SizedBox(height: toDouble());

  SizedBox get toSizedBoxWidth => SizedBox(width: toDouble());

  EdgeInsets get paddingHorizontal =>
      EdgeInsets.symmetric(horizontal: toDouble());

  EdgeInsets get paddingVertical => EdgeInsets.symmetric(vertical: toDouble());

  EdgeInsets get paddingAll => EdgeInsets.all(toDouble());
}
