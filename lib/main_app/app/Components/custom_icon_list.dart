import 'package:flutter/material.dart';
import 'package:com.invoseg.innovation/main_app/config/themes/themes%20color/colors.dart';

class IconList extends StatelessWidget {
  final IconData iconData;
  final String title;
  final VoidCallback onpressed;
  const IconList({
    super.key,
    required this.iconData,
    required this.title,
    required this.onpressed,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(color: ThemeColor.grey, shape: BoxShape.circle),
          child: IconButton(
            onPressed: onpressed,
            icon: Icon(
              iconData,
              color: ThemeColor.blue,
            ),
          ),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        )
      ],
    );
  }
}
