// lib/ui/screens/auth/register_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:agromarket_app/services/api_service.dart';
import 'package:agromarket_app/ui/Themes/theme.dart';
import 'package:agromarket_app/services/Agricultor/notificaciones.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController(); // Contraseña
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _nitController = TextEditingController();
  final TextEditingController _carnetController = TextEditingController();
  final TextEditingController _licenciaFuncionamientoController = TextEditingController();
  final TextEditingController _informacionBancariaController = TextEditingController();
  final ApiService apiService = ApiService();
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;

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

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose(); // Contraseña
    _nombreController.dispose();
    _apellidoController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    _nitController.dispose();
    _carnetController.dispose();
      _licenciaFuncionamientoController.dispose(); // Disponer nuevo controlador
  _informacionBancariaController.dispose(); // Disponer nuevo controlador
    _animationController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        final String? tokenFCM = await NotificacionesService().obtenerTokenFCM();

        final newAgricultor = {
          'nombre': _nombreController.text,
          'apellido': _apellidoController.text,
          'telefono': _telefonoController.text,
          'email': _emailController.text, // Primero correo
          'direccion': _direccionController.text,
          'password': _passwordController.text, // Luego contraseña
          'informacion_bancaria': _informacionBancariaController.text,
          'nit': _nitController.text,
          'carnet': _carnetController.text,
          'licencia_funcionamiento':_licenciaFuncionamientoController.text,
          'estado': 'activo',
          'tokendevice': tokenFCM ?? null
        };

        await apiService.Agricultor_createAgricultor(newAgricultor);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro exitoso')),
        );

        Navigator.pop(context);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required TextInputType type,
    bool isObscure = false,
    String? Function(String?)? validator,
  }) {
    return FadeTransition(
      opacity: _fadeInAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: TextFormField(
          controller: controller,
          keyboardType: type,
          obscureText: isObscure,
          decoration: InputDecoration(
            labelText: labelText,
            prefixIcon: Icon(
              Icons.edit,
              color: AppThemes.primaryColor,
            ),
          ),
          validator: validator,
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: _register,
      child: Text('Registrarse'),
    );
  }

  Widget _buildLoginOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿Ya tienes una cuenta?',
          style: TextStyle(color: AppThemes.hintColor, fontSize: 14.sp),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Inicia sesión',
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
          Icons.person_add_alt_1,
          color: AppThemes.primaryColor,
          size: 60.w,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppThemes.primaryColor,
        elevation: 0,
        title: Text(
          'Regístrate',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppThemes.secondaryColor,
              ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: FadeTransition(
              opacity: _fadeInAnimation,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildLogo(),
                    SizedBox(height: 30.h),
                    // Primero correo
                    _buildTextField(
                      controller: _emailController,
                      labelText: 'Correo electrónico',
                      type: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese su correo electrónico';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12.h),
                    // Luego contraseña
                    _buildTextField(
                      controller: _passwordController,
                      labelText: 'Contraseña',
                      type: TextInputType.text,
                      isObscure: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese su contraseña';
                        }
                        if (value.length < 8) {
                          return 'La contraseña debe tener al menos 8 caracteres';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12.h),
                    _buildTextField(
                      controller: _nombreController,
                      labelText: 'Nombre',
                      type: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese su nombre';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12.h),
                    _buildTextField(
                      controller: _apellidoController,
                      labelText: 'Apellido',
                      type: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese su apellido';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12.h),
                    _buildTextField(
                      controller: _telefonoController,
                      labelText: 'Teléfono',
                      type: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese su teléfono';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12.h),
                    _buildTextField(
                      controller: _direccionController,
                      labelText: 'Dirección',
                      type: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese su dirección';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: 12.h),
                    _buildTextField(
  controller: _licenciaFuncionamientoController,
  labelText: 'Licencia de Funcionamiento',
  type: TextInputType.text,
  validator: (value) {
    // Licencia es opcional, así que no hay validación
    return null;
  },
),
SizedBox(height: 12.h),
_buildTextField(
  controller: _informacionBancariaController,
  labelText: 'Información Bancaria',
  type: TextInputType.text,
  validator: (value) {
    // Información bancaria es opcional, así que no hay validación
    return null;
  },
                    ),
                    SizedBox(height: 12.h),
                    _buildTextField(
                      controller: _nitController,
                      labelText: 'NIT',
                      type: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese su NIT';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12.h),
                    _buildTextField(
                      controller: _carnetController,
                      labelText: 'Carnet',
                      type: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese su carnet';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),
                    _buildRegisterButton(),
                    SizedBox(height: 20.h),
                    _buildLoginOption(),
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
