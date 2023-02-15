import 'package:logger/logger.dart';

class LOG {
  static final Logger _logger = Logger();

  static void info(String message) {
    _logger.log(Level.info, message);
  }

  static void error(String message) {
    _logger.log(Level.error, message);
  }

  static void verbose(String msg) {
    _logger.log(Level.verbose, msg);
  }
}
