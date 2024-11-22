// lib/ui/screens/productor/oferta/add_oferta_form.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:agromarket_app/models/Agricultor/oferta.dart';
import 'package:agromarket_app/models/Agricultor/oferta_detalle.dart';
import 'package:agromarket_app/models/Agricultor/produccion.dart';
import 'package:agromarket_app/models/Agricultor/unidad_medida.dart';
import 'package:agromarket_app/models/Agricultor/moneda.dart';
import 'package:agromarket_app/services/api_service.dart';
import 'package:agromarket_app/ui/Themes/theme.dart';

class AddOfertaForm extends StatefulWidget {
  final int agricultorId;
  final List<Produccion> producciones;
  final List<UnidadMedida> unidadesMedida;
  final List<Moneda> monedas;
  final Oferta? ofertaToEdit;
  final OfertaDetalle? detalleToEdit;
  final void Function(Oferta newOferta)? onOfertaCreated;
  final void Function(Oferta updatedOferta)? onOfertaUpdated;

  const AddOfertaForm({
    Key? key,
    required this.agricultorId,
    required this.producciones,
    required this.unidadesMedida,
    required this.monedas,
    this.ofertaToEdit,
    this.detalleToEdit,
    this.onOfertaCreated,
    this.onOfertaUpdated,
  }) : super(key: key);

  @override
  State<AddOfertaForm> createState() => _AddOfertaFormState();
}


class _AddOfertaFormState extends State<AddOfertaForm> {
  final _formKeyOferta = GlobalKey<FormState>();
  final _formKeyDetalle = GlobalKey<FormState>();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers for Oferta
  final TextEditingController _fechaCreacionController = TextEditingController();
  final TextEditingController _fechaExpiracionController = TextEditingController();
  DateTime? _fechaCreacion;
  DateTime? _fechaExpiracion;
  Produccion? _selectedProduccion;
  String? _selectedEstadoOferta;

  // Controllers for OfertaDetalle
  final TextEditingController _cantidadFisicoController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  UnidadMedida? _selectedUnidadMedida;
  Moneda? _selectedMoneda;
  String? _selectedEstadoDetalle;

  late ApiService _apiService;
  bool _isLoading = false;
  bool _showDetalleForm = false;
  double _cantidadDisponible = 0.0;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();

    // Initialize form fields with existing data if editing
    if (widget.ofertaToEdit != null) {
      _initializeOferta();
    }
    if (widget.detalleToEdit != null) {
      _initializeDetalle();
    }
  }

  void _initializeOferta() {
    _selectedProduccion = widget.producciones.firstWhere(
      (p) => p.id == widget.ofertaToEdit!.idProduccion,
      orElse: () => widget.producciones.first,
    );
    _fechaCreacion = widget.ofertaToEdit!.fechaCreacion;
    _fechaExpiracion = widget.ofertaToEdit!.fechaExpiracion;
    _fechaCreacionController.text = _fechaCreacion!.toIso8601String().split('T')[0];
    _fechaExpiracionController.text = _fechaExpiracion!.toIso8601String().split('T')[0];
    _selectedEstadoOferta = widget.ofertaToEdit!.estado;
    _cantidadDisponible = _selectedProduccion?.cantidad?? 0.0;
  }

  void _initializeDetalle() {
    _cantidadFisicoController.text = widget.detalleToEdit!.cantidadFisico.toString();
    _precioController.text = widget.detalleToEdit!.precio.toString();
    _descripcionController.text = widget.detalleToEdit!.descripcion ?? '';
    _selectedUnidadMedida = widget.unidadesMedida.firstWhere(
      (u) => u.id == widget.detalleToEdit!.idUnidadMedida,
      orElse: () => widget.unidadesMedida.first,
    );
    _selectedMoneda = widget.monedas.firstWhere(
      (m) => m.id == widget.detalleToEdit!.idMoneda,
      orElse: () => widget.monedas.first,
    );
    _selectedEstadoDetalle = widget.detalleToEdit!.estado;
    _showDetalleForm = true;
  }

