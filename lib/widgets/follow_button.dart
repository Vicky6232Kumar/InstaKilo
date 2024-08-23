import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {

  final Function()? function;
  final Color backgroundColor;
  final Color borderColor;
  final String text; 
  final Color textColor;
  const FollowButton({super.key, this.function, required this.backgroundColor, required this.borderColor,required this.text, required this.textColor });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: function,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          margin: const EdgeInsets.only(right: 5),
          alignment: Alignment.center,
          height: 35,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(text, style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            
          ),),
        ),
      ),
    );
  }
}