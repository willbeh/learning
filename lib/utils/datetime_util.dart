import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DateTimeUtil {
  static DateTime fromTimestamp(var timestamp) {
    if (timestamp is Timestamp) {
      return timestamp == null ? null : timestamp.toDate();
    }
    else if(timestamp is String) {
      if (timestamp.contains(".")) {
        return DateTime.parse(timestamp.substring(0, timestamp.length - 1));
      }
      return DateTime.parse(timestamp);
    }
    else {
      return timestamp;
    }
  }

  static Timestamp toTimestamp(DateTime dt) =>
      dt == null ? null : Timestamp.fromDate(dt);

  static DateTime fromMilliseconds(int milliseconds) =>
    milliseconds == null ? null : DateTime.fromMillisecondsSinceEpoch(milliseconds);

  static int toMilliseconds(DateTime dt) =>
    dt == null ? null : dt.millisecondsSinceEpoch;

  static String displayDate(DateTime datetime) =>
      datetime == null ? 'N/A' : DateFormat('dd MMM yyyy').format(datetime);

  static String displayDateTime(DateTime datetime) =>
      datetime == null ? 'N/A' : DateFormat('dd MMM yyyy HH:mm').format(datetime);

  static String displayHourMinute(DateTime datetime) =>
      datetime == null ? 'N/A' : DateFormat('HH:mm').format(datetime);

  static String displayHourMinuteSecond(DateTime datetime) =>
      datetime == null ? 'N/A' : DateFormat('HH:mm:ss').format(datetime);

  static String displayMonth(int m) {
    DateTime datetime = DateTime(DateTime.now().year, m);
    return DateFormat('MMM').format(datetime);
  }

  static String displayWeekDay(DateTime datetime) =>
      datetime == null ? 'N/A' : DateFormat('EEEE').format(datetime);

  static String fromToTimeStamp(DateTime from, DateTime to) {
    if(from.year == to.year) {
      if(from.month == to.month) {
        return from.day.toString() + ' - ' + DateFormat('dd MMM yyyy').format(to);
      } else {
        return DateFormat('dd MMM').format(from) + ' - ' + DateFormat('dd MMM yyyy').format(to);
      }
    } else {
      return DateFormat('dd MMM yyyy').format(from) + ' - ' + DateFormat('dd MMM yyyy').format(to);
    }
  }

  static String fromToWithTimeStamp(DateTime from, DateTime to) {
    if(from.year == to.year) {
      if(from.month == to.month) {
        return DateFormat('H:mm').format(from) + ' - ' + DateFormat('H:mm dd/MMM/yyyy').format(to);
      } else {
        return DateFormat('H:mm dd/MMM').format(from) + ' - ' + DateFormat('H:mm dd/MMM/yyyy').format(to);
      }
    } else {
      return DateFormat('H:mm dd/MMM/yyyy').format(from) + ' - ' + DateFormat('H:mm dd/MMM/yyyy').format(to);
    }
  }

  static int untilDate(DateTime from, DateTime to){
    DateTime d = DateTime.now();
    if(d.isBefore(from)) {
      return (from.difference(d).inDays + 1);
    } else {
      if(to.isAfter(d) || to.isAtSameMomentAs(d)) {
        return 0;
      }
      else {
        return -1;
      }
    }
  }

  static String formatDurationHMMSS(Duration d) => d.toString().split('.').first.padLeft(7, "0");

  static String formatDuration(Duration position) {
    final ms = position.inMilliseconds;

    int seconds = ms ~/ 1000;
    final int hours = seconds ~/ 3600;
    seconds = seconds % 3600;
    var minutes = seconds ~/ 60;
    seconds = seconds % 60;

    final hoursString = hours >= 10 ? '$hours' : hours == 0 ? '00' : '0$hours';

    final minutesString =
    minutes >= 10 ? '$minutes' : minutes == 0 ? '00' : '0$minutes';

    final secondsString =
    seconds >= 10 ? '$seconds' : seconds == 0 ? '00' : '0$seconds';

    final formattedTime =
        '${hoursString == '00' ? '' : hoursString + ':'}$minutesString:$secondsString';

    return formattedTime;
  }

}