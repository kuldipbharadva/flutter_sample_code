import 'package:flutter/material.dart';

class CardViewWidget extends StatefulWidget {
  final Widget child;
  final Color cardBgColor;
  final double cardRadius;
  final double cardElevation;

  const CardViewWidget({
    super.key,
    required this.child,
    this.cardBgColor = Colors.white,
    this.cardRadius = 12.0,
    this.cardElevation = 5.0,
  });

  @override
  State<CardViewWidget> createState() => _CardViewWidgetState();
}

class _CardViewWidgetState extends State<CardViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.cardBgColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withValues(alpha: 0.35),
              blurRadius: 3.5,
              offset: Offset(0.0, 1.5))
        ],
        borderRadius: BorderRadius.circular(widget.cardRadius),
      ),
      margin: EdgeInsets.all(2),
      child: widget.child,
    );
  }
}