Future<void> _selectDate(BuildContext context, TextEditingController controller, Function(DateTime) onDateSelected) async {
  final pickedDate = await showDatePicker(
    context: context,
    initialDate: controller.text.isNotEmpty
        ? DateTime.parse(controller.text)
        : DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );

  if (pickedDate != null) {
    setState(() {
      onDateSelected(pickedDate);
      controller.text = pickedDate.toLocal().toIso8601String().split('T')[0];
    });
    _showSnackBar('Fecha seleccionada correctamente.', AppThemes.primaryColor);
  } else {
    _showSnackBar('No se seleccionó ninguna fecha.', AppThemes.errorColor);
  }
}

Future<void> _submitForm() async {
  if (!_formKey.currentState!.validate()) {
    _showSnackBar('Complete los campos requeridos antes de continuar.', AppThemes.errorColor);
    return;
  }

  if (_fechaCreacion == null || _fechaExpiracion == null) {
    _showSnackBar('Seleccione ambas fechas: creación y expiración.', AppThemes.errorColor);
    return;
  }

  // Validar si la fecha de expiración es posterior a la de creación
  if (_fechaExpiracion!.isBefore(_fechaCreacion!)) {
    _showSnackBar('La fecha de expiración debe ser posterior a la fecha de creación.', AppThemes.errorColor);
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {
    if (widget.ofertaToEdit == null) {
      // Crear nueva oferta
      await _createOfertaAndDetalle();
    } else {
      // Actualizar oferta existente
      await _updateOfertaAndDetalle();
    }
    _showSnackBar('Oferta procesada exitosamente.', AppThemes.primaryColor);
  } catch (e) {
    print('Error: $e');
    _showSnackBar('Error al procesar la oferta: $e', AppThemes.errorColor);
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}


 Future<void> _createOfertaAndDetalle() async {
  try {
    // Crear Oferta
    final newOfertaData = {
      'id_produccion': _selectedProduccion!.id,
      'fecha_creacion': _fechaCreacion!.toIso8601String(),
      'fecha_expiracion': _fechaExpiracion!.toIso8601String(),
      'estado': _selectedEstadoOferta!,
    };

    final createdOferta = await _apiService.Ofertas_createOferta(newOfertaData);

    // Validar cantidad disponible
    final produccionSeleccionada = widget.producciones.firstWhere(
        (p) => p.id == _selectedProduccion!.id);
    if (double.parse(_cantidadFisicoController.text) >
        produccionSeleccionada.cantidad) {
      _showSnackBar(
        'La cantidad ingresada excede la cantidad disponible (${produccionSeleccionada.cantidad}).',
        AppThemes.errorColor,
      );
      return;
    }

    // Crear OfertaDetalle
    final newDetalleData = {
      'id_oferta': createdOferta.id,
      'id_produccion': _selectedProduccion!.id,
      'id_unidadmedida': _selectedUnidadMedida!.id,
      'id_moneda': _selectedMoneda!.id,
      'descripcion': _descripcionController.text,
      'cantidad_fisico': double.parse(_cantidadFisicoController.text),
      'precio': double.parse(_precioController.text),
      'estado': _selectedEstadoDetalle!,
    };

    await _apiService.Ofertas_detalle_createOfertaDetalle(newDetalleData);

    widget.onOfertaCreated?.call(createdOferta);
    _showSnackBar('Oferta creada exitosamente.', AppThemes.primaryColor);
    Navigator.pop(context);
  } catch (e) {
    print('Error al crear oferta y detalle: $e');
    _showSnackBar('Error al crear la oferta.', AppThemes.errorColor);
  }
}

Future<void> _updateOfertaAndDetalle() async {
  try {
    // Actualizar Oferta
    final updatedOfertaData = {
      'id_produccion': _selectedProduccion!.id,
      'fecha_creacion': _fechaCreacion!.toIso8601String(),
      'fecha_expiracion': _fechaExpiracion!.toIso8601String(),
      'estado': _selectedEstadoOferta!,
    };

    final updatedOferta = await _apiService.Ofertas_updateOferta(
      widget.ofertaToEdit!.id,
      updatedOfertaData,
    );

    // Validar cantidad disponible
    final produccionSeleccionada = widget.producciones.firstWhere(
        (p) => p.id == _selectedProduccion!.id);
    if (double.parse(_cantidadFisicoController.text) >
        produccionSeleccionada.cantidad) {
      _showSnackBar(
        'La cantidad ingresada excede la cantidad disponible (${produccionSeleccionada.cantidad}).',
        AppThemes.errorColor,
      );
      return;
    }

    // Actualizar OfertaDetalle
    final updatedDetalleData = {
      'id_oferta': updatedOferta.id,
      'id_produccion': _selectedProduccion!.id,
      'id_unidadmedida': _selectedUnidadMedida!.id,
      'id_moneda': _selectedMoneda!.id,
      'descripcion': _descripcionController.text,
      'cantidad_fisico': double.parse(_cantidadFisicoController.text),
      'precio': double.parse(_precioController.text),
      'estado': _selectedEstadoDetalle!,
    };

    await _apiService.Ofertas_detalle_updateOfertaDetalle(
      widget.detalleToEdit!.id,
      updatedDetalleData,
    );

    widget.onOfertaUpdated?.call(updatedOferta);
    _showSnackBar('Oferta actualizada exitosamente.', AppThemes.primaryColor);
    Navigator.pop(context);
  } catch (e) {
    print('Error al actualizar oferta y detalle: $e');
    _showSnackBar('Error al actualizar la oferta.', AppThemes.errorColor);
  }
}



void _showSnackBar(String message, Color backgroundColor) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}


Widget _buildDropdownField<T>({
  required String labelText,
  required T? value,
  required List<T> items,
  required String Function(T) itemLabel,
  required void Function(T?) onChanged,
  required String? Function(T?) validator,
}) {
  return DropdownButtonFormField<T>(
    value: value,
    items: items.map((item) {
      return DropdownMenuItem<T>(
        value: item,
        child: Text(
          itemLabel(item),
          style: TextStyle(fontSize: 14.sp),
        ),
      );
    }).toList(),
    onChanged: onChanged,
    decoration: InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
    ),
    validator: validator,
    isExpanded: true, // Para manejar textos largos
  );
}

 Widget _buildTextField({
  required TextEditingController controller,
  required String labelText,
  TextInputType? keyboardType,
  String? Function(String?)? validator,
  bool readOnly = false,
  VoidCallback? onTap,
  IconData? icon,
}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: labelText,
      prefixIcon: icon != null ? Icon(icon, color: AppThemes.primaryColor) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
    ),
    keyboardType: keyboardType,
    validator: validator,
    readOnly: readOnly,
    onTap: onTap,
    style: TextStyle(fontSize: 14.sp),
    autovalidateMode: AutovalidateMode.onUserInteraction, // Validación dinámica
  );
}

