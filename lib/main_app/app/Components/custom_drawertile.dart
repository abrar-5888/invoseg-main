import 'package:flutter/material.dart';

import '../../config/themes/themes color/colors.dart';

class DrawerTile extends StatelessWidget {
  final String title;
  final IconData iconData;
  final VoidCallback onPress;

  const DrawerTile(
      {super.key,
      required this.title,
      required this.onPress,
      required this.iconData});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        dense: true,
        visualDensity: const VisualDensity(vertical: -3),
        leading: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
              color: const Color.fromRGBO(236, 238, 240, 1),
              borderRadius: BorderRadius.circular(30)),
          child: Icon(iconData, color: ThemeColor.blue),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        onTap: onPress);
  }
}
