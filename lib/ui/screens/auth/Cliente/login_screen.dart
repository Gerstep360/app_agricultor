// lib/ui/screens/auth/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:agromarket_app/services/api_service.dart';
import 'package:agromarket_app/ui/screens/auth/Cliente/register_screen.dart';
import 'package:agromarket_app/ui/screens/Cliente/home/client_home_screen.dart';
import 'package:agromarket_app/ui/Themes/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agromarket_app/services/Agricultor/notificaciones.dart';

class LoginScreen_Cliente extends StatefulWidget {
  const LoginScreen_Cliente({super.key});

  @override
  State<LoginScreen_Cliente> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen_Cliente>
    with SingleTickerProviderStateMixin {
  final ApiService apiService = ApiService();
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  String? _selectedClienteId;
  List<Map<String, dynamic>> _clientes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchClientes();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeInAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  Future<void> _fetchClientes() async {
    try {
      final response = await apiService.Cliente_getClientes();
      if (!mounted) return; // Verificar si el widget sigue montado
      setState(() {
        _clientes = response
            .map((cliente) => {
                  'id': cliente.id,
                  'nombre': '${cliente.nombre} ${cliente.apellido}',
                })
            .toList();
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return; // Verificar si el widget sigue montado
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener los Clientes: $error')),
      );
    }
  }

  Future<void> _login() async {
    if (_selectedClienteId != null) {
      final clienteId = int.parse(_selectedClienteId!);

      // Obtener el token FCM
      final tokenFCM = await NotificacionesService().obtenerTokenFCM();

      // Llamada a la API para actualizar el token en el servidor
      try {
        final response = await apiService.put(
          '/clientes/$clienteId', // Endpoint de actualización
          {
            'tokendevice': tokenFCM, // Actualizar el token
          },
        );

        print("Token actualizado en el servidor: $tokenFCM");

        // Guardar el clienteIId en SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('clienteId', clienteId);

        // Detener la animación antes de navegar
        _animationController.stop();

        // Navegar a la pantalla principal y pasar el clienteId
        if (!mounted) return; // Verificar si el widget sigue montado
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ClientHomeScreen(clienteId: clienteId),
          ),
        );
      } catch (error) {
        print("Error actualizando el token: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al iniciar sesión: $error')),
        );
      }
    } else {
      if (!mounted) return; // Verificar si el widget sigue montado
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleccione un Cliente')),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildDropdown() {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(color: AppThemes.primaryColor))
        : FadeTransition(
            opacity: _fadeInAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: DropdownButtonFormField<String>(
                value: _selectedClienteId,
                items: _clientes.map((cliente) {
                  return DropdownMenuItem<String>(
                    value: cliente['id'].toString(),
                    child: Text(
                      cliente['nombre'],
                      style: TextStyle(color: AppThemes.textColor),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedClienteId = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Seleccione un Cliente',
                  prefixIcon: Icon(Icons.person, color: AppThemes.primaryColor),
                ),
                dropdownColor: AppThemes.surfaceColor,
                isExpanded: true,
                icon:
                    Icon(Icons.arrow_drop_down, color: AppThemes.primaryColor),
              ),
            ),
          );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _login,
      child: const Text('Iniciar Sesión'),
    );
  }

  Widget _buildRegisterOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿No tienes una cuenta?',
          style: TextStyle(color: AppThemes.hintColor, fontSize: 14.sp),
        ),
        TextButton(
          onPressed: () {
            if (!mounted) return; // Verificar si el widget sigue montado
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegisterScreen()),
            );
          },
          child: Text(
            'Regístrate',
            style: TextStyle(
              color: AppThemes.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: 120.w,
        height: 120.w,
        decoration: BoxDecoration(
          color: AppThemes.surfaceColor,
          shape: BoxShape.circle,
          border: Border.all(color: AppThemes.borderColor, width: 4.0),
        ),
        child: Icon(
          Icons.eco,
          color: AppThemes.primaryColor,
          size: 60.w,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Bienvenido a AgroLink Clientes',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppThemes.textColor,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context); // Inicializa ScreenUtil
    return Scaffold(
      backgroundColor: AppThemes.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: FadeTransition(
                opacity: _fadeInAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLogo(),
                    SizedBox(height: 30.h),
                    _buildTitle(),
                    SizedBox(height: 40.h),
                    _buildDropdown(),
                    SizedBox(height: 30.h),
                    _buildLoginButton(),
                    SizedBox(height: 20.h),
                    _buildRegisterOption(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
