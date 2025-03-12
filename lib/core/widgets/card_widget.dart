import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.child,
    this.cardRadius,
    this.cardShadow,
    this.cardBgColor,
    this.cardShadowColor,
    this.paddingHorizontal,
    this.paddingVertical,
    this.marginHorizontal,
    this.marginVertical,
  });

  final Widget child;
  final double? cardRadius;
  final double? cardShadow;
  final Color? cardBgColor;
  final Color? cardShadowColor;
  final double? paddingHorizontal;
  final double? paddingVertical;
  final double? marginHorizontal;
  final double? marginVertical;

  @override
  Widget build(BuildContext context) {
    /*return Container(
      margin: EdgeInsets.symmetric(
          horizontal: marginHorizontal ?? 0, vertical: marginVertical ?? 0),
      padding: EdgeInsets.symmetric(
          horizontal: paddingHorizontal ?? 0, vertical: paddingVertical ?? 0),
      decoration: BoxDecoration(
          color: cardBgColor ?? Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.4),
              blurRadius: 12,
              spreadRadius: 1.0,
              offset: const Offset(0, 0),
            )
          ],
          borderRadius: BorderRadius.circular(12)),
      child: child,
    );*/
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: marginHorizontal ?? 0, vertical: marginVertical ?? 0),
      padding: EdgeInsets.symmetric(
          horizontal: paddingHorizontal ?? 0, vertical: paddingVertical ?? 0),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cardRadius ?? 10)),
        elevation: cardShadow ?? 3.0,
        shadowColor: (cardShadowColor ?? Colors.grey).withValues(alpha: 0.5),
        color: cardBgColor ?? Colors.white,
        surfaceTintColor: Colors.transparent,
        child: child,
      ),
    );
  }
}
