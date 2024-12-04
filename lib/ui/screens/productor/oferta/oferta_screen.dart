import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:agromarket_app/models/Agricultor/oferta.dart';
import 'package:agromarket_app/models/Agricultor/oferta_detalle.dart';
import 'package:agromarket_app/ui/Themes/theme.dart';
import 'package:agromarket_app/models/Agricultor/produccion.dart';
import 'package:agromarket_app/models/Agricultor/unidad_medida.dart';
import 'package:agromarket_app/models/Agricultor/moneda.dart';
import 'package:agromarket_app/ui/screens/productor/oferta/add_oferta_form.dart';
import 'package:agromarket_app/ui/screens/productor/oferta/view_models/oferta_service.dart';
import 'package:intl/intl.dart';

class OfertaScreen extends StatefulWidget {
  final int agricultorId;

  const OfertaScreen({Key? key, required this.agricultorId}) : super(key: key);

  @override
  _OfertaScreenState createState() => _OfertaScreenState();
}

class _OfertaScreenState extends State<OfertaScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late OfertaService ofertaService;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animationController.forward();

    ofertaService = OfertaService(agricultorId: widget.agricultorId);
    ofertaService.fetchAllData();

    ofertaService.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    ofertaService.dispose();
    super.dispose();
  }

  /// Mostrar SnackBar
  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// Crear tarjeta para mostrar cada oferta
  Widget _buildCombinedOfferCard(Oferta offer) {
    // Filtrar detalles asociados a esta oferta
    final details = ofertaService.detalles.where((d) => d.idOferta == offer.id).toList();

    // Buscar la producción asociada
    final produccion = ofertaService.getProduccionById(offer.idProduccion) ??
        Produccion(
          id: 0,
          id_terreno: 0,
          id_temporada: 0,
          id_producto: 0,
          idUnidadMedida: 0,
          descripcion: 'Producción desconocida',
          cantidad: 0.0,
          fechaCosecha: DateTime(2000),
          fechaExpiracion: DateTime(2100),
          estado: 'Desconocido',
        );

    // Determinar color de estado
    Color statusColor = offer.estado.toLowerCase() == 'activo'
        ? AppThemes.primaryColor
        : AppThemes.errorColor;

    // Construcción de los detalles en texto para el subtítulo
    String detailsText = details.isNotEmpty
        ? details.map((detail) {
            final unidadMedida = ofertaService.getUnidadMedidaById(detail.idUnidadMedida) ??
                UnidadMedida(id: 0, nombre: 'Desconocida');

            final moneda = ofertaService.getMonedaById(detail.idMoneda) ??
                Moneda(id: 0, nombre: 'Desconocida');

            return '''
Descripción: ${detail.descripcion ?? 'Sin descripción'}
Cantidad Física: ${detail.cantidadFisico} ${unidadMedida.nombre}
Cantidad Comprometida: ${detail.cantidadComprometido ?? 0} ${unidadMedida.nombre}
Precio Total: ${detail.precio.toStringAsFixed(2)} ${moneda.nombre}
Precio Unitario: ${(detail.precioUnitario ?? 0).toStringAsFixed(2)} ${moneda.nombre}/${unidadMedida.nombre}
Estado: ${detail.estado}
''';
          }).join('\n')
        : 'No hay detalles asociados.';

    return FadeTransition(
      opacity: _animationController,
      child: GestureDetector(
        onLongPress: () => _deleteOferta(offer),
        child: CustomCard(
          title: 'Oferta: ${produccion.descripcion}',
          subtitle:
              'Estado: ${offer.estado}\nCreado: ${DateFormat('dd MMM yyyy').format(offer.fechaCreacion)}\nExpira: ${DateFormat('dd MMM yyyy').format(offer.fechaExpiracion)}\n\nDetalles:\n$detailsText',
          icon: Icons.local_offer_outlined,
          status: offer.estado,
          statusColor: statusColor,
          onTap: () {
            if (details.isNotEmpty) {
              _editOferta(offer, details.first);
            }
          },
        ),
      ),
    );
  }

  /// Lista de ofertas
  Widget _buildOffersList() {
    if (ofertaService.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: AppThemes.primaryColor,
        ),
      );
    }

    if (ofertaService.errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          ofertaService.errorMessage,
          style: TextStyle(color: AppThemes.errorColor, fontSize: 16.sp),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (ofertaService.ofertas.isEmpty) {
      return Center(
        child: Text(
          'No hay ofertas disponibles.',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppThemes.primaryColor,
              ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      itemCount: ofertaService.ofertas.length,
      itemBuilder: (context, index) {
        final offer = ofertaService.ofertas[index];
        return _buildCombinedOfferCard(offer);
      },
    );
  }

  /// Botón flotante para agregar oferta
  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: AppThemes.primaryColor,
      child: const Icon(Icons.add, color: AppThemes.secondaryColor),
      onPressed: () => _showAddOfertaDialog(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: AppThemes.accentColor, width: 2.0),
      ),
    );
  }

  /// Mostrar diálogo para agregar oferta
  Future<void> _showAddOfertaDialog() async {
    if (ofertaService.producciones.isEmpty ||
        ofertaService.unidadesMedida.isEmpty ||
        ofertaService.monedas.isEmpty) {
      _showSnackBar('Datos incompletos. No se puede crear una oferta.', AppThemes.errorColor);
      return;
    }

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: AppThemes.borderColor, width: 2.0),
          ),
          backgroundColor: AppThemes.surfaceColor,
          child: AddOfertaForm(
            ofertaService: ofertaService,
            onSuccess: (result) {
              _showSnackBar('Oferta creada exitosamente.', AppThemes.successColor);
            },
          ),
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      // Esto ya se maneja en el callback onSuccess
    } else if (ofertaService.errorMessage.isNotEmpty) {
      _showSnackBar(ofertaService.errorMessage, AppThemes.errorColor);
    }
  }

  /// Mostrar diálogo para editar oferta
  Future<void> _editOferta(Oferta offer, OfertaDetalle detail) async {
    if (ofertaService.producciones.isEmpty ||
        ofertaService.unidadesMedida.isEmpty ||
        ofertaService.monedas.isEmpty) {
      _showSnackBar('Datos incompletos. No se puede editar la oferta.', AppThemes.errorColor);
      return;
    }

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: AddOfertaForm(
            ofertaService: ofertaService,
            ofertaToEdit: offer,
            detalleToEdit: detail,
            onSuccess: (result) {
              _showSnackBar('Oferta actualizada exitosamente.', AppThemes.successColor);
            },
          ),
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      // Esto ya se maneja en el callback onSuccess
    } else if (ofertaService.errorMessage.isNotEmpty) {
      _showSnackBar(ofertaService.errorMessage, AppThemes.errorColor);
    }
  }

  /// Eliminar oferta
  Future<void> _deleteOferta(Oferta offer) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Oferta'),
        content: const Text('¿Está seguro de eliminar esta oferta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppThemes.accentColor),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: AppThemes.errorColor),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ofertaService.deleteOferta(offer.id!);
      if (ofertaService.errorMessage.isEmpty) {
        _showSnackBar('Oferta eliminada exitosamente.', AppThemes.successColor);
      } else {
        _showSnackBar(ofertaService.errorMessage, AppThemes.errorColor);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.backgroundColor,
      appBar: AppBar(
        title: const Text('Ofertas'),
        centerTitle: true,
        backgroundColor: AppThemes.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppThemes.secondaryColor),
            onPressed: () async {
              await ofertaService.fetchAllData();
              if (ofertaService.errorMessage.isNotEmpty) {
                _showSnackBar(ofertaService.errorMessage, AppThemes.errorColor);
              } else {
                _showSnackBar('Datos actualizados.', AppThemes.successColor);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _buildOffersList(),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }
}
