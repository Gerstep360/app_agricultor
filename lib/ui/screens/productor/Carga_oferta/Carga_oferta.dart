// lib/ui/screens/productor/carga_oferta/carga_oferta_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:agromarket_app/models/Agricultor/carga_oferta.dart';
import 'package:agromarket_app/models/Agricultor/terreno.dart';
import 'package:agromarket_app/models/Agricultor/produccion.dart';
import 'package:agromarket_app/models/Agricultor/oferta.dart';
import 'package:agromarket_app/models/Agricultor/oferta_detalle.dart';
import 'package:agromarket_app/services/api_service.dart';
import 'package:agromarket_app/ui/Themes/theme.dart';

class CargaOfertaScreen extends StatefulWidget {
  final int agricultorId;

  const CargaOfertaScreen({Key? key, required this.agricultorId})
      : super(key: key);

  @override
  State<CargaOfertaScreen> createState() => _CargaOfertaScreenState();
}

class _CargaOfertaScreenState extends State<CargaOfertaScreen>
    with TickerProviderStateMixin {
  late ApiService _apiService;
  List<CargaOferta> _cargas = [];
  bool _isLoading = true;

  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _fetchCargasDelAgricultor();
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

  Future<void> _fetchCargasDelAgricultor() async {
    try {
      setState(() => _isLoading = true);
      final cargas =
          await _apiService.Agricultor_getCargasofertas(widget.agricultorId);
      setState(() {
        _cargas = cargas;
        _isLoading = false;
      });
    } catch (e) {
      _showSnackBar('Error al obtener cargas: $e', AppThemes.errorColor);
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  Widget _buildCargaCard(CargaOferta carga) {
    // Determinar el color del estado según 'estado'
    Color statusColor;
    switch (carga.estado.toLowerCase()) {
      case 'finalizado':
        statusColor = AppThemes.primaryColor; // Color primario o verde
        break;
      case 'pendiente':
        statusColor = AppThemes.accentColor;
        break;
      case 'asignado':
        statusColor = AppThemes.backgroundColor;
        break;
      default:
        statusColor = Colors.grey;
    }

    return FadeTransition(
      opacity: _fadeInAnimation,
      child: GestureDetector(
        onLongPress: () {
          // Opcional: agregar acciones
        },
        child: CustomCard(
          title: 'Carga ID: ${carga.id}',
          subtitle: 'Oferta Detalle ID: ${carga.idOfertaDetalle}\n'
              'Peso: ${carga.pesoKg} kg\n'
              'Precio: ${carga.precio}',
          icon: Icons.local_shipping,
          status: carga.estado,
          statusColor: statusColor, // Pasar el color del estado
        ),
      ),
    );
  }

  Widget _buildCargasList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      itemCount: _cargas.length,
      itemBuilder: (context, index) {
        return _buildCargaCard(_cargas[index]);
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        color: AppThemes.primaryColor,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Cargas de Oferta'),
      centerTitle: true,
      backgroundColor: AppThemes.primaryColor,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppThemes.secondaryColor,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
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
      appBar: _buildAppBar(),
      body: SafeArea(
        child: _isLoading ? _buildLoadingIndicator() : _buildCargasList(),
      ),
    );
  }
}
