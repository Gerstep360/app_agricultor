import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:agromarket_app/models/Agricultor/oferta.dart';
import 'package:agromarket_app/models/Agricultor/oferta_detalle.dart';
import 'package:agromarket_app/models/Agricultor/moneda.dart';

class OfertaInformacionScreen extends StatelessWidget {
  final Oferta oferta;
  final OfertaDetalle detalle;
  final Moneda moneda;

  const OfertaInformacionScreen({
    super.key,
    required this.oferta,
    required this.detalle,
    required this.moneda,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Oferta'),
        backgroundColor: Color(0xFF117864),
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 50, // Puedes ajustar el tamaño de fuente aquí
          fontWeight: FontWeight.bold,
          ),
      ),

      backgroundColor: Color(0xFF48c9b0),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 700),
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Color(0xFF148f77),
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0e6251),
                    blurRadius: 15,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ID de Oferta: ${oferta.id}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Producto ID: ${oferta.idProduccion}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                  Text(
                    'Fecha de Expiración: ${oferta.fechaExpiracion}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                  Text(
                    'Estado: ${oferta.estado}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                  Text(
                    'Precio: ${detalle.precio.toStringAsFixed(2)} ${moneda.nombre}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                  Text(
                    'Cantidad Física: ${detalle.cantidadFisico}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Acción de modificación no funcional por ahora
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: Color(0xFF148f77),
                  elevation: 5,
                ),
                child: Text(
                  'Modificar',
                  style: TextStyle(fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
