import 'package:logger/logger.dart';

final Logger appLogger = Logger(
  printer: PrettyPrinter(
    methodCount: 0, 
    errorMethodCount: 8, 
    lineLength: 120, 
    colors: true, 
    printEmojis: true, 
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
);
