// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:agromarket_app/models/Agricultor/agricultor.dart';
import 'package:agromarket_app/models/Agricultor/terreno.dart';
import 'package:agromarket_app/models/Agricultor/produccion.dart';
import 'package:agromarket_app/models/Agricultor/oferta.dart';
import 'package:agromarket_app/models/Agricultor/oferta_detalle.dart';
import 'package:agromarket_app/models/Agricultor/unidad_medida.dart';
import 'package:agromarket_app/models/Agricultor/moneda.dart';
import 'package:agromarket_app/models/Agricultor/producto.dart';
import 'package:agromarket_app/models/Agricultor/temporada.dart';
import 'package:agromarket_app/models/Agricultor/carga_oferta.dart';

class ApiService {
  final String baseUrl;

  ApiService({String? baseUrl})
      : baseUrl = baseUrl ?? 'http://srv640327.hstgr.cloud:8080/api/v1';

  Future<dynamic> get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl$endpoint'));

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        return data;
      } catch (e) {
        print('Respuesta no JSON en $endpoint: ${response.body}');
        throw FormatException('La respuesta no está en formato JSON');
      }
    } else {
      print('Error en GET $endpoint: ${response.statusCode} - ${response.body}');
      throw Exception('Error en la solicitud GET: ${response.statusCode}');
    }
  }

  Future<dynamic> post(String endpoint, dynamic data) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return _processResponse(response, endpoint);
  }

  Future<dynamic> put(String endpoint, dynamic data) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return _processResponse(response, endpoint);
  }

  Future<dynamic> delete(String endpoint) async {
    final response = await http.delete(Uri.parse('$baseUrl$endpoint'));
    return _processResponse(response, endpoint);
  }

  dynamic _processResponse(http.Response response, String endpoint) {
    try {
      final jsonData = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonData;
      } else {
        print('Error en $endpoint: ${response.statusCode} - ${response.body}');
        throw Exception(jsonData['message'] ?? 'Error en la solicitud');
      }
    } catch (e) {
      print('Error al procesar la respuesta de $endpoint: ${response.body}');
      throw FormatException('La respuesta no está en formato JSON');
    }
  }

  //Agricultor

  // Obtener todos los agricultores
  Future<List<Agricultor>> Agricultor_getAgricultores() async {
    final data = await get('/agricultors');
    return (data as List).map((json) => Agricultor.fromJson(json)).toList();
  }

  // Crear un nuevo agricultor
  Future<Agricultor> Agricultor_createAgricultor(
      Map<String, dynamic> agricultorData) async {
    final data = await post('/agricultors', agricultorData);
    return Agricultor.fromJson(data);
  }

  // Mostrar detalles de un agricultor específico
  Future<Agricultor> Agricultor_getAgricultor(int id) async {
    final data = await get('/agricultors/$id');
    return Agricultor.fromJson(data);
  }

  // Actualizar datos de un agricultor
  Future<Agricultor> Agricultor_updateAgricultor(
      int id, Map<String, dynamic> agricultorData) async {
    final data = await put('/agricultors/$id', agricultorData);
    return Agricultor.fromJson(data);
  }

  // Eliminar un agricultor
  Future<void> Agricultor_deleteAgricultor(int id) async {
    await delete('/agricultors/$id');
  }

  // Obtener los terrenos del agricultor
  Future<List<Terreno>> Agricultor_getTerrenos(int agricultorId) async {
    final data = await get('/agricultors/$agricultorId/terrenos');
    return (data as List).map((json) => Terreno.fromJson(json)).toList();
  }

  // Obtener las producciones del agricultor
  Future<List<Produccion>> Agricultor_getProducciones(int agricultorId) async {
    final data = await get('/agricultors/$agricultorId/producciones');
    return (data as List).map((json) => Produccion.fromJson(json)).toList();
  }

    // Obtener las ofertas del agricultor
    Future<List<Oferta>> Agricultor_getOfertas(int agricultorId) async {
      final data = await get('/agricultors/$agricultorId/ofertas');
      return (data as List).map((json) => Oferta.fromJson(json)).toList();
    }

    // Obtener las Oferta Detalles del agricultor
    Future<List<OfertaDetalle>> Agricultor_getOfertas_detalles(int agricultorId) async {
      final data = await get('/agricultors/$agricultorId/oferta_detalles');
      return (data as List).map((json) => OfertaDetalle.fromJson(json)).toList();
    } 

     // Obtener las Cargas ofertas del agricultor
  Future<List<CargaOferta>> Agricultor_getCargasofertas(int agricultorId) async {
    final data = await get('/agricultors/$agricultorId/oferta_cargas');
    return (data as List).map((json) => CargaOferta.fromJson(json)).toList();
  } 
  //Terrenos

  // Obtener todos los terrenos
  Future<List<Terreno>> Terreno_getTerrenos() async {
    final data = await get('/terrenos');
    return (data as List).map((json) => Terreno.fromJson(json)).toList();
  }

  // Crear un nuevo terreno
  Future<Terreno> Terreno_createTerreno(
      Map<String, dynamic> terrenoData) async {
    final data = await post('/terrenos', terrenoData);
    return Terreno.fromJson(data);
  }

  // Mostrar detalles de un terreno específico
  Future<Terreno> Terreno_getTerreno(int id) async {
    final data = await get('/terrenos/$id');
    return Terreno.fromJson(data);
  }

  // Actualizar datos de un terreno
  Future<Terreno> Terreno_updateTerreno(
      int id, Map<String, dynamic> terrenoData) async {
    final data = await put('/terrenos/$id', terrenoData);
    return Terreno.fromJson(data);
  }

  // Eliminar un terreno
  Future<void> Terreno_deleteTerreno(int id) async {
    await delete('/terrenos/$id');
  }

  // Obtener todas las producciones relacionadas con un terreno específico
  Future<List<Produccion>> Terreno_getProducciones(int terrenoId) async {
    final data = await get('/terrenos/$terrenoId/producciones');
    return (data as List).map((json) => Produccion.fromJson(json)).toList();
  }

  // Obtener todos los terrenos de un agricultor
