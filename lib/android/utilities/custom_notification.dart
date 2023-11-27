import 'package:adote_um_pet/android/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CustomNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  CustomNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });
}

class NotificationService {
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  late AndroidNotificationDetails androidDetails;

  NotificationService() {
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();

    _setupNotifications();
  }

  void _setupNotifications() async {
    await _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    await localNotificationsPlugin.initialize(
      const InitializationSettings(
        android: android,
      ),onDidReceiveBackgroundNotificationResponse: (details) {
        print("recebeu background notification response");
        print(details);
      },
      onDidReceiveNotificationResponse: (details) {
        print("recebeu notificação response");
        print(details);
      },

    );
  }

  _onSelectNotification(String? payload) {
    if ( payload != null && payload.isNotEmpty)
      {
        Navigator.of(Routes.navigatorKey!.currentContext!).pushNamed(payload);
      }
  }

  void showNotification( CustomNotification notification )
  {
    androidDetails = const AndroidNotificationDetails(
      'id de notificação',
      'titulo',
      channelDescription: "descrição de canal",
      importance: Importance.max,
      priority: Priority.max
    );

    localNotificationsPlugin.show(
      notification.id,
      notification.title,
      notification.body,
      NotificationDetails(
        android: androidDetails,
      ),
      payload: notification.payload,
    );
  }

  void checkForNotifications() async {
    final details = await localNotificationsPlugin.getNotificationAppLaunchDetails();

    if ( details != null && details.didNotificationLaunchApp) {
      _onSelectNotification(details.notificationResponse?.payload);
    }
  }
}
