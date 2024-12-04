// lib/ui/screens/productor/terreno/terreno_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:provider/provider.dart';
import 'package:agromarket_app/models/Agricultor/terreno.dart';
import 'package:agromarket_app/ui/Themes/theme.dart';
import 'package:agromarket_app/ui/screens/maps/map.dart';
import 'package:agromarket_app/ui/screens/productor/terreno/view_models/terreno_view_model.dart';

class TerrenoScreen extends StatelessWidget {
  final int agricultorId;

  const TerrenoScreen({Key? key, required this.agricultorId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TerrenoViewModel(agricultorId: agricultorId),
      child: const TerrenoScreenContent(),
    );
  }
}

class TerrenoScreenContent extends StatefulWidget {
  const TerrenoScreenContent({Key? key}) : super(key: key);

  @override
  State<TerrenoScreenContent> createState() => _TerrenoScreenContentState();
}

class _TerrenoScreenContentState extends State<TerrenoScreenContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeInAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showAddTerrenoDialog(BuildContext context, TerrenoViewModel viewModel,
      {Terreno? terrenoToEdit}) {
    final TextEditingController descripcionController =
        TextEditingController(text: terrenoToEdit?.descripcion);
    final TextEditingController areaController =
        TextEditingController(text: terrenoToEdit?.area.toString());
    final TextEditingController superficieTotalController =
        TextEditingController(text: terrenoToEdit?.superficieTotal.toString());
    latlng.LatLng? location = terrenoToEdit != null
        ? latlng.LatLng(
            terrenoToEdit.ubicacionLatitud, terrenoToEdit.ubicacionLongitud)
        : null;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: const BorderSide(color: AppThemes.borderColor, width: 2.0),
            ),
            backgroundColor: AppThemes.surfaceColor,
            title: Text(
              terrenoToEdit == null ? "Agregar Terreno" : "Editar Terreno",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppThemes.accentColor,
                  ),
            ),
            content: SingleChildScrollView(
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: descripcionController,
                      decoration:
                          const InputDecoration(labelText: "Descripción"),
                      style: TextStyle(color: AppThemes.textColor),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese una descripción válida.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12.h),
                    TextFormField(
                      controller: areaController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Área (m²)"),
                      style: TextStyle(color: AppThemes.textColor),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese el área.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12.h),
                    TextFormField(
                      controller: superficieTotalController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: "Superficie Total (m²)"),
                      style: TextStyle(color: AppThemes.textColor),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese la superficie total.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12.h),
                    ListTile(
                      title: const Text("Seleccionar Ubicación"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            location == null
                                ? 'Latitud: ---'
                                : 'Latitud: ${location?.latitude.toStringAsFixed(6)}',
                            style: TextStyle(color: AppThemes.textColor),
                          ),
                          Text(
                            location == null
                                ? 'Longitud: ---'
                                : 'Longitud: ${location?.longitude.toStringAsFixed(6)}',
                            style: TextStyle(color: AppThemes.textColor),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.map, color: AppThemes.accentColor),
                      onTap: () async {
                        final selectedLocation = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapLocationPicker(
                              onLocationSelected: (latlng.LatLng loc) {
                                Navigator.pop(context, loc);
                              },
                            ),
                          ),
                        );
                        if (selectedLocation != null &&
                            selectedLocation is latlng.LatLng) {
                          setDialogState(() {
                            location = selectedLocation;
                          });
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
                  if (location != null) {
                    final terrenoData = {
                      'id_agricultor': viewModel.agricultorId,
                      'descripcion': descripcionController.text,
                      'area': double.tryParse(areaController.text) ?? 0.0,
                      'superficie_total':
                          double.tryParse(superficieTotalController.text) ??
                              0.0,
                      'ubicacion_latitud': location?.latitude,
                      'ubicacion_longitud': location?.longitude,
                    };
                    try {
                      if (terrenoToEdit == null) {
                        // Crear nuevo terreno
                        await viewModel.addTerreno(terrenoData);
                      } else {
                        // Actualizar terreno existente
                        await viewModel.updateTerreno(
                            terrenoToEdit.id, terrenoData);
                      }
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
                              Text("Selecciona una ubicación antes de guardar")),
                    );
                  }
                },
                child: const Text("Guardar"),
              ),
            ],
          );
        },
      ),
    );
  }

  void _deleteTerrenoDialog(
      BuildContext context, TerrenoViewModel viewModel, Terreno terreno) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Terreno'),
        content:
            const Text('¿Está seguro de que desea eliminar este terreno?'),
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
      await viewModel.deleteTerreno(terreno.id);
      if (viewModel.errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(viewModel.errorMessage)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terreno eliminado exitosamente')),
        );
      }
    }
  }

  Widget _buildTerrenoCard(Terreno terreno, BuildContext context) {
    return FadeTransition(
      opacity: _fadeInAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: GestureDetector(
          onTap: () {
            final viewModel =
                Provider.of<TerrenoViewModel>(context, listen: false);
            _showAddTerrenoDialog(context, viewModel, terrenoToEdit: terreno);
          },
          onLongPress: () {
            final viewModel =
                Provider.of<TerrenoViewModel>(context, listen: false);
            _deleteTerrenoDialog(context, viewModel, terreno);
          },
          child: CustomCard(
            title: terreno.descripcion,
            subtitle:
                'Área: ${terreno.area.toStringAsFixed(2)} m²\n'
                'Superficie Total: ${terreno.superficieTotal.toStringAsFixed(2)} m²\n'
                'Ubicación:\nLatitud: ${terreno.ubicacionLatitud.toStringAsFixed(6)}\n'
                'Longitud: ${terreno.ubicacionLongitud.toStringAsFixed(6)}',
            icon: Icons.terrain_outlined, // Ícono representativo
            // No se pasan status y statusColor ya que no son necesarios aquí
          ),
        ),
      ),
    );
  }

  Widget _buildTerrenosList(TerrenoViewModel viewModel) {
    if (viewModel.terrenos.isEmpty) {
      return Center(
        child: Text(
          'No hay terrenos disponibles.',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppThemes.outsideTextColor,
              ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      itemCount: viewModel.terrenos.length,
      itemBuilder: (context, index) {
        return _buildTerrenoCard(viewModel.terrenos[index], context);
      },
    );
  }

  Widget _buildFloatingActionButton(TerrenoViewModel viewModel) {
    return FloatingActionButton(
      backgroundColor: AppThemes.primaryColor,
      child: const Icon(Icons.add, color: AppThemes.secondaryColor),
      onPressed: () => _showAddTerrenoDialog(context, viewModel),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TerrenoViewModel>(context);

    return Scaffold(
      backgroundColor: AppThemes.backgroundColor,
      appBar: AppBar(
        title: const Text("Terrenos"),
        centerTitle: true,
        backgroundColor: AppThemes.primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppThemes.secondaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: viewModel.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: AppThemes.primaryColor,
                ),
              )
            : _buildTerrenosList(viewModel),
      ),
      floatingActionButton: _buildFloatingActionButton(viewModel),
    );
  }
}
