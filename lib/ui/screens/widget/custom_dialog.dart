import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final VoidCallback onButtonPressed;

  const CustomDialog({
    super.key,
    required this.title,
    required this.content,
    this.buttonText = 'Cerrar',
    this.titleStyle,
    this.contentStyle,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              title,
              style: titleStyle ??
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              content,
              style: contentStyle ?? TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: onButtonPressed,
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