Future<List<Terreno>> Terreno_getTerrenosByAgricultorId(int agricultorId) async {
  try {
    final data = await get('/terrenos'); // Obtiene todos los terrenos
    final allTerrenos = (data as List).map((json) => Terreno.fromJson(json)).toList();
    // Filtra los terrenos por agricultorId
    return allTerrenos.where((terreno) => terreno.idAgricultor == agricultorId).toList();
  } catch (e) {
    print('Error obteniendo terrenos: $e');
    throw Exception('Error obteniendo terrenos');
  }
}


  //Producciones

  // Obtener todas las producciones
  Future<List<Produccion>> Produccion_getProducciones() async {
    final data = await get('/producciones');
    return (data as List).map((json) => Produccion.fromJson(json)).toList();
  }

  // Crear una nueva producción
  Future<Produccion> Produccion_createProduccion(
      Map<String, dynamic> produccionData) async {
    try {
      final data = await post('/producciones', produccionData);
      return Produccion.fromJson(data);
    } catch (e) {
      print("Error: $e");
      rethrow; // Lanza de nuevo la excepción
    }
  }

  // Mostrar detalles de una producción específica
  Future<Produccion> Produccion_getProduccion(int id) async {
    final data = await get('/producciones/$id');
    return Produccion.fromJson(data);
  }

  // Actualizar datos de una producción
  Future<Produccion> Produccion_updateProduccion(
      int id, Map<String, dynamic> produccionData) async {
    final data = await put('/producciones/$id', produccionData);
    return Produccion.fromJson(data);
  }

  // Eliminar una producción
