import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Future<void> initialized() async {
    const AndroidInitializationSettings initializationSettingsAndorid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndorid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }

  void _onNotificationTap(NotificationResponse response) {
    print("Notification Clicked: ${response.payload}");
  }

  Future<void> showInstantNotification() async{
    const AndroidNotificationDetails androidPlatformChannelSpecifies = AndroidNotificationDetails(
        'instant_channel',
        'instant Notification',
      channelDescription: 'Channel for instant notification',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platfomChannelSpecifies = NotificationDetails(android: androidPlatformChannelSpecifies);

    await flutterLocalNotificationsPlugin.show(
        0,
        'Title of Notification',
        'Description of Notification',
        platfomChannelSpecifies,
        payload: 'instant',
    );
  }

  Future<void> scheduleNotification(DateTime scheduleDateTime) async{
    const AndroidNotificationDetails androidPlatformChannelSpecifies = AndroidNotificationDetails(
      'instant_channel',
      'instant Notification',
      channelDescription: 'Channel for instant notification',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platfomChannelSpecifies = NotificationDetails(android: androidPlatformChannelSpecifies);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      'PyPo Reminder',
      'Saatnya Nabung!!',
      tz.TZDateTime.from(scheduleDateTime, tz.local),
      platfomChannelSpecifies,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'schedule', androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }
}