import 'dart:html' as html;

Future<bool> requestWebNotificationPermission() async {
  if (html.Notification.supported) {
    final permission = await html.Notification.requestPermission();
    return permission == 'granted';
  }
  return false;
}

Future<bool> checkWebNotificationPermission() async {
  if (html.Notification.supported) {
    return html.Notification.permission == 'granted';
  }
  return false;
}
