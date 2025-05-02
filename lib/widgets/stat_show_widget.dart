import 'package:flutter/material.dart';

class StatShowWidget extends StatelessWidget {
  final String label, number;
  final TextStyle labelStyle, numberStyle;
  final double borderRadius;
  final double horizontalPadding, verticalPadding, internalPadding;
  const StatShowWidget({
    super.key,
    required this.label,
    required this.number,
    required this.labelStyle,
    required this.numberStyle,
    required this.borderRadius,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.internalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(number, style: numberStyle),
              Text(label, style: labelStyle),
            ],
          ),
        ),
      ),
    );
  }
}
