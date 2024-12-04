import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:agromarket_app/models/Agricultor/oferta.dart';
import 'package:agromarket_app/models/Agricultor/oferta_detalle.dart';
import 'package:agromarket_app/models/Agricultor/produccion.dart';
import 'package:agromarket_app/models/Agricultor/unidad_medida.dart';
import 'package:agromarket_app/models/Agricultor/moneda.dart';
import 'package:agromarket_app/ui/Themes/theme.dart';
import 'package:intl/intl.dart';
import 'package:agromarket_app/ui/screens/productor/oferta/view_models/oferta_service.dart';

class AddOfertaForm extends StatefulWidget {
  final OfertaService ofertaService;
  final Oferta? ofertaToEdit;
  final OfertaDetalle? detalleToEdit;
  final void Function(Map<String, dynamic> result)? onSuccess;

  const AddOfertaForm({
    Key? key,
    required this.ofertaService,
    this.ofertaToEdit,
    this.detalleToEdit,
    this.onSuccess,
  }) : super(key: key);

  @override
  State<AddOfertaForm> createState() => _AddOfertaFormState();
}

class _AddOfertaFormState extends State<AddOfertaForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers for Oferta
  final TextEditingController _fechaCreacionController =
      TextEditingController();
  final TextEditingController _fechaExpiracionController =
      TextEditingController();
  DateTime? _fechaCreacion;
  DateTime? _fechaExpiracion;
  Produccion? _selectedProduccion;
  String? _selectedEstadoOferta;

  // Controllers for OfertaDetalle
  final TextEditingController _cantidadFisicoController =
      TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  UnidadMedida? _selectedUnidadMedida;
  Moneda? _selectedMoneda;
  String? _selectedEstadoDetalle;

  bool _isLoading = false;
  bool _showDetalleForm = false;
  double _cantidadDisponible = 0.0;

  @override
  void initState() {
    super.initState();

    if (widget.ofertaToEdit != null) {
      _initializeOferta();
    }
    if (widget.detalleToEdit != null) {
      _initializeDetalle();
      _showDetalleForm = true;
    }
  }

  @override
  void dispose() {
    _fechaCreacionController.dispose();
    _fechaExpiracionController.dispose();
    _cantidadFisicoController.dispose();
    _precioController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  void _initializeOferta() {
    _selectedProduccion = widget.ofertaService.producciones.firstWhere(
      (p) => p.id == widget.ofertaToEdit!.idProduccion,
      orElse: () => widget.ofertaService.producciones.first,
    );
    _fechaCreacion = widget.ofertaToEdit!.fechaCreacion;
    _fechaExpiracion = widget.ofertaToEdit!.fechaExpiracion;
    _fechaCreacionController.text =
        DateFormat('yyyy-MM-dd').format(_fechaCreacion!);
    _fechaExpiracionController.text =
        DateFormat('yyyy-MM-dd').format(_fechaExpiracion!);
    _selectedEstadoOferta = widget.ofertaToEdit!.estado;
    _cantidadDisponible = _selectedProduccion?.cantidad ?? 0.0;
  }

  void _initializeDetalle() {
    _cantidadFisicoController.text =
        widget.detalleToEdit!.cantidadFisico.toString();
    _precioController.text = widget.detalleToEdit!.precio.toString();
    _descripcionController.text = widget.detalleToEdit!.descripcion ?? '';
    _selectedUnidadMedida = widget.ofertaService.unidadesMedida.firstWhere(
      (u) => u.id == widget.detalleToEdit!.idUnidadMedida,
      orElse: () => widget.ofertaService.unidadesMedida.first,
    );
    _selectedMoneda = widget.ofertaService.monedas.firstWhere(
      (m) => m.id == widget.detalleToEdit!.idMoneda,
      orElse: () => widget.ofertaService.monedas.first,
    );
    _selectedEstadoDetalle = widget.detalleToEdit!.estado;
  }

  Future<void> _selectDate(
      BuildContext context,
      TextEditingController controller,
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
      _showSnackBar(
          'Fecha seleccionada correctamente.', AppThemes.successColor);
    } else {
      _showSnackBar('No se seleccionó ninguna fecha.', AppThemes.errorColor);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      _showSnackBar('Complete los campos requeridos antes de continuar.',
          AppThemes.errorColor);
      return;
    }

    if (_fechaCreacion == null || _fechaExpiracion == null) {
      _showSnackBar('Seleccione ambas fechas: creación y expiración.',
          AppThemes.errorColor);
      return;
    }

    if (_fechaExpiracion!.isBefore(_fechaCreacion!)) {
      _showSnackBar(
          'La fecha de expiración debe ser posterior a la fecha de creación.',
          AppThemes.errorColor);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.ofertaToEdit == null) {
        final newOferta = Oferta(
          id: null,
          idProduccion: _selectedProduccion!.id,
          fechaCreacion: _fechaCreacion!,
          fechaExpiracion: _fechaExpiracion!,
          estado: _selectedEstadoOferta!,
        );

        final newDetalle = OfertaDetalle(
          id: null,
          idProduccion: _selectedProduccion!.id,
          idOferta: 0,
          idUnidadMedida: _selectedUnidadMedida!.id,
          idMoneda: _selectedMoneda!.id,
          descripcion: _descripcionController.text,
          cantidadFisico: double.parse(_cantidadFisicoController.text),
          cantidadComprometido: null,
          precio: double.parse(_precioController.text),
          precioUnitario: double.parse(_precioController.text) /
              double.parse(_cantidadFisicoController.text),
          estado: 'activo',
        );

        final result = await widget.ofertaService.addOferta(newOferta, newDetalle);

        if (result.isNotEmpty && widget.onSuccess != null) {
          widget.onSuccess!(result);
          Navigator.pop(context);
        } else {
          _showSnackBar(widget.ofertaService.errorMessage, AppThemes.errorColor);
        }
      } else {
        final updatedOferta = Oferta(
          id: widget.ofertaToEdit!.id,
          idProduccion: _selectedProduccion!.id,
          fechaCreacion: _fechaCreacion!,
          fechaExpiracion: _fechaExpiracion!,
          estado: _selectedEstadoOferta!,
        );

        final updatedDetalle = OfertaDetalle(
          id: widget.detalleToEdit!.id,
          idProduccion: _selectedProduccion!.id,
          idOferta: widget.ofertaToEdit!.id!,
          idUnidadMedida: _selectedUnidadMedida!.id,
          idMoneda: _selectedMoneda!.id,
          descripcion: _descripcionController.text,
          cantidadFisico: double.parse(_cantidadFisicoController.text),
          cantidadComprometido: widget.detalleToEdit!.cantidadComprometido,
          precio: double.parse(_precioController.text),
          precioUnitario: double.parse(_precioController.text) /
              double.parse(_cantidadFisicoController.text),
          estado: _selectedEstadoDetalle!,
        );

        await widget.ofertaService.updateOferta(updatedOferta, updatedDetalle);

        if (widget.ofertaService.errorMessage.isEmpty && widget.onSuccess != null) {
          widget.onSuccess!({
            'oferta': updatedOferta,
            'detalle': updatedDetalle,
          });
          Navigator.pop(context);
        } else {
          _showSnackBar(widget.ofertaService.errorMessage, AppThemes.errorColor);
        }
      }
    } catch (e) {
      _showSnackBar('Error al procesar la oferta: $e', AppThemes.errorColor);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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

  Widget _buildDropdownField<T>({
    required String labelText,
    required T? value,
    required List<T> items,
    required String Function(T) itemLabel,
    required void Function(T?) onChanged,
    required String? Function(T?) validator,
  }) {
    return DropdownButtonFormField<T>(
      key: ValueKey(labelText),
      value: value,
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            itemLabel(item),
            style: TextStyle(fontSize: 14.sp, color: AppThemes.accentColor),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: AppThemes.accentColor),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppThemes.accentColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppThemes.accentColor, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      ),
      validator: validator,
      isExpanded: true,
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
        labelStyle: TextStyle(color: AppThemes.accentColor),
        prefixIcon:
            icon != null ? Icon(icon, color: AppThemes.accentColor) : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppThemes.accentColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppThemes.accentColor, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      ),
      keyboardType: keyboardType,
      validator: validator,
      readOnly: readOnly,
      onTap: onTap,
      style: TextStyle(fontSize: 14.sp, color: AppThemes.accentColor),
      autovalidateMode:
          AutovalidateMode.onUserInteraction,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.ofertaToEdit != null;

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
                    isEditing ? 'Editar Oferta' : 'Crear Nueva Oferta',
                    style: TextStyle(
                      color: AppThemes.accentColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),
                  // Campo de selección de Producción
                  _buildDropdownField<Produccion>(
                    labelText: 'Producción *',
                    value: _selectedProduccion,
                    items: widget.ofertaService.producciones,
                    itemLabel: (produccion) => produccion.descripcion,
                    onChanged: (value) {
                      setState(() {
                        _selectedProduccion = value;
                        if (value != null) {
                          _selectedUnidadMedida =
                              widget.ofertaService.unidadesMedida.firstWhere(
                            (unidad) => unidad.id == value.idUnidadMedida,
                            orElse: () => widget.ofertaService.unidadesMedida.first,
                          );
                          _cantidadDisponible =
                              value.cantidad;
                        } else {
                          _selectedUnidadMedida = null;
                          _cantidadDisponible = 0.0;
                        }
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Seleccione una producción' : null,
                  ),
                  SizedBox(height: 12.h),
                  // Campo de Fecha de Creación
                  _buildTextField(
                    controller: _fechaCreacionController,
                    labelText: 'Fecha de Creación *',
                    readOnly: true,
                    onTap: () =>
                        _selectDate(context, _fechaCreacionController, (date) {
                      setState(() {
                        _fechaCreacion = date;
                      });
                    }),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Seleccione la fecha de creación'
                        : null,
                    icon: Icons.calendar_today,
                  ),
                  SizedBox(height: 12.h),
                  // Campo de Fecha de Expiración
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
                    validator: (value) => value == null || value.isEmpty
                        ? 'Seleccione la fecha de expiración'
                        : null,
                    icon: Icons.calendar_today,
                  ),
                  SizedBox(height: 12.h),
                  // Campo de Estado de la Oferta
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
                  // Botón para continuar y mostrar los campos del detalle de oferta
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemes.borderColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: AppThemes.accentColor),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _showDetalleForm = true;
                              });
                            } else {
                              _showSnackBar('Complete los campos requeridos.',
                                  AppThemes.errorColor);
                            }
                          },
                    child: Text(
                      'Continuar',
                      style: TextStyle(
                        color: AppThemes.accentColor,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Campos del Detalle de Oferta
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: _showDetalleForm
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Título del detalle
                              Text(
                                'Datos del Detalle de Oferta',
                                style: TextStyle(
                                  color: AppThemes.accentColor,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 12.h),
                              // Campo de Descripción
                              _buildTextField(
                                controller: _descripcionController,
                                labelText: 'Descripción',
                              ),
                              SizedBox(height: 12.h),
                              // Campo de Unidad de Medida
                              _buildDropdownField<UnidadMedida>(
                                labelText: 'Unidad de Medida *',
                                value: _selectedUnidadMedida,
                                items: widget.ofertaService.unidadesMedida,
                                itemLabel: (unidad) => unidad.nombre,
                                onChanged: (value) =>
                                    setState(() => _selectedUnidadMedida = value),
                                validator: (value) => value == null
                                    ? 'Seleccione una unidad de medida'
                                    : null,
                              ),
                              SizedBox(height: 12.h),
                              // Campo de Moneda
                              _buildDropdownField<Moneda>(
                                labelText: 'Moneda *',
                                value: _selectedMoneda,
                                items: widget.ofertaService.monedas,
                                itemLabel: (moneda) => moneda.nombre,
                                onChanged: (value) =>
                                    setState(() => _selectedMoneda = value),
                                validator: (value) => value == null
                                    ? 'Seleccione una moneda'
                                    : null,
                              ),
                              SizedBox(height: 12.h),
                              // Campo de Cantidad Física
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
                                      cantidad > _cantidadDisponible) {
                                    return 'Cantidad supera lo disponible (${_cantidadDisponible})';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 12.h),
                              // Campo de Precio
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
                              // Campo de Estado del Detalle
                              _buildDropdownField<String>(
                                labelText: 'Estado *',
                                value: _selectedEstadoDetalle,
                                items: ['activo', 'inactivo'],
                                itemLabel: (estado) => estado,
                                onChanged: (value) => setState(
                                    () => _selectedEstadoDetalle = value),
                                validator: (value) => value == null
                                    ? 'Seleccione un estado'
                                    : null,
                              ),
                              SizedBox(height: 24.h),
                              // Botón para crear o actualizar la oferta
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppThemes.accentColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    side: BorderSide(
                                        color: AppThemes.accentColor),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 14.h),
                                ),
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          _submitForm();
                                        } else {
                                          _showSnackBar(
                                              'Complete los campos requeridos.',
                                              AppThemes.errorColor);
                                        }
                                      },
                                child: Text(
                                  isEditing
                                      ? 'Actualizar Oferta'
                                      : 'Crear Oferta',
                                  style: TextStyle(
                                    color: AppThemes.accentColor,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
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
