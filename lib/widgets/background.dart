import 'package:flutter/material.dart';
import 'package:penzz/widgets/green_circle.dart';

class Background extends StatelessWidget {

  const Background({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          child: GreenCircle(radius: 280),
          top: 260,
          right: -130,
        ),
        Positioned(
          child: GreenCircle(radius: 200),
          top: 360,
          right: 70,
        ),
        Positioned(
          child: GreenCircle(radius: 110),
          top: 480,
          right: 30,
        ),
        Positioned.fill(
          child: child
        ),
      ],
    );
  }
}
