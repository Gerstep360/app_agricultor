import 'package:agromarket_app/models/Agricultor/produccion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:agromarket_app/models/Agricultor/oferta.dart';
import 'package:agromarket_app/models/Agricultor/oferta_detalle.dart';
import 'package:agromarket_app/services/api_service.dart';
import 'package:agromarket_app/ui/Themes/theme.dart';
import 'package:agromarket_app/ui/screens/productor/oferta/add_oferta_form.dart';
import 'package:agromarket_app/models/Agricultor/unidad_medida.dart';
import 'package:agromarket_app/models/Agricultor/moneda.dart';

class OfertaScreen extends StatefulWidget {
  final int agricultorId;

  const OfertaScreen({Key? key, required this.agricultorId}) : super(key: key);

  @override
  State<OfertaScreen> createState() => _OfertaScreenState();
}

class _OfertaScreenState extends State<OfertaScreen>
    with TickerProviderStateMixin {
  late ApiService _apiService;
  List<Oferta> _offers = [];
  List<OfertaDetalle> _offerDetails = [];
  bool _isLoading = true;
  List<Produccion> _producciones = [];
  List<UnidadMedida> _unidadesMedida = [];
  List<Moneda> _monedas = [];

  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  final DateFormat _formatter = DateFormat('dd MMM yyyy');

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _fetchData();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
  }

  /// Obtener ofertas y detalles del agricultor
  Future<void> _fetchData() async {
    try {
      setState(() => _isLoading = true);

      // Obtener datos necesarios
      final produccionesFuture =
          _apiService.Agricultor_getProducciones(widget.agricultorId);
      final unidadesFuture = _apiService.Unidad_medida_getUnidadMedidas();
      final monedasFuture = _apiService.Monedas_getMonedas();
      final ofertasFuture =
          _apiService.Agricultor_getOfertas(widget.agricultorId);
      final detallesFuture =
          _apiService.Agricultor_getOfertas_detalles(widget.agricultorId);

      final results = await Future.wait([
        produccionesFuture,
        unidadesFuture,
        monedasFuture,
        ofertasFuture,
        detallesFuture,
      ]);

      setState(() {
        _producciones = results[0] as List<Produccion>;
        _unidadesMedida = results[1] as List<UnidadMedida>;
        _monedas = results[2] as List<Moneda>;
        _offers = results[3] as List<Oferta>;
        _offerDetails = results[4] as List<OfertaDetalle>;
        _isLoading = false;
      });

      print(
          'Datos cargados: ${_offers.length} ofertas, ${_offerDetails.length} detalles.');
    } catch (e) {
      debugPrint('Error al obtener datos: $e');
      _showSnackBar('Error al obtener datos de ofertas.', AppThemes.errorColor);
      setState(() => _isLoading = false);
    }
  }

  /// Mostrar mensaje al usuario
  void _showSnackBar(String message, Color backgroundColor) {
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
  final details = _offerDetails.where((d) => d.idOferta == offer.id).toList();

  // Buscar la producción asociada
  final produccion = _producciones.firstWhere(
    (p) => p.id == offer.idProduccion,
    orElse: () => Produccion(
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
    ),
  );

  // Determinar color de estado
  Color statusColor = offer.estado.toLowerCase() == 'activo'
      ? AppThemes.primaryColor
      : AppThemes.errorColor;

  // Construcción de los detalles en texto para el subtítulo
  String detailsText = details.isNotEmpty
      ? details.map((detail) {
          final unidadMedida = _unidadesMedida.firstWhere(
            (u) => u.id == detail.idUnidadMedida,
            orElse: () => UnidadMedida(id: 0, nombre: 'Desconocida'),
          );

          final moneda = _monedas.firstWhere(
            (m) => m.id == detail.idMoneda,
            orElse: () => Moneda(id: 0, nombre: 'Desconocida'),
          );

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

  return CustomCard(
    title: 'Oferta: ${produccion.descripcion}',
    subtitle:
        'Estado: ${offer.estado}\nCreado: ${_formatter.format(offer.fechaCreacion)}\nExpira: ${_formatter.format(offer.fechaExpiracion)}\n\nDetalles:\n$detailsText',
    icon: Icons.local_offer_outlined,
    status: offer.estado,
    statusColor: statusColor,
    onTap: () {
      if (details.isNotEmpty) {
        _editOferta(offer, details.first);
      }
    },
  );
}


  /// Lista de ofertas
Widget _buildOffersList() {
  if (_offers.isEmpty) {
    return Center(
      child: Text(
        'No hay ofertas disponibles.',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  return ListView.builder(
    padding: EdgeInsets.symmetric(vertical: 16.h),
    itemCount: _offers.length,
    itemBuilder: (context, index) {
      return _buildCombinedOfferCard(_offers[index]);
    },
  );
}


  /// Botón flotante para agregar oferta
  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: AppThemes.primaryColor,
      child: const Icon(Icons.add, color: AppThemes.secondaryColor),
      onPressed: _showAddOfertaDialog,
    );
  }

  /// Mostrar diálogo para agregar oferta
void _showAddOfertaDialog() {
  if (_producciones.isEmpty || _unidadesMedida.isEmpty || _monedas.isEmpty) {
    _showSnackBar('Datos incompletos. No se puede crear una oferta.', AppThemes.errorColor);
    return;
  }

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: AppThemes.borderColor, width: 2.0),
      ),
      backgroundColor: AppThemes.surfaceColor,
      child: AddOfertaForm(
        agricultorId: widget.agricultorId,
        producciones: _producciones,
        unidadesMedida: _unidadesMedida,
        monedas: _monedas,
        onOfertaCreated: (newOferta) {
          setState(() => _offers.add(newOferta));
        },
      ),
    ),
  );
}

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      backgroundColor: AppThemes.backgroundColor,
      appBar: AppBar(
        title: const Text('Ofertas'),
        centerTitle: true,
        backgroundColor: AppThemes.primaryColor,
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _buildOffersList(),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
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
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _apiService.deleteOferta(offer.id);
        setState(() {
          _offers.remove(offer);
        });
        _showSnackBar('Oferta eliminada exitosamente.', AppThemes.primaryColor);
      } catch (e) {
        _showSnackBar('Error al eliminar la oferta.', AppThemes.errorColor);
      }
    }
  }

  /// Editar oferta
/// Editar oferta
void _editOferta(Oferta offer, OfertaDetalle detail) {
  if (_producciones.isEmpty || _unidadesMedida.isEmpty || _monedas.isEmpty) {
    _showSnackBar('Datos incompletos. No se puede editar la oferta.', AppThemes.errorColor);
    return;
  }

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: AddOfertaForm(
        agricultorId: widget.agricultorId,
        producciones: _producciones, // Pasar las producciones
        unidadesMedida: _unidadesMedida, // Pasar las unidades de medida
        monedas: _monedas, // Pasar las monedas
        ofertaToEdit: offer,
        detalleToEdit: detail,
        onOfertaUpdated: (updatedOferta) {
          setState(() {
            final index = _offers.indexWhere((o) => o.id == updatedOferta.id);
            if (index != -1) {
              _offers[index] = updatedOferta;
            }
          });
          Navigator.pop(dialogContext);
        },
      ),
    ),
  );
}

}
