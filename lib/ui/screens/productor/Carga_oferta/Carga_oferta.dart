// lib/ui/screens/productor/carga_oferta/carga_oferta_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:agromarket_app/models/Agricultor/carga_oferta.dart';
import 'package:agromarket_app/ui/Themes/theme.dart';
import 'package:agromarket_app/ui/screens/productor/carga_oferta/view_models/carga_oferta_view_model.dart';

class CargaOfertaScreen extends StatelessWidget {
  final int agricultorId;

  const CargaOfertaScreen({Key? key, required this.agricultorId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CargaOfertaViewModel(agricultorId: agricultorId),
      child: const CargaOfertaScreenContent(),
    );
  }
}

class CargaOfertaScreenContent extends StatefulWidget {
  const CargaOfertaScreenContent({Key? key}) : super(key: key);

  @override
  State<CargaOfertaScreenContent> createState() =>
      _CargaOfertaScreenContentState();
}

class _CargaOfertaScreenContentState extends State<CargaOfertaScreenContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showAddCargaOfertaDialog(
      BuildContext context, CargaOfertaViewModel viewModel,
      {CargaOferta? cargaToEdit}) {
    final TextEditingController idOfertaDetalleController =
        TextEditingController(text: cargaToEdit?.idOfertaDetalle.toString());
    final TextEditingController pesoKgController =
        TextEditingController(text: cargaToEdit?.pesoKg.toString());
    final TextEditingController precioController =
        TextEditingController(text: cargaToEdit?.precio.toString());
    String estado = cargaToEdit?.estado ?? 'pendiente'; // Valor por defecto

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: const BorderSide(color: AppThemes.borderColor, width: 2.0),
        ),
        backgroundColor: AppThemes.surfaceColor,
        title: Text(
          cargaToEdit == null ? "Agregar Carga" : "Editar Carga",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppThemes.accentColor,
              ),
        ),
        content: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  controller: idOfertaDetalleController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: "ID Oferta Detalle"),
                  style: TextStyle(color: AppThemes.textColor),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el ID de la oferta detalle.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: pesoKgController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Peso (kg)"),
                  style: TextStyle(color: AppThemes.textColor),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el peso.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: precioController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Precio"),
                  style: TextStyle(color: AppThemes.textColor),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el precio.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.h),
                DropdownButtonFormField<String>(
                  value: estado,
                  decoration: const InputDecoration(labelText: "Estado"),
                  items: <String>['pendiente', 'asignado', 'finalizado']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value[0].toUpperCase() + value.substring(1),
                        style: TextStyle(color: AppThemes.textColor),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      estado = newValue;
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancelar",
              style: TextStyle(color: AppThemes.accentColor),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (idOfertaDetalleController.text.isNotEmpty &&
                  pesoKgController.text.isNotEmpty &&
                  precioController.text.isNotEmpty) {
                final cargaData = {
                  'id_agricultor': viewModel.agricultorId,
                  'id_oferta_detalle':
                      int.tryParse(idOfertaDetalleController.text) ?? 0,
                  'pesokg': double.tryParse(pesoKgController.text) ?? 0.0,
                  'precio': double.tryParse(precioController.text) ?? 0.0,
                  'estado': estado,
                };
                try {

                  if (!mounted) return;
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text("Por favor, complete todos los campos antes de guardar")),
                );
              }
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  Widget _buildCargaOfertaCard(CargaOferta carga, BuildContext context) {
    // Determinar el color del estado según 'estado'
    Color statusColor;
    switch (carga.estado.toLowerCase()) {
      case 'finalizado':
        statusColor = AppThemes.successColor; // Verde para finalizado
        break;
      case 'pendiente':
        statusColor = AppThemes.accentColor; // Rosa claro para pendiente
        break;
      case 'asignado':
        statusColor = AppThemes.warningColor; // Ámbar para asignado
        break;
      default:
        statusColor = Colors.grey;
    }

    return FadeTransition(
      opacity: _fadeInAnimation,
      child: SlideTransition(
        position: _fadeInAnimation.drive(Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            )),
        child: GestureDetector(
          onTap: () {
            final viewModel =
                Provider.of<CargaOfertaViewModel>(context, listen: false);
            _showAddCargaOfertaDialog(context, viewModel, cargaToEdit: carga);
          },
          child: CustomCard(
            title: 'Carga ID: ${carga.id}',
            subtitle:
                'Oferta Detalle ID: ${carga.idOfertaDetalle}\n'
                'Peso: ${carga.pesoKg} kg\n'
                'Precio: \$${carga.precio.toStringAsFixed(2)}',
            icon: Icons.local_shipping, // Ícono representativo
            status: carga.estado,
            statusColor: statusColor,
            onTap: () {
              final viewModel =
                  Provider.of<CargaOfertaViewModel>(context, listen: false);
              _showAddCargaOfertaDialog(context, viewModel, cargaToEdit: carga);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCargasList(CargaOfertaViewModel viewModel) {
    if (viewModel.cargas.isEmpty) {
      return Center(
        child: Text(
          'No hay cargas disponibles.',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppThemes.outsideTextColor,
              ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      itemCount: viewModel.cargas.length,
      itemBuilder: (context, index) {
        return _buildCargaOfertaCard(viewModel.cargas[index], context);
      },
    );
  }

  Widget _buildFloatingActionButton(CargaOfertaViewModel viewModel) {
    return FloatingActionButton(
      backgroundColor: AppThemes.primaryColor,
      child: const Icon(Icons.add, color: AppThemes.secondaryColor),
      onPressed: () => _showAddCargaOfertaDialog(context, viewModel),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CargaOfertaViewModel>(context);

    return Scaffold(
      backgroundColor: AppThemes.backgroundColor,
      appBar: AppBar(
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
      ),
      body: SafeArea(
        child: viewModel.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: AppThemes.primaryColor,
                ),
              )
            : _buildCargasList(viewModel),
      ),
      floatingActionButton: _buildFloatingActionButton(viewModel),
    );
  }
}
