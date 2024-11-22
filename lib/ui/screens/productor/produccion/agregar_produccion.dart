// lib/ui/screens/productor/produccion/add_produccion_form.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:agromarket_app/models/Agricultor/produccion.dart';
import 'package:agromarket_app/models/Agricultor/terreno.dart';
import 'package:agromarket_app/models/Agricultor/unidad_medida.dart';
import 'package:agromarket_app/models/Agricultor/producto.dart';
import 'package:agromarket_app/models/Agricultor/temporada.dart';
import 'package:agromarket_app/services/api_service.dart';
import 'package:agromarket_app/ui/Themes/theme.dart';

class AddProduccionForm extends StatefulWidget {
  final List<UnidadMedida> unidadesMedida;
  final List<Terreno> terrenos;
  final List<Producto> productos;
  final List<Temporada> temporadas;
  final Produccion? produccionToEdit;
  final void Function(Produccion) onProduccionCreated;
  final void Function(Produccion) onProduccionUpdated;

  const AddProduccionForm({
    super.key,
    required this.unidadesMedida,
    required this.terrenos,
    required this.productos,
    required this.temporadas,
    this.produccionToEdit,
    required this.onProduccionCreated,
    required this.onProduccionUpdated,
  });

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
      _descripcionController.text = widget.produccionToEdit!.descripcion;
      _cantidadController.text = widget.produccionToEdit!.cantidad.toString();
      _fechaCosecha = widget.produccionToEdit!.fechaCosecha;
      _fechaExpiracion = widget.produccionToEdit!.fechaExpiracion;
      _fechaCosechaController.text = _fechaCosecha!.toLocal().toIso8601String().split('T')[0];
      _fechaExpiracionController.text = _fechaExpiracion!.toLocal().toIso8601String().split('T')[0];
      _selectedUnidadMedida = widget.unidadesMedida.firstWhere(
        (u) => u.id == widget.produccionToEdit!.idUnidadMedida,
        orElse: () => widget.unidadesMedida.first,
      );
      _selectedTerreno = widget.terrenos.firstWhere(
        (t) => t.id == widget.produccionToEdit!.id_terreno,
        orElse: () => widget.terrenos.first,
      );
      _selectedProducto = widget.productos.firstWhere(
        (p) => p.id == widget.produccionToEdit!.id_producto,
        orElse: () => widget.productos.first,
      );
      _selectedTemporada = widget.temporadas.firstWhere(
        (t) => t.id == widget.produccionToEdit!.id_temporada,
        orElse: () => widget.temporadas.first,
      );
      _selectedEstado = widget.produccionToEdit!.estado;
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller,
      Function(DateTime) onDateSelected) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: controller.text.isNotEmpty
          ? DateTime.parse(controller.text)
          : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      onDateSelected(pickedDate);
      controller.text = pickedDate.toLocal().toIso8601String().split('T')[0];
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_fechaCosecha == null || _fechaExpiracion == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Seleccione las fechas de cosecha y expiración.'),
            backgroundColor: AppThemes.errorColor,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

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
        estado: _selectedEstado!,
      );

      try {
        if (widget.produccionToEdit == null) {
          // Create new production
          final createdProduccion = await ApiService()
              .Produccion_createProduccion(nuevaProduccion.toJson());
          widget.onProduccionCreated(createdProduccion);
        } else {
          // Update existing production
          final updatedProduccion = await ApiService().Produccion_updateProduccion(
              widget.produccionToEdit!.id, nuevaProduccion.toJson());
          widget.onProduccionUpdated(updatedProduccion);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al procesar la producción: $e'),
            backgroundColor: AppThemes.errorColor,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
        prefixIcon:
            icon != null ? Icon(icon, color: AppThemes.primaryColor) : null,
      ),
      validator: validator,
    );
  }

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
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

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
                  Text(
                    widget.produccionToEdit == null
                        ? 'Agregar Producción'
                        : 'Editar Producción',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),
                  _buildTextField(
                    controller: _descripcionController,
                    labelText: 'Descripción',
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
                  _buildTextField(
                    controller: _cantidadController,
                    labelText: 'Cantidad',
                    type: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Ingrese una cantidad'
                        : null,
                    icon: Icons.linear_scale,
                  ),
                  SizedBox(height: 12.h),
                  _buildDropdownButtonFormField<UnidadMedida>(
                    value: _selectedUnidadMedida,
                    items: widget.unidadesMedida
                        .map((unidad) => DropdownMenuItem(
                            value: unidad, child: Text(unidad.nombre)))
                        .toList(),
                    labelText: 'Unidad de Medida',
                    onChanged: (value) => setState(() => _selectedUnidadMedida = value),
                    validator: (value) => value == null
                        ? 'Seleccione una unidad de medida'
                        : null,
                  ),
                  SizedBox(height: 12.h),
                  _buildDropdownButtonFormField<Terreno>(
                    value: _selectedTerreno,
                    items: widget.terrenos
                        .map((terreno) => DropdownMenuItem(
                            value: terreno, child: Text(terreno.descripcion)))
                        .toList(),
                    labelText: 'Terreno',
                    onChanged: (value) => setState(() => _selectedTerreno = value),
                    validator: (value) =>
                        value == null ? 'Seleccione un terreno' : null,
                  ),
                  SizedBox(height: 12.h),
                  _buildDropdownButtonFormField<Producto>(
                    value: _selectedProducto,
                    items: widget.productos
                        .map((producto) => DropdownMenuItem(
                            value: producto, child: Text(producto.nombre)))
                        .toList(),
                    labelText: 'Producto',
                    onChanged: (value) => setState(() => _selectedProducto = value),
                    validator: (value) =>
                        value == null ? 'Seleccione un producto' : null,
                  ),
                  SizedBox(height: 12.h),
                  _buildDropdownButtonFormField<Temporada>(
                    value: _selectedTemporada,
                    items: widget.temporadas
                        .map((temporada) => DropdownMenuItem(
                            value: temporada, child: Text(temporada.nombre)))
                        .toList(),
                    labelText: 'Temporada',
                    onChanged: (value) => setState(() => _selectedTemporada = value),
                    validator: (value) =>
                        value == null ? 'Seleccione una temporada' : null,
                  ),
                  SizedBox(height: 12.h),
                  _buildTextField(
                    controller: _fechaCosechaController,
                    labelText: 'Fecha de Cosecha',
                    type: TextInputType.text,
                    readOnly: true,
                    onTap: () => _selectDate(context, _fechaCosechaController,
                        (date) => _fechaCosecha = date),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Seleccione la fecha de cosecha'
                        : null,
                    icon: Icons.calendar_today,
                  ),
                  SizedBox(height: 12.h),
                  _buildTextField(
                    controller: _fechaExpiracionController,
                    labelText: 'Fecha de Expiración',
                    type: TextInputType.text,
                    readOnly: true,
                    onTap: () => _selectDate(context, _fechaExpiracionController,
                        (date) => _fechaExpiracion = date),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Seleccione la fecha de expiración'
                        : null,
                    icon: Icons.calendar_today,
                  ),
                  SizedBox(height: 12.h),
                  _buildDropdownButtonFormField<String>(
                    value: _selectedEstado,
                    items: ['activo', 'inactivo']
                        .map((estado) =>
                            DropdownMenuItem(value: estado, child: Text(estado)))
                        .toList(),
                    labelText: 'Estado',
                    onChanged: (value) => setState(() => _selectedEstado = value),
                    validator: (value) =>
                        value == null ? 'Seleccione un estado' : null,
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    child: Text(widget.produccionToEdit == null
                        ? 'Crear Producción'
                        : 'Actualizar Producción'),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
