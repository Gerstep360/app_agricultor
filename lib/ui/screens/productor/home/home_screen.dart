// lib/ui/screens/productor/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:agromarket_app/ui/screens/auth/login_screen.dart';
import 'package:agromarket_app/ui/screens/productor/oferta/oferta_screen.dart';
import 'package:agromarket_app/ui/screens/productor/produccion/produccion_screen.dart';
import 'package:agromarket_app/ui/Themes/theme.dart';
import 'package:agromarket_app/ui/screens/productor/terreno/terreno_screen.dart';
import 'package:agromarket_app/ui/screens/productor/Carga_oferta/Carga_oferta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agromarket_app/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  final int agricultorId;

  const HomeScreen({super.key, required this.agricultorId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final agricultorId = prefs.getInt('agricultorId');

    if (agricultorId != null) {
      try {
        await ApiService().put(
          '/agricultors/$agricultorId',
          {'tokendevice': null},
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cerrar sesión: $e')),
        );
      }
    }
    await prefs.remove('agricultorId');
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

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

  Widget _buildOptionCard(BuildContext context, String title, IconData icon,
      String description, VoidCallback onTap) {
    return FadeTransition(
      opacity: _fadeInAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppThemes.surfaceColor,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: AppThemes.borderColor, width: 2.0),
              boxShadow: [
                BoxShadow(
                  color: AppThemes.primaryColor.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            padding: EdgeInsets.all(20.w),
            constraints: BoxConstraints(minHeight: 180.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: AppThemes.primaryColor,
                      size: 40.w,
                      shadows: [
                        Shadow(
                          color: AppThemes.borderColor,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppThemes.textColor,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: AppThemes.borderColor,
                                  offset: Offset(1.0, 1.0),
                                ),
                              ],
                            ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: AppThemes.hintColor),
                  ],
                ),
                SizedBox(height: 20.h),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppThemes.hintColor,
                        fontStyle: FontStyle.italic,
                        shadows: [
                          Shadow(
                            color: AppThemes.borderColor,
                            offset: Offset(1.0, 1.0),
                          ),
                        ],
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

  Widget _buildLogo() {
    return ScaleTransition(
      scale: _fadeInAnimation,
      child: Container(
        width: 80.w,
        height: 80.w,
        decoration: BoxDecoration(
          color: AppThemes.surfaceColor,
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
          color: AppThemes.primaryColor,
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

    return Scaffold(
      backgroundColor: AppThemes.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.logout,
            color: AppThemes.secondaryColor,
            size: 28.0,
          ),
          onPressed: _logout,
        ),
        title: Text(
          "AgroMarket",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppThemes.secondaryColor,
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
                            agricultorId: widget.agricultorId,
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
                            agricultorId: widget.agricultorId,
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
                            agricultorId: widget.agricultorId,
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
                            agricultorId: widget.agricultorId,
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
        ],
      ),
    );
  }
}
