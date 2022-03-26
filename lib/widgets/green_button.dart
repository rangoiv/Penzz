import 'package:flutter/material.dart';

class GreenButton extends StatelessWidget {
  GreenButton(
      {required this.str, required this.boxHeight}
      );
  final String str;
  final double boxHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: boxHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:[
            Colors.teal.withOpacity(0.8),
            Colors.greenAccent.withOpacity(0.9),
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
              offset: Offset(10, 10),
              blurRadius: 20,
              color: Colors.teal.withOpacity(0.2)
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget> [
          SizedBox(height: 40),
          Text(
            str,
            style: TextStyle(
              fontSize: 60,
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white, size: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}