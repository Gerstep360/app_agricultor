import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.textController,
    required this.isObscureText,
    required this.hintText,
    required this.type,
    this.validate,
    this.labelText,
    required this.width,
    this.height,
    this.maxLines,
    this.readOnly,
    this.onTap,
  });

  final TextEditingController textController;
  final TextInputType type;
  final bool isObscureText;
  final String hintText;
  final String? labelText; // Definimos labelText como String opcional
  final Function(String?)? validate;
  final double width;
  final double? height;
  final int? maxLines;
  final bool? readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        onTap: onTap,
        readOnly: readOnly ?? false,
        maxLines: maxLines,
        keyboardType: type,
        style: Theme.of(context).textTheme.bodyMedium,
        
        controller: textController,
        obscureText: isObscureText,
        decoration: InputDecoration(
          labelText: hintText, // Aquí se coloca el nombre sobre el TextField
          labelStyle: Theme.of(context).textTheme.bodyMedium,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.sp),
            borderSide: const BorderSide(
              color: Colors.black,
              style: BorderStyle.solid,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.sp),
            borderSide: const BorderSide(
              color: Colors.orange,
              style: BorderStyle.solid,
            ),
          ),
        ),
      ),
    );
  }
}
