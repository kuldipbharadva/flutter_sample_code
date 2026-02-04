import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttersampleapp/core/utils/app_colors.dart';
import 'package:fluttersampleapp/core/utils/app_extensions.dart';
import 'package:fluttersampleapp/core/utils/app_size_constants.dart';
import 'package:fluttersampleapp/core/utils/app_strings.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

void logcat(String? value) {
  debugPrint('logcat :: $value');
}

void showBottomSheetDialog({
  required BuildContext context,
  required Widget widget,
  Function? onCompleteAction,
}) {
  showModalBottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    backgroundColor: colorWhite,
    context: context,
    builder: (context) => widget,
  ).whenComplete(() {
    if (onCompleteAction != null) {
      onCompleteAction();
    }
  });
}

void showAlertDialog({
  required BuildContext context,
  required Widget widget,
  bool isDismissible = false,
  double elevation = 30,
  double borderRadius = 10,
  double insetPadding = 12,
  double contentPaddingHorizontal = 16,
  double contentPaddingVertical = 16,
  double? dialogWidth,
  Color backgroundColor = Colors.white,
  Color surfaceTintColor = Colors.white,
}) {
  showDialog(
      context: context,
      barrierDismissible: isDismissible,
      barrierColor: colorDim,
      builder: (BuildContext context) {
        return PopScope(
          canPop: isDismissible,
          onPopInvokedWithResult: (didInvoked, result) {},
          child: AlertDialog(
            elevation: elevation,
            surfaceTintColor: surfaceTintColor,
            backgroundColor: backgroundColor,
            insetPadding: EdgeInsets.all(insetPadding),
            contentPadding: EdgeInsets.symmetric(
                horizontal: contentPaddingHorizontal,
                vertical: contentPaddingVertical),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
            content: StatefulBuilder(
              builder: (context, setState) {
                return SizedBox(
                  width:
                      dialogWidth ?? (MediaQuery.sizeOf(context).width * 0.8),
                  child: widget,
                );
              },
            ),
          ),
        );
      });
}

void showToastMsg({required BuildContext context, required String msg}) {
  // Fluttertoast.cancel();
  // Fluttertoast.showToast(msg: msg);
  FToast().context = context;
  FToast().showToast(
      child: Container(
    decoration: BoxDecoration(
        color: colorBlack.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(100)),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    child: msg.textWidget(color: colorWhite, fontSize: fontSizeMidNormal),
  ));
}

void hideKeyBoard({required BuildContext context}) {
  FocusScope.of(context).requestFocus(FocusNode());
}

String changeDateFormat(
    String oldDatePattern, String newDatePatter, String date) {
  var formattedDate =
      DateFormat(newDatePatter).format(DateFormat(oldDatePattern).parse(date));

  return formattedDate;
}

void navigateScreen(
    {required BuildContext context, required PageRouteInfo route}) {
  AutoRouter.of(context).push(route);
}

void userUnauthorizedCalled(BuildContext context) {
  /* todo static use your redirection page */
  // AutoRouter.of(context).replaceAll([const LoginRoute()]);
}

Widget commonDropdown<T>({
  required T? selectedValue,
  required List<T>? items,
  required DropdownMenuItem<T> Function(T) menuItem,
  required Function(T?) onChanged,
  String? Function(T?)? validator,
}) {
  return DropdownButtonFormField<T>(
    icon: const Icon(Icons.arrow_drop_down_circle_outlined, color: colorBlue),
    initialValue: selectedValue,
    decoration: InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.all(12.0),
      labelStyle: const TextStyle(),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: colorBlue,
            width: 0.5,
          )),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: colorGreyDark, width: 0.8),
      ),
    ),
    items: (items ?? []).map(menuItem).toList(),
    onChanged: onChanged,
    validator: validator,
  );
}

Future<DateTime?> commonDatePickerDialog(
  BuildContext context, {
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    cancelText: lblCancel,
    confirmText: lblNext,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: firstDate ?? DateTime(2000),
    lastDate: lastDate ?? DateTime(2100),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: colorBlue,
            onPrimary: colorWhite,
            onSurface: colorBlue,
            surface: colorWhite,
            surfaceTint: Colors.white,
          ),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
            foregroundColor: colorBlue, // button text color
          )),
        ),
        child: child!,
      );
    },
  );
  return picked;
}

Future<TimeOfDay?> commonTimePickerDialog(BuildContext context,
    {TimeOfDay? initialTime, bool? is24hours}) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: initialTime ?? TimeOfDay.now(),
    confirmText: lblNext,
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: colorBlue,
            onPrimary: colorWhite,
            onSurface: colorBlue,
            surface: colorWhite,
            surfaceTint: Colors.white,
          ),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
            foregroundColor: colorBlue, // button text color
          )),
        ),
        child: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(alwaysUse24HourFormat: is24hours ?? true),
          child: child!,
        ),
      );
    },
  );
  return picked;
}

Widget commonSwitch({required bool value, required Function(bool) onChanged}) {
  return SizedBox(
    width: 40,
    child: Transform.scale(
      scale: 0.75,
      child: Switch.adaptive(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        value: value,
        activeTrackColor: colorBlue.withValues(alpha: 0.7),
        activeThumbColor: colorBlue,
        inactiveTrackColor: colorGreyLightBg,
        inactiveThumbColor: colorGrey.withValues(alpha: 0.6),
        trackOutlineColor: WidgetStatePropertyAll(Colors.transparent),
        onChanged: onChanged,
      ),
    ),
  );
}