@override
Widget build(BuildContext context) {
  return Material(
    color: Colors.transparent,
    child: Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      widget.ofertaToEdit == null
                          ? 'Crear Nueva Oferta'
                          : 'Editar Oferta',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.h),
                    _buildDropdownField<Produccion>(
                      labelText: 'Producción *',
                      value: _selectedProduccion,
                      items: widget.producciones,
                      itemLabel: (produccion) => produccion.descripcion,
                      onChanged: (value) {
                        setState(() {
                          _selectedProduccion = value;
                          if (value != null) {
                            _selectedUnidadMedida = widget.unidadesMedida.firstWhere(
                              (unidad) => unidad.id == value.idUnidadMedida,
                              orElse: () => widget.unidadesMedida.first,
                            );
                          }
                        });
                      },
                      validator: (value) => value == null
                          ? 'Seleccione una producción'
                          : null,
                    ),
                    SizedBox(height: 12.h),
                    _buildTextField(
                      controller: _fechaCreacionController,
                      labelText: 'Fecha de Creación *',
                      readOnly: true,
                      onTap: () => _selectDate(context, _fechaCreacionController,
                          (date) {
                        setState(() {
                          _fechaCreacion = date;
                        });
                      }),
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? 'Seleccione la fecha de creación'
                              : null,
                      icon: Icons.calendar_today,
                    ),
                    SizedBox(height: 12.h),
                    _buildTextField(
                      controller: _fechaExpiracionController,
                      labelText: 'Fecha de Expiración *',
                      readOnly: true,
                      onTap: () => _selectDate(
                          context, _fechaExpiracionController, (date) {
                        setState(() {
                          _fechaExpiracion = date;
                        });
                      }),
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? 'Seleccione la fecha de expiración'
                              : null,
                      icon: Icons.calendar_today,
                    ),
                    SizedBox(height: 12.h),
                    _buildDropdownField<String>(
                      labelText: 'Estado *',
                      value: _selectedEstadoOferta,
                      items: ['activo', 'inactivo'],
                      itemLabel: (estado) => estado,
                      onChanged: (value) =>
                          setState(() => _selectedEstadoOferta = value),
                      validator: (value) =>
                          value == null ? 'Seleccione un estado' : null,
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      onPressed: _formKey.currentState?.validate() ?? false
                          ? () => setState(() => _showDetalleForm = true)
                          : null,
                      child: Text('Continuar'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: _showDetalleForm
                    ? Form(
                        key: _formKeyDetalle,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Datos del Detalle de Oferta',
                              style: Theme.of(context).textTheme.headlineSmall,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 12.h),
                            _buildTextField(
                              controller: _descripcionController,
                              labelText: 'Descripción',
                            ),
                            SizedBox(height: 12.h),
                            _buildDropdownField<UnidadMedida>(
                              labelText: 'Unidad de Medida *',
                              value: _selectedUnidadMedida,
                              items: widget.unidadesMedida,
                              itemLabel: (unidad) => unidad.nombre,
                              onChanged: (value) =>
                                  setState(() => _selectedUnidadMedida = value), // Bloqueado por producción
                              validator: (value) =>
                                  value == null
                                      ? 'Seleccione una unidad de medida'
                                      : null,
                            ),
                            SizedBox(height: 12.h),
                            _buildDropdownField<Moneda>(
                              labelText: 'Moneda *',
                              value: _selectedMoneda,
                              items: widget.monedas,
                              itemLabel: (moneda) => moneda.nombre,
                              onChanged: (value) =>
                                  setState(() => _selectedMoneda = value),
                              validator: (value) =>
                                  value == null ? 'Seleccione una moneda' : null,
                            ),
                            SizedBox(height: 12.h),
                            _buildTextField(
                              controller: _cantidadFisicoController,
                              labelText: 'Cantidad Física *',
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingrese la cantidad física';
                                }
                                final cantidad =
                                    double.tryParse(value) ?? 0.0;
                                if (_selectedProduccion != null &&
                                    cantidad > _selectedProduccion!.cantidad) {
                                  return 'Cantidad supera lo disponible (${_selectedProduccion!.cantidad})';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 12.h),
                            _buildTextField(
                              controller: _precioController,
                              labelText: 'Precio *',
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingrese el precio';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Ingrese un valor numérico válido';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 12.h),
                            _buildDropdownField<String>(
                              labelText: 'Estado *',
                              value: _selectedEstadoDetalle,
                              items: ['activo', 'inactivo'],
                              itemLabel: (estado) => estado,
                              onChanged: (value) =>
                                  setState(() => _selectedEstadoDetalle = value),
                              validator: (value) =>
                                  value == null ? 'Seleccione un estado' : null,
                            ),
                            SizedBox(height: 24.h),
                            ElevatedButton(
                              onPressed: _formKeyDetalle.currentState?.validate() ?? false
                                  ? _submitForm
                                  : null,
                              child: Text(
                                widget.ofertaToEdit == null
                                    ? 'Crear Oferta'
                                    : 'Actualizar Oferta',
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
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
