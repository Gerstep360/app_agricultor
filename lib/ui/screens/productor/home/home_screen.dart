// lib/ui/screens/productor/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:agromarket_app/ui/screens/productor/oferta/oferta_screen.dart';
import 'package:agromarket_app/ui/screens/productor/produccion/produccion_screen.dart';
import 'package:agromarket_app/ui/Themes/theme.dart';
import 'package:agromarket_app/ui/screens/productor/terreno/terreno_screen.dart';
import 'package:agromarket_app/ui/screens/productor/Carga_oferta/Carga_oferta.dart';
import 'package:agromarket_app/ui/screens/productor/home/view_models/home_view_model.dart';

class HomeScreen extends StatelessWidget {
  final int agricultorId;

  const HomeScreen({super.key, required this.agricultorId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(agricultorId: agricultorId),
      child: const HomeScreenContent(),
    );
  }
}

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({Key? key}) : super(key: key);

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildOptionCard(BuildContext context, String title, IconData icon,
      String description, VoidCallback onTap) {
    return FadeTransition(
      opacity: _fadeInAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: CustomCard(
          title: title,
          subtitle: description,
          icon: icon,
          status:null, // Puedes personalizar el estado según tu lógica
          statusColor: null, // Color de estado
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return ScaleTransition(
      scale: _fadeInAnimation,
      child: Container(
        width: 80.w,
        height: 80.w,
        decoration: BoxDecoration(
          color: AppThemes.accentColor, // Fondo rosa claro
          shape: BoxShape.circle,
          border: Border.all(color: AppThemes.borderColor, width: 4.0),
          boxShadow: [
            BoxShadow(
              color: AppThemes.primaryColor.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(
          Icons.eco,
          color: AppThemes.primaryColor, // Hoja en verde oscuro
          size: 50.w,
          shadows: [
            Shadow(
              color: AppThemes.borderColor,
              offset: Offset(1.0, 1.0),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    final viewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      backgroundColor: AppThemes.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.logout,
            color: AppThemes.accentColor,
            size: 28.0,
          ),
          onPressed: viewModel.isLoading
              ? null
              : () {
                  viewModel.logout(context);
                },
        ),
        title: Text(
          "AgroMarket",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppThemes.accentColor,
                shadows: [
                  Shadow(
                    color: AppThemes.borderColor,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
        ),
        centerTitle: true,
        backgroundColor: AppThemes.primaryColor,
        elevation: 10.0,
        shadowColor: AppThemes.primaryColor.withOpacity(0.5),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 120.h), // Espacio reservado para el logo
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Column(
                children: [
                  _buildOptionCard(
                    context,
                    "Terrenos",
                    Icons.terrain_outlined,
                    "Administra tus terrenos de cultivo con facilidad y eficiencia.",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TerrenoScreen(
                            agricultorId: viewModel.agricultorId,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildOptionCard(
                    context,
                    "Producciones",
                    Icons.agriculture,
                    "Revisa y gestiona tus producciones con herramientas avanzadas.",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProduccionScreen(
                            agricultorId: viewModel.agricultorId,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildOptionCard(
                    context,
                    "Ofertas",
                    Icons.local_offer,
                    "Consulta y crea ofertas para mejorar tus ventas.",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OfertaScreen(
                            agricultorId: viewModel.agricultorId,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildOptionCard(
                    context,
                    "Carga de Ofertas",
                    Icons.auto_graph,
                    "Sube nuevas ofertas y optimiza tus ingresos.",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CargaOfertaScreen(
                            agricultorId: viewModel.agricultorId,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 20.h,
            left: 0,
            right: 0,
            child: Center(
              child: _buildLogo(),
            ),
          ),
          if (viewModel.isLoading)
            Center(
              child: CircularProgressIndicator(
                color: AppThemes.accentColor,
              ),
            ),
          if (viewModel.errorMessage.isNotEmpty)
            Positioned(
              bottom: 20.h,
              left: 16.w,
              right: 16.w,
              child: SnackBar(
                content: Text(
                  viewModel.errorMessage,
                  style: TextStyle(color: AppThemes.backgroundColor),
                ),
                backgroundColor: AppThemes.errorColor,
              ),
            ),
        ],
      ),
    );
  }
}
