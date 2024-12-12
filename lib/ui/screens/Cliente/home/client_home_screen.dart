// lib/ui/screens/cliente/home/client_home_screen.dart

import 'package:agromarket_app/models/Cliente/pedidos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agromarket_app/ui/themes/theme.dart';
import 'package:agromarket_app/services/api_service.dart';
import 'package:agromarket_app/ui/screens/Cliente/home/view_models/client_home_view_model.dart';
import 'package:agromarket_app/ui/screens/Cliente/purchase_history/purchase_history_screen.dart';
import 'package:agromarket_app/models/Cliente/pedidos.dart';
import 'package:agromarket_app/models/Agricultor/oferta_detalle.dart';

class ClientHomeScreen extends StatelessWidget {
  final int clienteId;

  const ClientHomeScreen({Key? key, required this.clienteId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ClientHomeViewModel(apiService: ApiService(), clienteId: clienteId),
      child: const ClientHomeContent(),
    );
  }
}

class ClientHomeContent extends StatefulWidget {
  const ClientHomeContent({Key? key}) : super(key: key);

  @override
  State<ClientHomeContent> createState() => _ClientHomeContentState();
}

class _ClientHomeContentState extends State<ClientHomeContent> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;
  late ClientHomeViewModel _viewModel;
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<ClientHomeViewModel>(context, listen: false);
    // _viewModel.fetchOfertasDetalle(); // Ya se llama en el ViewModel constructor

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

    // Listener para mostrar SnackBar cuando haya un mensaje de error
    _listener = () {
      if (_viewModel.errorMessagePedidos.isNotEmpty) {
        // Usar addPostFrameCallback para evitar modificar el estado durante la construcción
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _viewModel.errorMessagePedidos,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
          _viewModel.errorMessagePedidos = ''; // Reiniciar el mensaje de error después de mostrar
        });
      }

      if (_viewModel.errorMessageOfertas.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _viewModel.errorMessageOfertas,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
          _viewModel.errorMessageOfertas = ''; // Reiniciar el mensaje de error después de mostrar
        });
      }
    };

    _viewModel.addListener(_listener);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_listener);
    _animationController.dispose();
    super.dispose();
  }

  /// Widget para construir cada tarjeta de OfertaDetalle
  Widget _buildOfertaCard(BuildContext context, OfertaDetalle oferta) {
    return FadeTransition(
      opacity: _fadeInAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: GestureDetector(
          onTap: () {
            _showOfertaDetails(context, oferta);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: AppThemes.surfaceColor,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: AppThemes.borderColor,
                width: 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppThemes.primaryColor.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.local_offer,
                        color: AppThemes.accentColor,
                        size: 40.0,
                        shadows: [
                          Shadow(
                            color: AppThemes.borderColor,
                            offset: const Offset(1.0, 1.0),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          'Oferta #${oferta.id}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppThemes.textColor,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: AppThemes.borderColor,
                                    offset: const Offset(1.0, 1.0),
                                  ),
                                ],
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Cantidad: ${oferta.cantidadFisico}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppThemes.textColor,
                          shadows: [
                            Shadow(
                              color: AppThemes.borderColor,
                              offset: const Offset(1.0, 1.0),
                            ),
                          ],
                        ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Estado: ${oferta.estado}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppThemes.textColor,
                          shadows: [
                            Shadow(
                              color: AppThemes.borderColor,
                              offset: const Offset(1.0, 1.0),
                            ),
                          ],
                        ),
                  ),
                  // Añade más detalles de oferta si es necesario
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Mostrar detalles de una OfertaDetalle y permitir agregar al carrito
  void _showOfertaDetails(BuildContext context, OfertaDetalle oferta) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Oferta #${oferta.id}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Cantidad: ${oferta.cantidadFisico}'),
              Text('Estado: ${oferta.estado}'),
              // Añade más detalles según sea necesario
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cerrar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes implementar la lógica para agregar la oferta al carrito como un Pedido
                // Por ejemplo, podrías solicitar detalles adicionales al usuario o usar valores predeterminados
                final newPedido = Pedidos(
                  id: 0, // Asigna un ID temporal o lo manejará el backend
                  fecha_entrega: DateTime.now(), // Puedes solicitar esta fecha al usuario
                  ubicacion_latitud: 0.0, // Puedes solicitar esta información al usuario
                  ubicacion_longitud: 0.0, // Puedes solicitar esta información al usuario
                  estado: 'pendiente', // Estado inicial del pedido
                );
                _viewModel.addToCart(newPedido);
                Navigator.pop(context);
              },
              child: const Text('Agregar al Carrito'),
            ),
          ],
        );
      },
    );
  }

  /// Mostrar detalles de un Pedido en el historial
  void _showPedidoDetails(BuildContext context, Pedidos pedido) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pedido #${pedido.id}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Fecha de Entrega: ${pedido.fecha_entrega.toLocal().toString().split(' ')[0]}'),
              Text('Estado: ${pedido.estado}'),
              // Añade más detalles según sea necesario
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  /// Mostrar el diálogo del carrito
/// Mostrar el diálogo del carrito
void _showCartDialog(BuildContext context) {
  final viewModel = Provider.of<ClientHomeViewModel>(context, listen: false);
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Carrito de Compras'),
        content: viewModel.cartItems.isEmpty
            ? const Text('El carrito está vacío.')
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 200.0,
                    width: double.maxFinite,
                    child: ListView.builder(
                      itemCount: viewModel.cartItems.length,
                      itemBuilder: (context, index) {
                        final item = viewModel.cartItems[index];
                        return ListTile(
                          title: Text('Pedido #${item.id}'),
                          subtitle: Text('Fecha de Entrega: ${item.fecha_entrega.toLocal().toString().split(' ')[0]}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: AppThemes.errorColor),
                            onPressed: () {
                              viewModel.removeFromCart(item);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text('Total: \$${viewModel.totalPrice.toStringAsFixed(2)} ${viewModel.currency}'),
                ],
              ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () async {
              await viewModel.checkout(context);
              Navigator.pop(context);
            },
            child: const Text('Comprar'),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ClientHomeViewModel>(context);

    return Scaffold(
      backgroundColor: AppThemes.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.logout,
            color: AppThemes.accentColor,
            size: 28.0,
          ),
          onPressed: viewModel.isLoadingPedidos || viewModel.isLoadingOfertas
              ? null
              : () {
                  viewModel.logout(context);
                },
        ),
        title: Text(
          "AgroMarket Cliente",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppThemes.accentColor,
                shadows: [
                  Shadow(
                    color: AppThemes.borderColor,
                    offset: const Offset(1.0, 1.0),
                  ),
                ],
              ),
        ),
        centerTitle: true,
        backgroundColor: AppThemes.primaryColor,
        elevation: 10.0,
        shadowColor: AppThemes.primaryColor.withOpacity(0.5),
        actions: [
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: AppThemes.accentColor,
              size: 28.0,
            ),
            onPressed: () {
              _showCartDialog(context);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.history,
              color: AppThemes.accentColor,
              size: 28.0,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PurchaseHistoryScreen(clienteId: viewModel.clienteId),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0), // Ajustado para que no superponga
            child: viewModel.isLoadingOfertas
                ? const Center(child: CircularProgressIndicator(color: AppThemes.accentColor))
                : viewModel.ofertasDetalle.isEmpty
                    ? const Center(child: Text('No hay ofertas disponibles.'))
                    : RefreshIndicator(
                        onRefresh: viewModel.fetchOfertasDetalle,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          itemCount: viewModel.ofertasDetalle.length,
                          itemBuilder: (context, index) {
                            final oferta = viewModel.ofertasDetalle[index];
                            return _buildOfertaCard(context, oferta);
                          },
                        ),
                      ),
          ),
          Positioned(
            top: 10.0,
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

  /// Widget para construir el logo
  Widget _buildLogo() {
    return ScaleTransition(
      scale: _fadeInAnimation,
      child: Container(
        width: 80.0,
        height: 80.0,
        decoration: BoxDecoration(
          color: AppThemes.accentColor,
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
          Icons.storefront,
          color: AppThemes.primaryColor,
          size: 50.0,
          shadows: [
            Shadow(
              color: AppThemes.borderColor,
              offset: const Offset(1.0, 1.0),
            ),
          ],
        ),
      ),
    );
  }
}
