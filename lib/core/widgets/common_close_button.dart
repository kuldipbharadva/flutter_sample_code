import 'package:flutter/material.dart';

class CommonCloseButton extends StatelessWidget {
  const CommonCloseButton({super.key, this.iconSize, this.callBack});

  final Function? callBack;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (callBack != null) {
          callBack!();
        } else {
          Navigator.pop(context);
        }
      },
      child: Icon(Icons.cancel, color: Colors.red, size: iconSize),
    );
  }
}
