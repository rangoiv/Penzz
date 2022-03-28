import 'package:flutter/material.dart';

class GreenCircle extends StatelessWidget {
  GreenCircle(
      {required this.radius}
      );

  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.teal.withOpacity(0.98),
            Colors.greenAccent.withOpacity(0.98),
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(radius/2),
        ),
        boxShadow: [
          BoxShadow(
              offset: Offset(10, 10),
              blurRadius: 20,
              color: Colors.teal.withOpacity(0.2)),
        ],
      ),
    );
  }
}
