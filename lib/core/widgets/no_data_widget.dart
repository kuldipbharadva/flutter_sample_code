import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttersampleapp/core/utils/app_colors.dart';
import 'package:fluttersampleapp/core/utils/app_extensions.dart';
import 'package:fluttersampleapp/core/utils/app_strings.dart';
import 'package:fluttersampleapp/core/utils/image_constants.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({
    super.key,
    this.msg,
  });

  final String? msg;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icNoData.imageAssetWidget(
            height: 100.h,
            width: 100.h,
            iconColor: colorBlue,
          ),
          16.toSizedBoxHeight,
          (msg ?? noDataFound).textWidget(
            fontWeight: FontWeight.bold,
            color: colorBlue,
          ),
          32.toSizedBoxHeight,
        ],
      ),
    );
  }
}