Future<void> Produccion_deleteProduccion(int id) async {
  await delete('/producciones/$id'); // Correcto según tu descripción
}

  // Obtener producciones activas
  Future<List<Produccion>> Produccion_getProduccionesActivas() async {
    final data = await get('/producciones/activas');
    return (data as List).map((json) => Produccion.fromJson(json)).toList();
  }

  // Obtener todas las producciones relacionadas con un terreno
  Future<List<Produccion>> Produccion_getProduccionesByTerrenoId(
      int terrenoId) async {
    final data = await get('/terrenos/$terrenoId/producciones');
    return (data as List).map((json) => Produccion.fromJson(json)).toList();
  }

  // Obtener producciones por terreno
  Future<List<Produccion>> Produccion_getProduccionesByTerreno(
      int terrenoId) async {
    final data = await get('/producciones/terreno/$terrenoId');
    return (data as List).map((json) => Produccion.fromJson(json)).toList();
  }

  // Obtener producciones por temporada
  Future<List<Produccion>> Produccion_getProduccionesByTemporada(
      int temporadaId) async {
    final data = await get('/producciones/temporada/$temporadaId');
    return (data as List).map((json) => Produccion.fromJson(json)).toList();
  }

  // Obtener producciones por producto
  Future<List<Produccion>> Produccion_getProduccionesByProducto(
      int productoId) async {
    final data = await get('/producciones/producto/$productoId');
    return (data as List).map((json) => Produccion.fromJson(json)).toList();
  }

  //Ofertas

  // Obtener todas las ofertas
  Future<List<Oferta>> Ofertas_getOfertas() async {
    final data = await get('/ofertas');
    return (data as List).map((json) => Oferta.fromJson(json)).toList();
  }

  // Crear una nueva oferta
  Future<Oferta> Ofertas_createOferta(Map<String, dynamic> ofertaData) async {
    final data = await post('/ofertas', ofertaData);
    return Oferta.fromJson(data);
  }

  // Mostrar detalles de una oferta específica
  Future<Oferta> Ofertas_getOferta(int id) async {
    final data = await get('/ofertas/$id');
    return Oferta.fromJson(data);
  }

  // Actualizar datos de una oferta
  Future<Oferta> Ofertas_updateOferta(
      int id, Map<String, dynamic> ofertaData) async {
    final data = await put('/ofertas/$id', ofertaData);
    return Oferta.fromJson(data);
  }

  // Eliminar una oferta
  Future<void> deleteOferta(int id) async {
    await delete('/ofertas/$id');
  }

  // Obtener ofertas activas
  Future<List<Oferta>> Ofertas_getOfertasActivas() async {
    final data = await get('/ofertas/activas');
    return (data as List).map((json) => Oferta.fromJson(json)).toList();
  }

  // Extender la fecha de expiración de una oferta
  Future<Oferta> Ofertas_extendExpiracion(
      int id, String nuevaFechaExpiracion) async {
    final data = await put('/ofertas/$id/extend', {
      'nueva_fecha_expiracion': nuevaFechaExpiracion,
    });
    return Oferta.fromJson(data['oferta']);
  }

  // Obtener todas las ofertas relacionadas con una producción
  Future<List<Oferta>> Ofertas_getOfertasByProduccionId(
      int produccionId) async {
    try {
      final data = await get('/produccions/$produccionId/ofertas');
      print("Respuesta de API para producción $produccionId: $data");
      return (data as List).map((json) => Oferta.fromJson(json)).toList();
    } catch (e) {
      print("Error al obtener ofertas para producción $produccionId: $e");
      rethrow;
    }
  }

  //Ofertas_detalle

  // Obtener todos los detalles de ofertas
  Future<List<OfertaDetalle>> Ofertas_detalle_getOfertaDetalles() async {
    final data = await get('/oferta_detalles');
    return (data as List).map((json) => OfertaDetalle.fromJson(json)).toList();
  }

  // Crear un nuevo detalle de oferta
  Future<OfertaDetalle> Ofertas_detalle_createOfertaDetalle(
    Map<String, dynamic> detalleData) async {
  final data = await post('/oferta_detalles', detalleData);
  return OfertaDetalle.fromJson(data);
}

  // Mostrar detalles de un detalle de oferta específica
  Future<OfertaDetalle> Ofertas_detalle_getOfertaDetalle(int id) async {
    final data = await get('/oferta_detalles/$id');
    return OfertaDetalle.fromJson(data);
  }

  // Actualizar datos de un detalle de oferta
  Future<OfertaDetalle> Ofertas_detalle_updateOfertaDetalle(
      int id, Map<String, dynamic> detalleData) async {
    final data = await put('/oferta_detalles/$id', detalleData);
    return OfertaDetalle.fromJson(data);
  }

  // Eliminar un detalle de oferta
  Future<void> Ofertas_detalle_deleteOfertaDetalle(int id) async {
    await delete('/oferta_detalles/$id');
  }

  // Verificar disponibilidad de cantidad física en la oferta
  Future<bool> Ofertas_detalle_checkDisponibilidad(int id) async {
    final data = await get('/oferta_detalles/$id/disponibilidad');
    return data['disponible'];
  }

  // Obtener los detalles de una oferta específica
  Future<List<OfertaDetalle>> Ofertas_detalle_getOfertaDetallesByOfertaId(
      int ofertaId) async {
    final data = await get('/ofertas/$ofertaId/detalles');
    return (data as List).map((json) => OfertaDetalle.fromJson(json)).toList();
  }


  //Unidad_medida_

  // Obtener todas las unidades de medida
  Future<List<UnidadMedida>> Unidad_medida_getUnidadMedidas() async {
    final data = await get('/unidad_medidas');
    return (data as List).map((json) => UnidadMedida.fromJson(json)).toList();
  }

  // Crear una nueva unidad de medida
  Future<UnidadMedida> Unidad_medida_createUnidadMedida(
      Map<String, dynamic> unidadData) async {
    final data = await post('/unidad_medidas', unidadData);
    return UnidadMedida.fromJson(data);
  }

  // Mostrar detalles de una unidad de medida específica
  Future<UnidadMedida> Unidad_medida_getUnidadMedida(int id) async {
    final data = await get('/unidad_medidas/$id');
    return UnidadMedida.fromJson(data);
  }

  // Actualizar datos de una unidad de medida
  Future<UnidadMedida> Unidad_medida_updateUnidadMedida(
      int id, Map<String, dynamic> unidadData) async {
    final data = await put('/unidad_medidas/$id', unidadData);
    return UnidadMedida.fromJson(data);
  }

  // Eliminar una unidad de medida
  Future<void> Unidad_medida_deleteUnidadMedida(int id) async {
    await delete('/unidad_medidas/$id');
  }

  //Monedas_

  // Obtener todas las monedas
  Future<List<Moneda>> Monedas_getMonedas() async {
    final data = await get('/monedas');
    return (data as List).map((json) => Moneda.fromJson(json)).toList();
  }

  // Crear una nueva moneda
  Future<Moneda> Monedas_createMoneda(Map<String, dynamic> monedaData) async {
    final data = await post('/monedas', monedaData);
    return Moneda.fromJson(data);
  }

  // Mostrar detalles de una moneda específica
  Future<Moneda> Monedas_getMoneda(int id) async {
    final data = await get('/monedas/$id');
    return Moneda.fromJson(data);
  }

  // Actualizar datos de una moneda
  Future<Moneda> Monedas_updateMoneda(
      int id, Map<String, dynamic> monedaData) async {
    final data = await put('/monedas/$id', monedaData);
    return Moneda.fromJson(data);
  }

  // Eliminar una moneda
  Future<void> Monedas_deleteMoneda(int id) async {
    await delete('/monedas/$id');
  }

  //Producto_

  // Obtener todos los productos
  Future<List<Producto>> Producto_Producto_getProductos() async {
    final data = await get('/productos');
    return (data as List).map((json) => Producto.fromJson(json)).toList();
  }

  // Crear un nuevo producto
  Future<Producto> Producto_createProducto(Map<String, dynamic> productoData) async {
    final data = await post('/productos', productoData);
    return Producto.fromJson(data);
  }

  // Mostrar detalles de un producto específico
  Future<Producto> Producto_getProducto(int id) async {
    final data = await get('/productos/$id');
    return Producto.fromJson(data);
  }

  // Actualizar datos de un producto
  Future<Producto> Producto_updateProducto(
      int id, Map<String, dynamic> productoData) async {
    final data = await put('/productos/$id', productoData);
    return Producto.fromJson(data);
  }

  // Eliminar un producto
  Future<void> Producto_deleteProducto(int id) async {
    await delete('/productos/$id');
  }

  // Obtener todas las producciones relacionadas con un producto
  Future<List<Produccion>> Producto_getProducciones(int productoId) async {
    final data = await get('/productos/$productoId/producciones');
    return (data as List).map((json) => Produccion.fromJson(json)).toList();
  }

  //Temporada_

    // Obtener todas las temporadas
  Future<List<Temporada>> Temporada_getTemporadas() async {
    final data = await  get('/temporadas');
    return (data as List).map((json) => Temporada.fromJson(json)).toList();
  }

  // Crear una nueva temporada
  Future<Temporada> Temporada_createTemporada(Map<String, dynamic> temporadaData) async {
    final data = await  post('/temporadas', temporadaData);
    return Temporada.fromJson(data);
  }

  // Mostrar detalles de una temporada específica
  Future<Temporada> Temporada_getTemporada(int id) async {
    final data = await  get('/temporadas/$id');
    return Temporada.fromJson(data);
  }

  // Actualizar datos de una temporada
  Future<Temporada> Temporada_updateTemporada(int id, Map<String, dynamic> temporadaData) async {
    final data = await  put('/temporadas/$id', temporadaData);
    return Temporada.fromJson(data);
  }

  // Eliminar una temporada
  Future<void> Temporada_deleteTemporada(int id) async {
    await  delete('/temporadas/$id');
  }

  // Obtener todas las producciones de una temporada
  Future<List<Produccion>> Temporada_getProducciones(int temporadaId) async {
    final data = await  get('/temporadas/$temporadaId/producciones');
    return (data as List).map((json) => Produccion.fromJson(json)).toList();
  }

  //Cargar ofertas
  // Obtener todas las cargas de oferta
