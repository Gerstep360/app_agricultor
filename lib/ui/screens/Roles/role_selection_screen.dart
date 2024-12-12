// lib/ui/screens/role_selection_screen.dart

import 'package:flutter/material.dart';
import 'package:agromarket_app/ui/Themes/theme.dart';
import 'package:animations/animations.dart';
import 'package:agromarket_app/ui/screens/auth/Agricultor/login_screen.dart';
import 'package:agromarket_app/ui/screens/auth/cliente/login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtener el tamaño de la pantalla para ajustes responsivos
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona tu Rol'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0), // Tamaño fijo de padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Título
            Text(
              '¿Eres un Agricultor o un Cliente?',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 24.0, // Tamaño de fuente fijo
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.0), // Espacio fijo
            // Lista de tarjetas con animaciones
            Expanded(
              child: ListView(
                children: [
                  // Tarjeta para Agricultor
                  OpenContainer(
                    transitionType: ContainerTransitionType.fade,
                    openBuilder: (context, _) => LoginScreen(),
                    closedBuilder: (context, openContainer) => CustomCard(
                      title: 'Agricultor',
                      subtitle: 'Gestiona tus cultivos y ventas',
                      icon: Icons.agriculture_outlined, // Icono válido
                      onTap: openContainer,
                    ),
                    closedElevation: 0,
                    closedColor: Colors.transparent,
                  ),
                  SizedBox(height: 16.0), // Espacio fijo
                  // Tarjeta para Cliente
                  OpenContainer(
                    transitionType: ContainerTransitionType.fade,
                    openBuilder: (context, _) => LoginScreen_Cliente(),
                    closedBuilder: (context, openContainer) => CustomCard(
                      title: 'Cliente',
                      subtitle: 'Compra productos frescos directamente',
                      icon: Icons.shopping_cart_outlined, // Icono válido
                      onTap: openContainer,
                    ),
                    closedElevation: 0,
                    closedColor: Colors.transparent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
