import 'package:intl/intl.dart';

extension DatetimeExtension on DateTime {
  String get toHM {
    return DateFormat('HH:mm').format(this);
  }

  String get toYMD {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String get toYMDHM {
    return DateFormat('yyyy-MM-dd HH:mm').format(this);
  }
}
