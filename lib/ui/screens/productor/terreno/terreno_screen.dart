// lib/ui/screens/productor/terreno/terreno_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:agromarket_app/models/Agricultor/terreno.dart';
import 'package:agromarket_app/services/api_service.dart';
import 'package:agromarket_app/ui/Themes/theme.dart';
import 'package:agromarket_app/ui/screens/maps/map.dart';

class TerrenoScreen extends StatefulWidget {
  final int agricultorId;

  const TerrenoScreen({super.key, required this.agricultorId});

  @override
  State<TerrenoScreen> createState() => _TerrenoScreenState();
}

class _TerrenoScreenState extends State<TerrenoScreen>
    with SingleTickerProviderStateMixin {
  late ApiService _apiService;
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;

  List<Terreno> _terrenos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();

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
    _fetchTerrenos();
  }

 Future<void> _fetchTerrenos() async {
  try {
    final terrenos = await _apiService.Agricultor_getTerrenos(widget.agricultorId);
    if (!mounted) return;
    setState(() {
      _terrenos = terrenos;
      _isLoading = false;
    });
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al obtener terrenos: $e')),
    );
    setState(() {
      _isLoading = false;
    });
  }
}


  void _showAddTerrenoDialog({Terreno? terrenoToEdit}) {
    final TextEditingController descripcionController = TextEditingController();
    final TextEditingController areaController = TextEditingController();
    final TextEditingController superficieTotalController =
        TextEditingController();
    latlng.LatLng? location;

    if (terrenoToEdit != null) {
      descripcionController.text = terrenoToEdit.descripcion;
      areaController.text = terrenoToEdit.area.toString();
      superficieTotalController.text = terrenoToEdit.superficieTotal.toString();
      location = latlng.LatLng(
        terrenoToEdit.ubicacionLatitud,
        terrenoToEdit.ubicacionLongitud,
      );
    }

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
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            content: SingleChildScrollView(
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: descripcionController,
                      decoration:
                          const InputDecoration(labelText: "Descripción"),
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
                          ),
                          Text(
                            location == null
                                ? 'Longitud: ---'
                                : 'Longitud: ${location?.longitude.toStringAsFixed(6)}',
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.map),
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
                child: const Text("Cancelar"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (location != null) {
                    final terrenoData = {
                      'id_agricultor': widget.agricultorId,
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
                        // Create new terreno
                        final terreno = await _apiService
                            .Terreno_createTerreno(terrenoData);
                        setState(() {
                          _terrenos.add(terreno);
                        });
                      } else {
                        // Update existing terreno
                        final terreno = await _apiService.Terreno_updateTerreno(
                            terrenoToEdit.id, terrenoData);
                        setState(() {
                          int index = _terrenos
                              .indexWhere((t) => t.id == terrenoToEdit.id);
                          if (index != -1) {
                            _terrenos[index] = terreno;
                          }
                        });
                      }
                      if (!mounted) return;
                      Navigator.pop(context);
                    } catch (e) {
                      if (!mounted) return;
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

  Future<void> _deleteTerreno(Terreno terreno) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Terreno'),
        content: const Text('¿Está seguro de que desea eliminar este terreno?'),
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
        await _apiService.Terreno_deleteTerreno(terreno.id);
        setState(() {
          _terrenos.remove(terreno);
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terreno eliminado exitosamente')),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar terreno: $e')),
        );
      }
    }
  }

  Widget _buildTerrenoCard(Terreno terreno) {
    return FadeTransition(
      opacity: _fadeInAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: GestureDetector(
          onTap: () {
            _showAddTerrenoDialog(terrenoToEdit: terreno);
          },
          onLongPress: () {
            _deleteTerreno(terreno);
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppThemes.surfaceColor,
              borderRadius: BorderRadius.circular(18.0),
              border: Border.all(color: AppThemes.borderColor, width: 2.0), // Fixed line
              boxShadow: [
                BoxShadow(
                  color: AppThemes.borderColor.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  terreno.descripcion,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppThemes.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Área: ${terreno.area.toStringAsFixed(2)} m²',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppThemes.hintColor,
                      ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Superficie Total: ${terreno.superficieTotal.toStringAsFixed(2)} m²',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppThemes.hintColor,
                      ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Ubicación:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppThemes.hintColor,
                      ),
                ),
                Text(
                  'Latitud: ${terreno.ubicacionLatitud.toStringAsFixed(6)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppThemes.textColor,
                      ),
                ),
                Text(
                  'Longitud: ${terreno.ubicacionLongitud.toStringAsFixed(6)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppThemes.textColor,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        color: AppThemes.primaryColor,
      ),
    );
  }

  Widget _buildTerrenosList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      itemCount: _terrenos.length,
      itemBuilder: (context, index) {
        return _buildTerrenoCard(_terrenos[index]);
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: AppThemes.primaryColor,
      child: const Icon(Icons.add, color: AppThemes.secondaryColor),
      onPressed: () => _showAddTerrenoDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        child: _isLoading ? _buildLoadingIndicator() : _buildTerrenosList(),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }
}