Future<List<CargaOferta>> CargaOferta_getCargas() async {
  final data = await get('/carga_ofertas');
  return (data as List).map((json) => CargaOferta.fromJson(json)).toList();
}

// Crear una nueva carga de oferta
Future<CargaOferta> CargaOferta_createCarga(Map<String, dynamic> cargaData) async {
  final data = await post('/carga_ofertas', cargaData);
  return CargaOferta.fromJson(data);
}

// Mostrar detalles de una carga de oferta específica
Future<CargaOferta> CargaOferta_getCarga(int id) async {
  final data = await get('/carga_ofertas/$id');
  return CargaOferta.fromJson(data);
}

// Actualizar datos de una carga de oferta
Future<CargaOferta> CargaOferta_updateCarga(int id, Map<String, dynamic> cargaData) async {
  final data = await put('/carga_ofertas/$id', cargaData);
  return CargaOferta.fromJson(data);
}

// Eliminar una carga de oferta
Future<void> CargaOferta_deleteCarga(int id) async {
  await delete('/carga_ofertas/$id');
}

// Obtener cargas de oferta por detalle de oferta
Future<List<CargaOferta>> CargaOferta_getCargasByDetalle(int ofertaDetalleId) async {
  final data = await get('/carga_ofertas/detalle/$ofertaDetalleId');
  return (data as List).map((json) => CargaOferta.fromJson(json)).toList();
}

