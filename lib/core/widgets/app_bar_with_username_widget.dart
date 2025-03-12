import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttersampleapp/core/utils/app_colors.dart';
import 'package:fluttersampleapp/core/utils/app_extensions.dart';
import 'package:fluttersampleapp/core/utils/app_size_constants.dart';
import 'package:fluttersampleapp/main.dart';

class AppBarWithUsernameWidget extends StatelessWidget {
  const AppBarWithUsernameWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 45.h,
      padding: 16.paddingHorizontal,
      color: colorBlue,
      child: Row(
        children: [
          Icon(Icons.account_circle_outlined, color: colorWhite),
          10.toSizedBoxWidth,
          (preferenceInfoModel.fullName ?? '').textWidget(
            fontSize: fontSizeTitle,
            fontWeight: FontWeight.bold,
            color: colorWhite,
          ),
        ],
      ),
    );
  }
}
