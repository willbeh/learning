import 'package:logger/logger.dart';

Logger getLogger(String className) {
  return Logger(
//    printer: SimpleLogPrinter(className),
    printer: PrettyPrinter(
      methodCount: 1, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 120, // width of the output
      colors: true, // Colorful log messages
      printEmojis: true,
    ),
  );
}

class SimpleLogPrinter extends LogPrinter {
  final String className;
  SimpleLogPrinter(this.className);



  @override
  List<String> log(LogEvent event) {
    var color = PrettyPrinter.levelColors[event.level];
    var emoji = PrettyPrinter.levelEmojis[event.level];
    return [(color('${DateTime.now()} $emoji $className - ${event.message}'))];
  }
}