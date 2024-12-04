// lib/ui/screens/productor/produccion/add_produccion_form.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:agromarket_app/models/Agricultor/produccion.dart';
import 'package:agromarket_app/models/Agricultor/terreno.dart';
import 'package:agromarket_app/models/Agricultor/unidad_medida.dart';
import 'package:agromarket_app/models/Agricultor/producto.dart';
import 'package:agromarket_app/models/Agricultor/temporada.dart';
import 'package:agromarket_app/ui/Themes/theme.dart';
import 'package:intl/intl.dart';
import 'package:agromarket_app/ui/screens/productor/produccion/view_models/produccion_service.dart';

class AddProduccionForm extends StatefulWidget {
  final ProduccionService produccionService;
  final Produccion? produccionToEdit;
  final void Function(Produccion) onSuccess;

  const AddProduccionForm({
    Key? key,
    required this.produccionService,
    this.produccionToEdit,
    required this.onSuccess,
  }) : super(key: key);

  @override
  State<AddProduccionForm> createState() => _AddProduccionFormState();
}

class _AddProduccionFormState extends State<AddProduccionForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _fechaCosechaController = TextEditingController();
  final TextEditingController _fechaExpiracionController = TextEditingController();

  UnidadMedida? _selectedUnidadMedida;
  Terreno? _selectedTerreno;
  Producto? _selectedProducto;
  Temporada? _selectedTemporada;
  String? _selectedEstado;
  DateTime? _fechaCosecha;
  DateTime? _fechaExpiracion;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.produccionToEdit != null) {
      _initializeProduccion();
    }
  }

  /// Inicializa los campos del formulario con datos de una producción existente
  void _initializeProduccion() {
    _descripcionController.text = widget.produccionToEdit!.descripcion;
    _cantidadController.text = widget.produccionToEdit!.cantidad.toString();
    _fechaCosecha = widget.produccionToEdit!.fechaCosecha;
    _fechaExpiracion = widget.produccionToEdit!.fechaExpiracion;
    _fechaCosechaController.text =
        DateFormat('yyyy-MM-dd').format(_fechaCosecha!);
    _fechaExpiracionController.text =
        DateFormat('yyyy-MM-dd').format(_fechaExpiracion!);
    _selectedUnidadMedida = widget.produccionService.unidadesMedida.firstWhere(
      (u) => u.id == widget.produccionToEdit!.idUnidadMedida,
      orElse: () => widget.produccionService.unidadesMedida.first,
    );
    _selectedTerreno = widget.produccionService.terrenos.firstWhere(
      (t) => t.id == widget.produccionToEdit!.id_terreno,
      orElse: () => widget.produccionService.terrenos.first,
    );
    _selectedProducto = widget.produccionService.productos.firstWhere(
      (p) => p.id == widget.produccionToEdit!.id_producto,
      orElse: () => widget.produccionService.productos.first,
    );
    _selectedTemporada = widget.produccionService.temporadas.firstWhere(
      (t) => t.id == widget.produccionToEdit!.id_temporada,
      orElse: () => widget.produccionService.temporadas.first,
    );
    _selectedEstado = widget.produccionToEdit!.estado;
  }

  /// Muestra el selector de fecha y actualiza el controlador correspondiente
  Future<void> _selectDate(BuildContext context, TextEditingController controller,
    Function(DateTime) onDateSelected) async {
  final pickedDate = await showDatePicker(
    context: context,
    initialDate: controller.text.isNotEmpty
        ? DateTime.parse(controller.text)
        : DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            surface: AppThemes.borderColor, // Fondo del diálogo
            primary: AppThemes.accentColor, // Color principal para selección y texto
            onPrimary: AppThemes.borderColor, // Color del texto en encabezado
            onSurface: AppThemes.accentColor, // Texto de fecha seleccionada
          ),
          dialogBackgroundColor: AppThemes.borderColor, // Fondo del diálogo
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppThemes.accentColor, // Color del texto de botones "Aceptar" y "Cancelar"
            ),
          ),
        ),
        child: child!,
      );
    },
  );

    if (pickedDate != null) {
      setState(() {
        onDateSelected(pickedDate);
        controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
      _showSnackBar('Fecha seleccionada correctamente.', AppThemes.primaryColor);
    } else {
      _showSnackBar('No se seleccionó ninguna fecha.', AppThemes.errorColor);
    }
  }

  /// Envía el formulario para crear o actualizar una producción
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      _showSnackBar('Complete los campos requeridos antes de continuar.', AppThemes.errorColor);
      return;
    }

    if (_fechaCosecha == null || _fechaExpiracion == null) {
      _showSnackBar('Seleccione ambas fechas: cosecha y expiración.', AppThemes.errorColor);
      return;
    }

    // Validar que la fecha de expiración sea posterior a la de cosecha
    if (_fechaExpiracion!.isBefore(_fechaCosecha!)) {
      _showSnackBar('La fecha de expiración debe ser posterior a la fecha de cosecha.', AppThemes.errorColor);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final nuevaProduccion = Produccion(
        id: widget.produccionToEdit?.id ?? 0,
        id_terreno: _selectedTerreno!.id,
        id_temporada: _selectedTemporada!.id,
        id_producto: _selectedProducto!.id,
        idUnidadMedida: _selectedUnidadMedida!.id,
        descripcion: _descripcionController.text,
        cantidad: double.tryParse(_cantidadController.text) ?? 0.0,
        fechaCosecha: _fechaCosecha!,
        fechaExpiracion: _fechaExpiracion!,
        estado: "activo",
      );

      if (widget.produccionToEdit == null) {
        // Crear nueva producción
        await widget.produccionService.addProduccion(nuevaProduccion);
        if (widget.produccionService.errorMessage.isEmpty) {
          widget.onSuccess(nuevaProduccion);
        } else {
          _showSnackBar(widget.produccionService.errorMessage, AppThemes.errorColor);
        }
      } else {
        // Actualizar producción existente
        await widget.produccionService.updateProduccion(nuevaProduccion);
        if (widget.produccionService.errorMessage.isEmpty) {
          widget.onSuccess(nuevaProduccion);
        } else {
          _showSnackBar(widget.produccionService.errorMessage, AppThemes.errorColor);
        }
      }

      Navigator.pop(context); // Cierra el diálogo después de una operación exitosa
    } catch (e) {
      _showSnackBar('Error al procesar la producción: $e', AppThemes.errorColor);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Muestra un SnackBar con el mensaje proporcionado
  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: AppThemes.accentColor),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Construye un campo desplegable personalizado
  Widget _buildDropdownButtonFormField<T>({
  required T? value,
  required List<DropdownMenuItem<T>> items,
  required String labelText,
  required void Function(T?) onChanged,
  String? Function(T?)? validator,
}) {
  return DropdownButtonFormField<T>(
    value: value,
    items: items,
    onChanged: onChanged,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: AppThemes.accentColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppThemes.accentColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppThemes.accentColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppThemes.accentColor, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      filled: true,
      fillColor: AppThemes.primaryColor,
    ),
    validator: validator,
    isExpanded: true,
    style: TextStyle(color: AppThemes.accentColor),
    dropdownColor: AppThemes.primaryColor,
    iconEnabledColor: AppThemes.accentColor,
    iconDisabledColor: AppThemes.accentColor,
  );
}


  /// Construye un campo de texto personalizado
  Widget _buildTextField({
  required TextEditingController controller,
  required String labelText,
  required TextInputType type,
  String? Function(String?)? validator,
  bool readOnly = false,
  VoidCallback? onTap,
  IconData? icon,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: type,
    readOnly: readOnly,
    onTap: onTap,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: AppThemes.accentColor),
      prefixIcon:
          icon != null ? Icon(icon, color: AppThemes.accentColor) : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppThemes.accentColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppThemes.accentColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppThemes.accentColor, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      filled: true,
      fillColor: AppThemes.primaryColor,
    ),
    validator: validator,
    style: TextStyle(fontSize: 14.sp, color: AppThemes.accentColor),
    autovalidateMode: AutovalidateMode.onUserInteraction,
  );
}


  @override
