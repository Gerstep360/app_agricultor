// lib/view_models/purchase_history_view_model.dart

import 'package:flutter/material.dart';
import 'package:agromarket_app/services/api_service.dart';
import 'package:agromarket_app/models/Cliente/pedidos.dart';

class PurchaseHistoryViewModel extends ChangeNotifier {
  final ApiService apiService;
  final int clienteId;

  bool isLoading = false;
  String errorMessage = '';
  List<Pedidos> pedidos = [];

  PurchaseHistoryViewModel({
    required this.apiService,
    required this.clienteId,
  }) {
    print('PurchaseHistoryViewModel creado para clienteId: $clienteId');
    fetchPurchaseHistory();
  }

  /// Obtener el historial de compras del cliente.
  Future<void> fetchPurchaseHistory() async {
    isLoading = true;
    notifyListeners();

    try {
      pedidos = await apiService.getPedidosByCliente(clienteId);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = 'Error al obtener el historial de compras: $e';
      isLoading = false;
      notifyListeners();
    }
  }
}
