import 'package:bank_check/src/utils/constants.dart';
import 'package:flutter/material.dart';

class ReportSection extends StatelessWidget {
  final String title;
  final Widget widget;
  const ReportSection({super.key, required this.title, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: widget,
        ),
      ],
    );
  }
}
