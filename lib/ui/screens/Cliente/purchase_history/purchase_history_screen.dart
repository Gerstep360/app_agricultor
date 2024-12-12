// lib/ui/screens/cliente/purchase_history/purchase_history_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agromarket_app/ui/themes/theme.dart';
import 'package:agromarket_app/ui/screens/Cliente/purchase_history/view_models/purchase_history_view_model.dart';
import 'package:agromarket_app/services/api_service.dart';
import 'package:agromarket_app/models/Cliente/pedidos.dart';

class PurchaseHistoryScreen extends StatelessWidget {
  final int clienteId;

  const PurchaseHistoryScreen({Key? key, required this.clienteId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PurchaseHistoryViewModel(apiService: ApiService(), clienteId: clienteId),
      child: const PurchaseHistoryContent(),
    );
  }
}

class PurchaseHistoryContent extends StatefulWidget {
  const PurchaseHistoryContent({Key? key}) : super(key: key);

  @override
  State<PurchaseHistoryContent> createState() => _PurchaseHistoryContentState();
}

class _PurchaseHistoryContentState extends State<PurchaseHistoryContent> {
  late PurchaseHistoryViewModel _viewModel;
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<PurchaseHistoryViewModel>(context, listen: false);
    // _viewModel.fetchPurchaseHistory(); // Ya se llama en el ViewModel constructor

    // Listener para mostrar SnackBar cuando haya un mensaje de error
    _listener = () {
      if (_viewModel.errorMessage.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _viewModel.errorMessage,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
          _viewModel.errorMessage = ''; // Reiniciar el mensaje de error después de mostrar
        });
      }
    };

    _viewModel.addListener(_listener);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_listener);
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PurchaseHistoryViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Compras'),
        backgroundColor: AppThemes.primaryColor,
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppThemes.accentColor))
          : viewModel.errorMessage.isNotEmpty
              ? Center(child: Text(viewModel.errorMessage))
              : viewModel.pedidos.isEmpty
                  ? const Center(child: Text('No hay pedidos realizados.'))
                  : ListView.builder(
                      itemCount: viewModel.pedidos.length,
                      itemBuilder: (context, index) {
                        final pedido = viewModel.pedidos[index];
                        return ListTile(
                          leading: Icon(Icons.receipt_long, color: AppThemes.accentColor),
                          title: Text('Pedido #${pedido.id}'),
                          subtitle: Text('Fecha de Entrega: ${pedido.fecha_entrega.toLocal().toString().split(' ')[0]}'),
                          trailing: Text(pedido.estado),
                          onTap: () {
                            _showPedidoDetails(context, pedido);
                          },
                        );
                      },
                    ),
    );
  }
}
