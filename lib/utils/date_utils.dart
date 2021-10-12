import 'package:timeago/timeago.dart' as timeago;

class AppDateUtils {
  AppDateUtils(int timestamp)
      : dt = DateTime.fromMillisecondsSinceEpoch(timestamp);

  final DateTime dt;

  String get timeAgo {
    return timeago.format(dt);
  }
}
