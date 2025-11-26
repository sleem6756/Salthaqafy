import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../database_helper.dart';
import 'azkar_main_page.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Internal state for notifications (default: enabled)
  static bool _notificationsEnabled = true;

  /// Initializes the notifications plugin.
  static Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload == 'اذكار') {
          final context = globalNavigatorKey.currentContext!;
          // Navigate to AzkarPage
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const AzkarPage(),
          ));
        }
      },
    );
  }

  static Future<void> enableNotifications() async {
    _notificationsEnabled = true;
    await DatabaseHelper().setNotificationsEnabled(true);
    await scheduleAzkarNotifications();
  }

  static Future<void> disableNotifications() async {
    _notificationsEnabled = false;
    await DatabaseHelper().setNotificationsEnabled(false);

    await _notificationsPlugin.cancelAll();
  }

  /// Checks if notifications are currently enabled.
  static bool isNotificationsEnabled() {
    return _notificationsEnabled;
  }

  static Future<void> scheduleAzkarNotifications() async {
    if (!_notificationsEnabled) return;

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.setLocalLocation(tz.getLocation('Africa/Cairo'));

    int notificationId = 0;

    await _scheduleDailyNotification(
      notificationId++,
      'أذكار النوم',
      'وقت قراءة أذكار النوم',
      tz.TZDateTime(tz.local, now.year, now.month, now.day, 0, 0),
      'default',
      payload: 'اذكار',
    );

    await _scheduleDailyNotification(
      notificationId++,
      'أذكار الاستيقاظ',
      'وقت قراءة أذكار الاستيقاظ',
      tz.TZDateTime(tz.local, now.year, now.month, now.day, 8, 0),
      'default',
      payload: 'اذكار',
    );
  }

  static Future<void> _scheduleDailyNotification(
    int id,
    String title,
    String body,
    tz.TZDateTime scheduledTime,
    String sound, {
    String? payload,
  }) async {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'notification_channel_$id',
      'Notifications $title',
      channelDescription: 'Notifications for $title',
      importance: Importance.max,
      priority: Priority.high,
      sound: sound == 'default'
          ? null
          : RawResourceAndroidNotificationSound(sound),
    );

    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      notificationDetails,
      // uiLocalNotificationDateInterpretation:
      //     UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

}

mixin globalNavigatorKey {
  static const currentContext = null;
}
