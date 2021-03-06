import 'package:flutter/material.dart';

class BlackButton extends StatelessWidget {
  const BlackButton({
    Key? key, this.text = "", this.onPressed, this.icon,
  }) : super(key: key);

  final String text;
  final void Function()? onPressed;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: const Color(0xff11121B),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: ()  {
            if (onPressed != null) {
              onPressed!();
            }
          },
          minWidth: 200.0,
          height: 42.0,
          child: Stack (
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  this.text,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              if (this.icon != null) Align(
                alignment: Alignment.centerLeft,
                child: this.icon!,
              )
            ],
          ),
        ),
      ),
    );
  }
}