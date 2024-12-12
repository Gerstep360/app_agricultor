// lib/view_models/client_home_view_model.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agromarket_app/services/api_service.dart';
import 'package:agromarket_app/models/Cliente/pedidos.dart';
import 'package:agromarket_app/models/Agricultor/oferta_detalle.dart';
import 'package:agromarket_app/ui/screens/roles/role_selection_screen.dart';

class ClientHomeViewModel extends ChangeNotifier {
  final ApiService apiService;
  final int clienteId;

  bool isLoadingPedidos = false;
  bool isLoadingOfertas = false;
  String errorMessagePedidos = '';
  String errorMessageOfertas = '';

  final List<Pedidos> _pedidos = [];
  final List<OfertaDetalle> _ofertasDetalle = [];
  final List<Pedidos> _cartItems = [];
  double _totalPrice = 0.0;
  final String _currency = 'USD';

  List<Pedidos> get pedidos => _pedidos;
  List<OfertaDetalle> get ofertasDetalle => _ofertasDetalle;
  List<Pedidos> get cartItems => _cartItems;
  double get totalPrice => _totalPrice;
  String get currency => _currency;

  ClientHomeViewModel({
    required this.apiService,
    required this.clienteId,
  }) {
    print('ClientHomeViewModel creado para clienteId: $clienteId');
    fetchPedidos();
    fetchOfertasDetalle();
  }

  /// Obtener los pedidos del cliente.
  Future<void> fetchPedidos() async {
    isLoadingPedidos = true;
    notifyListeners();

    try {
      _pedidos.clear();
      final pedidosList = await apiService.getPedidosByCliente(clienteId);
      _pedidos.addAll(pedidosList);
      isLoadingPedidos = false;
      notifyListeners();
    } catch (e) {
      errorMessagePedidos = 'Error al obtener pedidos: $e';
      isLoadingPedidos = false;
      notifyListeners();
    }
  }

  /// Obtener las ofertas detalles.
  Future<void> fetchOfertasDetalle() async {
    isLoadingOfertas = true;
    notifyListeners();

    try {
      _ofertasDetalle.clear();
      final ofertasList = await apiService.Ofertas_detalle_getOfertaDetalles();
      _ofertasDetalle.addAll(ofertasList);
      isLoadingOfertas = false;
      notifyListeners();
    } catch (e) {
      errorMessageOfertas = 'Error al obtener ofertas: $e';
      isLoadingOfertas = false;
      notifyListeners();
    }
  }

  /// Agregar un pedido al carrito.
  void addToCart(Pedidos pedido) {
    _cartItems.add(pedido);
    _calculateTotal();
    notifyListeners();
  }

  /// Eliminar un pedido del carrito.
  void removeFromCart(Pedidos pedido) {
    _cartItems.remove(pedido);
    _calculateTotal();
    notifyListeners();
  }

  /// Calcular el total del carrito.
  void _calculateTotal() {
    _totalPrice = 0.0;
    for (var item in _cartItems) {
      _totalPrice += _getPrecioPedido(item);
    }
  }

  /// Obtener el precio de un pedido.
  double _getPrecioPedido(Pedidos pedido) {
    // Implementa aquí la lógica para obtener el precio de un pedido.
    // Esto puede depender de la cantidad, el producto, etc.
    // Por ejemplo:
    return 100.0; // Placeholder
  }

  /// Realizar el checkout.
  Future<void> checkout(BuildContext context) async {
    if (_cartItems.isEmpty) return;

    isLoadingPedidos = true; // Puedes usar una bandera separada como isLoadingCheckout
    notifyListeners();

    try {
      // Implementa la lógica de compra aquí.
      // Por ejemplo, enviar los pedidos al backend para procesarlos.
      for (var pedido in _cartItems) {
        await apiService.createPedido(pedido.toJson());
      }

      // Limpiar el carrito después de la compra
      _cartItems.clear();
      _calculateTotal();
      isLoadingPedidos = false;
      notifyListeners();

      // Mostrar SnackBar de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compra realizada con éxito')),
      );
    } catch (e) {
      errorMessagePedidos = 'Error al procesar la compra: $e';
      isLoadingPedidos = false;
      notifyListeners();

      // Mostrar SnackBar de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessagePedidos)),
      );
    }
  }

  /// Cerrar sesión.
  Future<void> logout(BuildContext context) async {
    isLoadingPedidos = true; // O crea una bandera separada como isLoadingLogout
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedClienteId = prefs.getInt('clienteId');

    if (storedClienteId != null) {
      try {
        await apiService.updateCliente(storedClienteId, {'tokendevice': null});
      } catch (e) {
        errorMessagePedidos = 'Error al cerrar sesión: $e';
        isLoadingPedidos = false;
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessagePedidos)),
        );
        return;
      }
    }

    await prefs.remove('clienteId');

    isLoadingPedidos = false;
    notifyListeners();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => RoleSelectionScreen()),
    );
  }
}
