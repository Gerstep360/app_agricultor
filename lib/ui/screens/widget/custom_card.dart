import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCard extends StatelessWidget {
  const CustomCard(
      {super.key,
      required this.color,
      required this.height,
      this.width,
      required this.child});

  final Color color;
  final double height;
  final double? width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.sp),
      child: Container(
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
            color: color, // Color del container
            borderRadius: BorderRadius.circular(8.sp), // Esquinas redondeadas
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Color de la sombra
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // Cambia la posición de la sombra
              ),
            ],
          ),
          width: width,
          height: height,
          child: child),
    );
  }
}
