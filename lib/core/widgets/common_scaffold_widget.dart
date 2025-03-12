import 'package:flutter/material.dart';
import 'package:fluttersampleapp/core/utils/app_colors.dart';

class CommonScaffoldWidget extends StatelessWidget {
  const CommonScaffoldWidget({
    super.key,
    required this.body,
  });

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorStatusBar,
        toolbarHeight: 0,
      ),
      body: body,
    );
  }
}
