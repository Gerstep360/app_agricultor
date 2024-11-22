import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropDownMenu<T> extends StatefulWidget {
  const CustomDropDownMenu({
    super.key,
    required this.width,
    required this.label,
    required this.uk,
    required this.list,
    required this.onSelected,
    required this.displayFieldExtractor,
    this.height, this.textController, // Nueva función para extraer el campo a mostrar
  });

  final TextEditingController? textController;
  final double width;
  final double? height;
  final String label;
  final List<T> list;
  final Key uk;
  final ValueChanged<T>
      onSelected; // Cambia el tipo de retorno a T para flexibilidad
  final String Function(T)
      displayFieldExtractor; // Función para obtener el campo

  @override
  State<CustomDropDownMenu<T>> createState() => _CustomDropDownMenuState<T>();
}

class _CustomDropDownMenuState<T> extends State<CustomDropDownMenu<T>> {
  T? dropdownValue;

  late final Key dropdownKey;

  @override
  void initState() {
    dropdownKey = UniqueKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: DropdownButtonFormField<T>(
        key: dropdownKey,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          //contentPadding: EdgeInsets.all(8.sp),
          labelText: widget.label,
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
            borderSide: BorderSide(
              width: 2.sp,
              color: Colors.green,
              style: BorderStyle.solid,
            ),
          ),
        ),
        icon: const Icon(Icons.arrow_drop_down),
        onChanged: (T? newValue) {
          setState(() {
            dropdownValue = newValue;
          });
          widget.onSelected(newValue!);
        },
        items: widget.list.map<DropdownMenuItem<T>>((T value) {
          return DropdownMenuItem<T>(
            value: value,
            child: Text(
              widget.displayFieldExtractor(
                  value), // Usa la función para obtener el campo
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }).toList(),
      ),
    );
  }
}
