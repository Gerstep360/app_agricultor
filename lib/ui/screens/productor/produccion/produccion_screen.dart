import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:agromarket_app/models/Agricultor/produccion.dart';
import 'package:agromarket_app/models/Agricultor/terreno.dart';
import 'package:agromarket_app/models/Agricultor/unidad_medida.dart';
import 'package:agromarket_app/models/Agricultor/producto.dart';
import 'package:agromarket_app/models/Agricultor/temporada.dart';
import 'package:agromarket_app/services/api_service.dart';
import 'package:agromarket_app/ui/Themes/theme.dart';
import 'package:agromarket_app/ui/screens/productor/produccion/agregar_produccion.dart';

class ProduccionScreen extends StatefulWidget {
  final int agricultorId;

  const ProduccionScreen({Key? key, required this.agricultorId}) : super(key: key);

  @override
  State<ProduccionScreen> createState() => _ProduccionScreenState();
}

class _ProduccionScreenState extends State<ProduccionScreen>
    with SingleTickerProviderStateMixin {
  late ApiService _apiService;
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  List<Produccion> _producciones = [];
  List<Terreno> _terrenos = [];
  List<UnidadMedida> _unidadesMedida = [];
  List<Producto> _productos = [];
  List<Temporada> _temporadas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _fetchAllData();

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

  Future<void> _fetchAllData() async {
    setState(() => _isLoading = true);

    try {
      final data = await Future.wait([
        _apiService.Unidad_medida_getUnidadMedidas(),
        _apiService.Agricultor_getProducciones(widget.agricultorId),
        _apiService.Producto_Producto_getProductos(),
        _apiService.Temporada_getTemporadas(),
        _apiService.getTerrenosByAgricultor(widget.agricultorId),
      ]);

      setState(() {
        _unidadesMedida = data[0] as List<UnidadMedida>;
        _producciones = data[1] as List<Produccion>;
        _productos = data[2] as List<Producto>;
        _temporadas = data[3] as List<Temporada>;
        _terrenos = data[4] as List<Terreno>;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error al obtener datos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener datos: $e')),
      );
    }
  }

  void _showAddProduccionDialog({Produccion? produccionToEdit}) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: const BorderSide(color: AppThemes.borderColor, width: 2.0),
        ),
        backgroundColor: AppThemes.surfaceColor,
        child: AddProduccionForm(
          unidadesMedida: _unidadesMedida,
          terrenos: _terrenos,
          productos: _productos,
          temporadas: _temporadas,
          produccionToEdit: produccionToEdit,
          onProduccionCreated: (produccion) {
            setState(() {
              _producciones.add(produccion);
            });
            Navigator.pop(context);
          },
          onProduccionUpdated: (updatedProduccion) {
            setState(() {
              int index = _producciones.indexWhere((p) => p.id == updatedProduccion.id);
              if (index != -1) {
                _producciones[index] = updatedProduccion;
              }
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

Future<void> _deleteProduccion(Produccion produccion) async {
  debugPrint('Entrando al método _deleteProduccion');

  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) {
      debugPrint('Mostrando el diálogo de confirmación');
      return AlertDialog(
        title: const Text('Eliminar Producción'),
        content: const Text(
            '¿Está seguro de que desea eliminar esta producción?'),
        actions: [
          TextButton(
            onPressed: () {
              debugPrint('Cancelar presionado');
              Navigator.of(context).pop(false); // Devuelve false
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              debugPrint('Eliminar presionado');
              Navigator.of(context).pop(true); // Devuelve true
            },
            child: const Text('Eliminar'),
          ),
        ],
      );
    },
  );

  debugPrint('Resultado del diálogo: $confirm');

  if (confirm == true) {
    try {
      debugPrint('Eliminando producción con ID: ${produccion.id}');
      await _apiService.Produccion_deleteProduccion(produccion.id);
      setState(() {
        _producciones.remove(produccion); // Eliminar localmente
      });
      debugPrint('Producción eliminada exitosamente');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producción eliminada exitosamente')),
      );
    } catch (e) {
      debugPrint('Error al eliminar producción: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar producción: $e')),
      );
    }
  } else {
    debugPrint('Eliminación cancelada');
  }
}



  Widget _buildProduccionCard(Produccion produccion) {
  final unidadMedida = _unidadesMedida.firstWhere(
    (unidad) => unidad.id == produccion.idUnidadMedida,
    orElse: () => UnidadMedida(id: 0, nombre: 'Desconocido'),
  );

  final producto = _productos.firstWhere(
    (p) => p.id == produccion.id_producto,
    orElse: () => Producto(id: 0, idCategoria: 0, nombre: 'Desconocido'),
  );

  final terreno = _terrenos.firstWhere(
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

  final temporada = _temporadas.firstWhere(
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
      ? AppThemes.primaryColor
      : AppThemes.errorColor;

  return FadeTransition(
    opacity: _fadeInAnimation,
      child: GestureDetector(
    onTap: () {
      _showAddProduccionDialog(produccionToEdit: produccion);
    },
    onLongPress: () {
      // Aquí se llama a _deleteProduccion
      _deleteProduccion(produccion);
    },
    child: CustomCard(
      title: producto.nombre, // Nombre del producto como título
      subtitle: 'Descripción: ${produccion.descripcion}\n'
          'Terreno: ${terreno.descripcion}\n'
          'Temporada: ${temporada.nombre}\n'
          'Cantidad: ${produccion.cantidad} ${unidadMedida.nombre}\n'
          'Fecha de Cosecha: ${produccion.fechaCosecha.toLocal().toIso8601String().split("T")[0]}\n'
          'Fecha de Expiración: ${produccion.fechaExpiracion.toLocal().toIso8601String().split("T")[0]}\n'
          'Estado: ${produccion.estado}', // Información detallada
      icon: Icons.grass, // Ícono representativo
      status: produccion.estado,
      statusColor: statusColor,    
    ),
    ),
  );
}


  Widget _buildProduccionesList() {
    if (_producciones.isEmpty) {
      return Center(
        child: Text(
          'No hay producciones disponibles.',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      itemCount: _producciones.length,
      itemBuilder: (context, index) {
        return _buildProduccionCard(_producciones[index]);
      },
    );
  }

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      backgroundColor: AppThemes.backgroundColor,
      appBar: AppBar(
        title: const Text("Producciones"),
        centerTitle: true,
        backgroundColor: AppThemes.primaryColor,
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _buildProduccionesList(),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }
}
