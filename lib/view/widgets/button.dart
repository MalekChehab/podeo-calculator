import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/utils.dart';

class MyButton extends StatelessWidget{
  late String text;
  late VoidCallback onPressed;

  MyButton({Key? key, required this.text, required this.onPressed,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = getTextColor(context, text);
    final double fontSize = Utils.isOperator(text, hasEquals: true) ? 26 : 22;
    return Expanded(
      child: Container(
        height:double.infinity,
        margin: const EdgeInsets.all(6),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).scaffoldBackgroundColor,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            )
          ),
          onPressed: onPressed,
          child: text == '<' ?
            Icon(Icons.backspace_outlined, size: 20, color: color)
                : text == '@' ?
          Icon(Icons.history, size: 20, color: color)
          :Text(
              text,
              style: TextStyle(
                  color: color,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
        ),
      ),
    );
  }

  Color getTextColor(BuildContext context, String text){
    switch(text){
      case '+':
      case '-':
      case '⨯':
      case '÷':
      case '=':
        return Theme.of(context).accentColor;
      case 'C':
      case '<':
      case '@':
        return ThemeColors.delete;
      default:
        return Theme.of(context).primaryColor;
    }
  }
}