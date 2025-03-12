import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttersampleapp/core/utils/app_colors.dart';
import 'package:fluttersampleapp/core/utils/app_size_constants.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final String? inputFormatterRegex;
  final String suffixIconUrl;
  final String prefixIconUrl;
  final Color? fillColor;
  final Color textColor;
  final Color borderColor;
  final Color cursorColor;
  final Color hintColor;
  final int maxLines;
  final int maxLength;
  final bool isPassword;
  final bool isShowBorder;
  final bool isIcon;
  final bool isShowSuffixIcon;
  final bool isShowPrefixIcon;
  final bool isSearch;
  final bool enable;
  final bool isReadOnly;
  final bool isCapital;
  final bool isDense;
  final double boxBorder;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final Function()? onTapCallBack;
  final String? labelText;
  final String? suffixText;
  final double? suffixIconSize;
  final bool isSetSuffixIconColor;

  const CustomTextFormField({
    super.key,
    this.hintText = '',
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.inputFormatterRegex = '',
    this.maxLines = 1,
    this.maxLength = 256,
    this.fillColor,
    this.textColor = Colors.black87,
    this.borderColor = Colors.black26,
    this.cursorColor = Colors.black26,
    this.hintColor = Colors.grey,
    this.isShowBorder = true,
    this.isShowSuffixIcon = false,
    this.isShowPrefixIcon = false,
    this.onTapCallBack,
    this.isIcon = false,
    this.isPassword = false,
    this.suffixIconUrl = '',
    this.prefixIconUrl = '',
    this.isSearch = false,
    this.enable = true,
    this.isReadOnly = false,
    this.isCapital = false,
    this.isDense = true,
    this.onChanged,
    this.validator,
    this.boxBorder = 10,
    this.labelText,
    this.suffixText,
    this.suffixIconSize = 18,
    this.isSetSuffixIconColor = true,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxLines,
      controller: widget.controller,
      enabled: widget.enable,
      focusNode: widget.focusNode,
      readOnly: widget.isReadOnly,
      onChanged: widget.onChanged,
      style: GoogleFonts.getFont(
        'Cairo',
        fontSize: fontSizeNormal + 1,
        color: widget.textColor,
      ),
      textInputAction: widget.inputAction,
      keyboardType: widget.inputType,
      cursorColor: widget.cursorColor,
      textCapitalization: widget.isCapital
          ? TextCapitalization.sentences
          : TextCapitalization.none,
      obscureText: widget.isPassword ? _obscureText : false,
      inputFormatters: widget.inputFormatterRegex.toString().isEmpty
          ? [LengthLimitingTextInputFormatter(widget.maxLength)]
          : [
              LengthLimitingTextInputFormatter(widget.maxLength),
              FilteringTextInputFormatter.allow(
                  RegExp(widget.inputFormatterRegex ?? ''))
            ],
      validator: widget.validator,
      decoration: InputDecoration(
        // contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        labelText: widget.labelText,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: GoogleFonts.getFont(
          'Cairo',
          fontSize: fontSizeNormal + 1,
          color: colorGrey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(widget.boxBorder)),
          borderSide: BorderSide(
              color: colorGreyBorder.withValues(alpha: 0.8), width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(widget.boxBorder)),
          borderSide: BorderSide(
              color: colorGreyBorder.withValues(alpha: 0.8), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.boxBorder),
          borderSide: BorderSide(
              color: colorGreyBorder.withValues(alpha: 0.8), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.boxBorder),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.boxBorder),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        isDense: widget.isDense,
        hintText: widget.hintText,
        fillColor: widget.fillColor ?? Colors.transparent,
        hintStyle: GoogleFonts.getFont(
          'Cairo',
          fontSize: 16,
          color: widget.hintColor,
        ),
        errorStyle: GoogleFonts.getFont(
          'Cairo',
          fontSize: 14,
          color: Colors.red,
          height: 1.2,
        ),
        filled: true,
        prefixIcon: widget.isShowPrefixIcon
            ? Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Image.asset(widget.prefixIconUrl),
              )
            : const SizedBox.shrink(),
        prefixIconConstraints:
            const BoxConstraints(minWidth: 12, maxHeight: 20),
        suffixIconConstraints:
            const BoxConstraints(minWidth: 30, maxHeight: 30),
        suffixText: widget.suffixText,
        suffixIcon: widget.isShowSuffixIcon
            ? widget.isPassword
                ? IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 22,
                    icon: Icon(
                        _obscureText
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: colorGrey),
                    onPressed: _toggle)
                : Container(
                    margin: const EdgeInsets.only(left: 13, right: 12),
                    child: Image.asset(
                      widget.suffixIconUrl,
                      width: widget.suffixIconSize,
                      height: widget.suffixIconSize,
                      color: widget.isSetSuffixIconColor ? colorGrey : null,
                    ),
                  )
            : null,
      ),
      onTap: widget.onTapCallBack,
      // onSubmitted: (text) => widget.nextFocus != null
      //     ? FocusScope.of(context).requestFocus(widget.nextFocus)
      //     : null,
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
