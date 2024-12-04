// lib/ui/screens/productor/produccion/produccion_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:agromarket_app/models/Agricultor/produccion.dart';
import 'package:agromarket_app/models/Agricultor/terreno.dart';
import 'package:agromarket_app/models/Agricultor/unidad_medida.dart';
import 'package:agromarket_app/models/Agricultor/producto.dart';
import 'package:agromarket_app/models/Agricultor/temporada.dart';
import 'package:agromarket_app/ui/Themes/theme.dart';
import 'package:agromarket_app/ui/screens/productor/produccion/add_produccion_form.dart';
import 'package:agromarket_app/ui/screens/productor/produccion/view_models/produccion_service.dart';
import 'package:intl/intl.dart';

class ProduccionScreen extends StatefulWidget {
  final int agricultorId;

  const ProduccionScreen({Key? key, required this.agricultorId}) : super(key: key);

  @override
  _ProduccionScreenState createState() => _ProduccionScreenState();
}

class _ProduccionScreenState extends State<ProduccionScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late ProduccionService produccionService;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();

    produccionService = ProduccionService(agricultorId: widget.agricultorId);
    produccionService.fetchAllData();

    produccionService.addListener(() {
      setState(() {});
    });
  }

  /// Muestra el diálogo para agregar una nueva producción
  void _showAddProduccionDialog({Produccion? produccionToEdit}) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: AppThemes.borderColor, width: 2.0),
        ),
        backgroundColor: AppThemes.surfaceColor,
        child: AddProduccionForm(
          produccionService: produccionService,
          produccionToEdit: produccionToEdit,
          onSuccess: (produccion) {
            // La lista se actualiza automáticamente a través del listener del servicio
            if (produccionToEdit == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Producción creada exitosamente.'),
                  backgroundColor: AppThemes.primaryColor,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Producción actualizada exitosamente.'),
                  backgroundColor: AppThemes.primaryColor,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  /// Elimina una producción después de confirmación
  void _deleteProduccion(Produccion produccion) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppThemes.surfaceColor,
        title: const Text('Eliminar Producción'),
        content: const Text('¿Está seguro de que desea eliminar esta producción?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar', style: TextStyle(color: AppThemes.accentColor)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar', style: TextStyle(color: AppThemes.errorColor)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await produccionService.deleteProduccion(produccion.id);
      if (produccionService.errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(produccionService.errorMessage),
            backgroundColor: AppThemes.errorColor,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Producción eliminada exitosamente.'),
            backgroundColor: AppThemes.primaryColor,
          ),
        );
      }
    }
  }

  /// Construye la tarjeta para cada producción
  Widget _buildProduccionCard(Produccion produccion, Animation<double> animation) {
    final unidadMedida = produccionService.unidadesMedida.firstWhere(
      (unidad) => unidad.id == produccion.idUnidadMedida,
      orElse: () => UnidadMedida(id: 0, nombre: 'Desconocido'),
    );

    final producto = produccionService.productos.firstWhere(
      (p) => p.id == produccion.id_producto,
      orElse: () => Producto(id: 0, idCategoria: 0, nombre: 'Desconocido'),
    );

    final terreno = produccionService.terrenos.firstWhere(
      (t) => t.id == produccion.id_terreno,
      orElse: () => Terreno(
        id: 0,
        idAgricultor: 0,
        descripcion: 'Desconocido',
        area: 0.0,
        superficieTotal: 0.0,
        ubicacionLatitud: 0.0,
        ubicacionLongitud: 0.0,
      ),
    );

    final temporada = produccionService.temporadas.firstWhere(
      (t) => t.id == produccion.id_temporada,
      orElse: () => Temporada(
        id: 0,
        nombre: 'Desconocida',
        fechaInicio: DateTime(2000),
        fechaFin: DateTime(2100),
      ),
    );

    // Determinar el color del estado
    Color statusColor = produccion.estado.toLowerCase() == 'activo'
        ? AppThemes.accentColor
        : AppThemes.errorColor;

    return FadeTransition(
      opacity: animation,
      child: GestureDetector(
        onTap: () {
          _showAddProduccionDialog(produccionToEdit: produccion);
        },
        onLongPress: () {
          _deleteProduccion(produccion);
        },
        child: CustomCard(
          title: producto.nombre, // Nombre del producto como título
          subtitle: 'Descripción: ${produccion.descripcion}\n'
              'Terreno: ${terreno.descripcion}\n'
              'Temporada: ${temporada.nombre}\n'
              'Cantidad: ${produccion.cantidad} ${unidadMedida.nombre}\n'
              'Fecha de Cosecha: ${DateFormat('dd MMM yyyy').format(produccion.fechaCosecha)}\n'
              'Fecha de Expiración: ${DateFormat('dd MMM yyyy').format(produccion.fechaExpiracion)}\n'
              'Estado: ${produccion.estado}', // Información detallada
          icon: Icons.grass, // Ícono representativo
          status: produccion.estado,
          statusColor: statusColor,
        ),
      ),
    );
  }

  /// Construye la lista de producciones
  Widget _buildProduccionesList() {
    if (produccionService.isLoading) {
      return Center(child: CircularProgressIndicator(color: AppThemes.primaryColor));
    }

    if (produccionService.producciones.isEmpty) {
      return Center(
        child: Text(
          'No hay producciones disponibles.',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppThemes.primaryColor,
              ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      itemCount: produccionService.producciones.length,
      itemBuilder: (context, index) {
        final produccion = produccionService.producciones[index];
        final animation = CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        );
        return _buildProduccionCard(produccion, animation);
      },
    );
  }

  /// Construye el botón flotante para agregar una nueva producción
  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: AppThemes.primaryColor,
      child: const Icon(Icons.add, color: AppThemes.secondaryColor),
      onPressed: () => _showAddProduccionDialog(),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    produccionService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.backgroundColor,
      appBar: AppBar(
        title: const Text("Producciones"),
        centerTitle: true,
        backgroundColor: AppThemes.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppThemes.secondaryColor),
            onPressed: () async {
              await produccionService.fetchAllData();
              if (produccionService.errorMessage.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(produccionService.errorMessage),
                    backgroundColor: AppThemes.errorColor,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Datos actualizados.'),
                    backgroundColor: AppThemes.primaryColor,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _buildProduccionesList(),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }
}