// Obtener cargas de oferta filtradas por estado
Future<List<CargaOferta>> CargaOferta_getCargasByEstado(String estado) async {
  final data = await get('/carga_ofertas/estado/$estado');
  return (data as List).map((json) => CargaOferta.fromJson(json)).toList();
}
// Nuevo método para obtener terrenos por agricultor
  Future<List<Terreno>> getTerrenosByAgricultor(int agricultorId) async {
    final data = await get('/agricultors/$agricultorId/terrenos');
    return (data as List).map((json) => Terreno.fromJson(json)).toList();
  }

  // Método para obtener producciones por terreno
  Future<List<Produccion>> getProduccionesByTerreno(int terrenoId) async {
    final data = await get('/terrenos/$terrenoId/producciones');
    return (data as List).map((json) => Produccion.fromJson(json)).toList();
  }

  // Método para obtener ofertas por producción
  Future<List<Oferta>> getOfertasByProduccion(int produccionId) async {
    final data = await get('/produccions/$produccionId/ofertas');
    return (data as List).map((json) => Oferta.fromJson(json)).toList();
  }

  // Método para obtener detalles de oferta por oferta
  Future<List<OfertaDetalle>> getDetallesByOferta(int ofertaId) async {
    final data = await get('/ofertas/$ofertaId/detalles');
    return (data as List).map((json) => OfertaDetalle.fromJson(json)).toList();
  }

  // Método para obtener cargas de oferta por detalle de oferta
  Future<List<CargaOferta>> getCargasByDetalleOferta(int detalleId) async {
    final data = await get('/oferta_detalles/$detalleId/cargas');
    return (data as List).map((json) => CargaOferta.fromJson(json)).toList();
  }

}
