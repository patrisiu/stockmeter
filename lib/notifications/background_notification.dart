import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class BackgroundNotification {
  void show(String title, String body) {
    FlutterLocalNotificationsPlugin flip =
        new FlutterLocalNotificationsPlugin();

    // app_icon needs to be a added as a drawable
    // resource to the Android head project.
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var IOS = new IOSInitializationSettings();

    // initialise settings for both Android and iOS device.
    var settings = new InitializationSettings(android: android, iOS: IOS);
    flip.initialize(settings);
    _showNotificationWithDefaultSound(flip, title, body);
  }

  static Future _showNotificationWithDefaultSound(
      FlutterLocalNotificationsPlugin flip, String title, String body) async {
    // Show a notification after every 15 minute with the first
    // appearance happening a minute after invoking the method
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

    // initialise channel platform for both Android and iOS device.
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flip.show(0, title, body, platformChannelSpecifics,
        payload: 'Default_Sound');
  }

  static void showList(String title, List<String> body) {
    FlutterLocalNotificationsPlugin flip =
        new FlutterLocalNotificationsPlugin();

    // app_icon needs to be a added as a drawable
    // resource to the Android head project.
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var IOS = new IOSInitializationSettings();

    // initialise settings for both Android and iOS device.
    var settings = new InitializationSettings(android: android, iOS: IOS);
    flip.initialize(settings);
    _showNotificationWithDefaultSoundBackground(flip, title, body);
  }

  static Future _showNotificationWithDefaultSoundBackground(
      FlutterLocalNotificationsPlugin flip,
      String title,
      List<String> body) async {
    // Show a notification after every 15 minute with the first
    // appearance happening a minute after invoking the method
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: new InboxStyleInformation(body));
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

    // initialise channel platform for both Android and iOS device.
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flip.show(0, title, null, platformChannelSpecifics,
        payload: 'Default_Sound');
  }
}
