import 'package:drink_more/config/router.dart';
import 'package:drink_more/core/database/database_service.dart';
import 'package:drink_more/entities/local/reminder_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotification {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static Future init() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(onDidReceiveLocalNotification: (id, title, body, payload) {
      print(payload);
    });
    const LinuxInitializationSettings initializationSettingsLinux = LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsDarwin, linux: initializationSettingsLinux);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (detail) {
      router.push("/Reminder");
    });

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    tz.initializeTimeZones();
  }

  static Future<void> showDailyNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    required int timeInSeconds,
  }) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final int hours = timeInSeconds ~/ 3600;
    final int minutes = (timeInSeconds % 3600) ~/ 60;

    tz.TZDateTime scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hours,
      minutes,
    );

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    print("到底${tz.TZDateTime.now(tz.local)}");
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime.subtract(const Duration(seconds: 28800)),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: timeInSeconds.toString(),
    );
  }

  static Future<void> scheduleWaterReminders() async {
    final dbService = GetIt.I.get<DatabaseService>();
    final List<ReminderModel> reminders = await dbService.getReminders();
    for (var reminder in reminders) {
      final int id = reminder.id;
      final int timeInSeconds = reminder.seconds;

      await showDailyNotification(
        id: id,
        title: 'Reminder',
        body: 'It\'s time to drink water!',
        payload: timeInSeconds.toString(),
        timeInSeconds: timeInSeconds,
      );
    }
  }
}
