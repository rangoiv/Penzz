import 'package:flutter/material.dart';

class BlackRoundButton extends StatelessWidget {

  const BlackRoundButton({
    Key? key, this.onPressed, this.icon = const Icon(Icons.add), this.ht = "default",
  }) : super(key: key);

  final void Function()? onPressed;
  final Icon icon;
  final String ht;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          if (onPressed != null) {
            onPressed!();
          };
        },
        child: icon,
        backgroundColor: const Color(0xff11121B),
      heroTag: ht,
      );
  }
}