Widget build(BuildContext context) {
  final isEditing = widget.produccionToEdit != null;

  return Material(
    color: Colors.transparent,
    child: Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Título del formulario
                Text(
                  isEditing ? 'Editar Producción' : 'Agregar Producción',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppThemes.accentColor,
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                // Campo de Descripción
                _buildTextField(
                  controller: _descripcionController,
                  labelText: 'Descripción *',
                  type: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese una descripción válida.';
                    }
                    return null;
                  },
                  icon: Icons.description,
                ),
                SizedBox(height: 12.h),
                // Campo de Cantidad
                _buildTextField(
                  controller: _cantidadController,
                  labelText: 'Cantidad *',
                  type: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese una cantidad.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Ingrese un valor numérico válido.';
                    }
                    return null;
                  },
                  icon: Icons.linear_scale,
                ),
                SizedBox(height: 12.h),
                // Campo de Unidad de Medida
                _buildDropdownButtonFormField<UnidadMedida>(
                  value: _selectedUnidadMedida,
                  items: widget.produccionService.unidadesMedida
                      .map((unidad) => DropdownMenuItem(
                          value: unidad, child: Text(unidad.nombre)))
                      .toList(),
                  labelText: 'Unidad de Medida *',
                  onChanged: (value) => setState(() => _selectedUnidadMedida = value),
                  validator: (value) =>
                      value == null ? 'Seleccione una unidad de medida.' : null,
                ),
                SizedBox(height: 12.h),
                // Campo de Terreno
                _buildDropdownButtonFormField<Terreno>(
                  value: _selectedTerreno,
                  items: widget.produccionService.terrenos
                      .map((terreno) => DropdownMenuItem(
                          value: terreno, child: Text(terreno.descripcion)))
                      .toList(),
                  labelText: 'Terreno *',
                  onChanged: (value) => setState(() => _selectedTerreno = value),
                  validator: (value) =>
                      value == null ? 'Seleccione un terreno.' : null,
                ),
                SizedBox(height: 12.h),
                // Campo de Producto
                _buildDropdownButtonFormField<Producto>(
                  value: _selectedProducto,
                  items: widget.produccionService.productos
                      .map((producto) => DropdownMenuItem(
                          value: producto, child: Text(producto.nombre)))
                      .toList(),
                  labelText: 'Producto *',
                  onChanged: (value) => setState(() => _selectedProducto = value),
                  validator: (value) =>
                      value == null ? 'Seleccione un producto.' : null,
                ),
                SizedBox(height: 12.h),
                // Campo de Temporada
                _buildDropdownButtonFormField<Temporada>(
                  value: _selectedTemporada,
                  items: widget.produccionService.temporadas
                      .map((temporada) => DropdownMenuItem(
                          value: temporada, child: Text(temporada.nombre)))
                      .toList(),
                  labelText: 'Temporada *',
                  onChanged: (value) => setState(() => _selectedTemporada = value),
                  validator: (value) =>
                      value == null ? 'Seleccione una temporada.' : null,
                ),
                SizedBox(height: 12.h),
                // Campo de Fecha de Cosecha
                _buildTextField(
                  controller: _fechaCosechaController,
                  labelText: 'Fecha de Cosecha *',
                  type: TextInputType.text,
                  readOnly: true,
                  onTap: () => _selectDate(context, _fechaCosechaController, (date) {
                    setState(() {
                      _fechaCosecha = date;
                    });
                  }),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Seleccione la fecha de cosecha.'
                      : null,
                  icon: Icons.calendar_today,
                ),
                SizedBox(height: 12.h),
                // Campo de Fecha de Expiración
                _buildTextField(
                  controller: _fechaExpiracionController,
                  labelText: 'Fecha de Expiración *',
                  type: TextInputType.text,
                  readOnly: true,
                  onTap: () => _selectDate(context, _fechaExpiracionController, (date) {
                    setState(() {
                      _fechaExpiracion = date;
                    });
                  }),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Seleccione la fecha de expiración.'
                      : null,
                  icon: Icons.calendar_today,
                ),
                SizedBox(height: 12.h),
                // Botón para crear o actualizar la producción
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppThemes.primaryColor,
                    foregroundColor: AppThemes.accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: AppThemes.accentColor),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  child: Text(
                    isEditing ? 'Actualizar Producción' : 'Crear Producción',
                    style: TextStyle(
                      color: AppThemes.accentColor,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Indicador de carga
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    ),
  );
}
}