import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:agromarket_app/ui/navegador.dart'; // Asegúrate de que tienes AppNavegador configurado

class NotificacionesService {
  static final NotificacionesService _instance =
      NotificacionesService._internal();

  factory NotificacionesService() => _instance;

  NotificacionesService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void inicializarNotificaciones() {
    // Configuración inicial de notificaciones locales
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    // Configuración para manejar notificaciones en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Mensaje recibido en primer plano: ${message.notification?.body}');
      mostrarNotificacion(message);
    });

    // Configuración para manejar notificaciones tocadas
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notificación tocada: ${message.data}');
      _onDidReceiveNotificationResponse(
        NotificationResponse(
          notificationResponseType:
              NotificationResponseType.selectedNotification, // Tipo necesario
          payload: message.data['screen'], // Pasar datos adicionales
        ),
      );
    });

    // Configuración para notificaciones en segundo plano
    _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // Manejar notificaciones locales
  Future<void> mostrarNotificacion(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'default_notification_channel_id',
      'Notificaciones',
      channelDescription: 'Canal de notificaciones',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: message.data['screen'], // Pasar información adicional
    );
    print(message.data);
  }

  // Manejar acciones al tocar la notificación
  void _onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) {
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      print('Navegar a pantalla: $payload');
      switch (payload) {
        case 'home':
          AppNavegador.instance.navegarScreen(
            '/home',
            arguments: AppNavegador.instance.getAgricultorId(),
          );
          break;
        case 'CargaOfertaScreen':
          AppNavegador.instance.navegarScreen(
            '/cargaOferta',
            arguments: AppNavegador.instance.getAgricultorId(),
          );
          break;
        default:
          print('Pantalla no reconocida: $payload');
          break;
      }
    }
  }

  // Obtener token FCM
  Future<String?> obtenerTokenFCM() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      print('Token FCM: $token');
      return token;
    } catch (e) {
      print('Error al obtener el token FCM: $e');
      return null;
    }
  }

  // Copiar token al portapapeles
  Future<void> copiarTokenAlPortapapeles() async {
    try {
      String? token = await obtenerTokenFCM();
      if (token != null) {
        await Clipboard.setData(ClipboardData(text: token));
        print('Token copiado al portapapeles.');
      }
    } catch (e) {
      print('Error al copiar el token: $e');
    }
  }
}

// Controlador global para notificaciones en segundo plano
Future<void> onBackgroundMessageHandler(RemoteMessage message) async {
  print('Mensaje recibido en segundo plano: ${message.notification?.body}');
}
