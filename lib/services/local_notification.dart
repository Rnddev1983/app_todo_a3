import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:todo_list/configs/routes_config.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:todo_list/models/custom_notification.dart';

class NotificationService {
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  late AndroidNotificationDetails androidDetails;

  NotificationService() {
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _setupAndroidDetails();
    _setupNotifications();
  }

  _setupAndroidDetails() {
    androidDetails = const AndroidNotificationDetails(
      'lembretes_notifications_details',
      'Lembretes',
      channelDescription: 'Este canal é para lembretes!',
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
    );
  }

  _setupNotifications() async {
    await _setupTimezone();
    await _initializeNotifications();
  }

  Future<void> _setupTimezone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  _initializeNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    // Fazer: macOs, iOS, Linux...
    await localNotificationsPlugin.initialize(
      const InitializationSettings(
        android: android,
      ),
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        _onSelectNotification(notificationResponse);
      },
      onDidReceiveBackgroundNotificationResponse:
          (NotificationResponse notificationResponse) {
        _onSelectNotification(notificationResponse);
      },
    );
  }

  _onSelectNotification(NotificationResponse? notificationResponse) {
    if (notificationResponse != null && notificationResponse!.payload != null) {
      print(
          'Payload: ${notificationResponse!.payload}-${notificationResponse!.id}---------------------------------------------------------------');
      Navigator.of(navigatorKey!.currentContext!).pushNamed(
          notificationResponse.payload!,
          arguments: notificationResponse.id);
    }
  }

  showNotificationScheduled(
      CustomNotification notification, Duration duration) {
    final date = DateTime.now().add(duration);

    localNotificationsPlugin.zonedSchedule(
      notification.id,
      notification.title,
      notification.body,
      tz.TZDateTime.from(date, tz.local),
      NotificationDetails(
        android: androidDetails,
      ),
      payload: notification.payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  showLocalNotification(CustomNotification notification) {
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

  cancelNotification(int id) {
    localNotificationsPlugin.cancel(id);
  }

  checkForNotifications() async {
    final details =
        await localNotificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      _onSelectNotification(details.notificationResponse!);
    }
  }

  showNotificationIfTimeIsNow(
      CustomNotification notification, Duration duration) {
    final date = DateTime.now().add(duration);
    final now = DateTime.now();
    if (duration.inSeconds > 0 && date.isAfter(now)) {
      showNotificationScheduled(notification, duration);
    } else {
      showLocalNotification(notification);
    }
  }
}
