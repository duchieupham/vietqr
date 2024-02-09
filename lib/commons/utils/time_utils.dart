import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/utils/log.dart';

class TimeUtils {
  const TimeUtils._privateConsrtructor();

  static const TimeUtils _instance = TimeUtils._privateConsrtructor();

  static TimeUtils get instance => _instance;

  String formatDateToString(DateTime? now, {bool isExport = false}) {
    now ??= DateTime.now();
    DateFormat format;
    if (isExport) {
      format = DateFormat('dd/MM/yyyy');
    } else {
      format = DateFormat('HH:mm dd/MM/yyyy');
    }

    String formatted = format.format(now);
    return formatted;
  }

  String getCurrentDate(DateTime? now) {
    now ??= DateTime.now();
    DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
    String formatted = format.format(now);
    return formatted;
  }

  DateTime getDateFromString(String time) {
    List<String> times = time.split('/');
    DateTime result = DateTime.now();
    if (times.length == 3) {
      result = DateTime(
        int.parse(times[2]),
        int.parse(times[1]),
        int.parse(times[0]),
      );
    }
    return result;
  }

  String formatTime(String date) {
    String result = '';
    DateFormat format = DateFormat('dd/MM/yyyy HH:mm');
    bool isValidDate = DateTime.tryParse(date.toString()) != null;
    if (date != '' && isValidDate) {
      result = format.format(DateTime.parse(date)).toString();
    }
    return result;
  }

  String formatBankTime(String date) {
    String result = '';
    DateFormat format = DateFormat('yyyy-MM-ddTHH:mm:ss');
    bool isValidDate = DateTime.tryParse(date.toString()) != null;
    if (date != '' && isValidDate) {
      result = format.format(DateTime.parse(date)).toString();
    }
    return result;
  }

  String formatBankTimeView(String date) {
    String result = '';
    DateFormat format = DateFormat('HH:mm dd/MM/yyyy');
    bool isValidDate = DateTime.tryParse(date.toString()) != null;
    if (date != '' && isValidDate) {
      result = format.format(DateTime.parse(date)).toString();
    }
    return result;
  }

  String formatDate(String date) {
    String result = '';
    DateFormat format = DateFormat('dd/MM/yyyy');
    bool isValidDate = DateTime.tryParse(date.toString()) != null;
    if (date != '' && isValidDate) {
      result = format.format(DateTime.parse(date)).toString();
    }
    return result;
  }

  String formatDateContent(String date) {
    String result = '';
    DateFormat format = DateFormat('ddMMyyyy');
    bool isValidDate = DateTime.tryParse(date.toString()) != null;
    if (date != '' && isValidDate) {
      result = format.format(DateTime.parse(date)).toString();
    }
    return result;
  }

  String formatHour(String date) {
    String formattedTime = '';
    DateFormat format = DateFormat('HH:mm');
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    String dateNow = DateTime.now().toString();
    bool isValidDate = DateTime.tryParse(date.toString()) != null;
    if (date != '' && DateTime.tryParse(date) != null) {
      if (dateFormat.format(DateTime.parse(dateNow)).toString() ==
          dateFormat.format(DateTime.parse(date)).toString()) {
        if (date != '' && isValidDate) {
          formattedTime = format.format(DateTime.parse(date.toString()));
        }
      } else {
        if (date != '' && isValidDate) {
          formattedTime = dateFormat.format(DateTime.parse(date)).toString();
        }
      }
    }

    return formattedTime;
  }

  //format hour to display message detail.
  String formatHour2(String date) {
    String formattedTime = '';
    DateFormat format = DateFormat('HH:mm');
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    String dateNow = DateTime.now().toString();
    bool isValidDate = DateTime.tryParse(date.toString()) != null;
    if (date != '' && DateTime.tryParse(date) != null) {
      if (dateFormat.format(DateTime.parse(dateNow)).toString() ==
          dateFormat.format(DateTime.parse(date)).toString()) {
        if (date != '' && isValidDate) {
          formattedTime =
              '${format.format(DateTime.parse(date.toString()))} Hôm nay';
        }
      } else {
        if (date != '' && isValidDate) {
          formattedTime =
              '${format.format(DateTime.parse(date.toString()))} ${dateFormat.format(DateTime.parse(date))}';
        }
      }
    }

    return formattedTime;
  }

  //get date in week to display dashboard
  String getCurrentDateInWeek(DateTime? now) {
    String result = '';
    now ??= DateTime.now();
    DateFormat format = DateFormat('yyyy-MM-dd-EEEE');
    String formatted = format.format(now);
    result = formatDateOfWeek(formatted.split('-')[3]);
    return result;
  }

  //get current date to display today_view
  String getCurentDate(DateTime? now) {
    String result = '';
    now ??= DateTime.now();
    String day = DateFormat.d(const Locale('en').countryCode).format(now);
    String month = formatMonthCalendar(
        DateFormat.M(const Locale('en').countryCode).format(now));
    result = '$day $month';
    return result;
  }

  String getRealTime() {
    DateTime now = DateTime.now();
    DateFormat format = DateFormat('HH:mm:ss');
    return format.format(now);
  }

  //format month in header of calendar
  String formatMonthCalendar(String month) {
    String result = '';
    String prefix = 'Tháng';
    bool? isNaN = (int.tryParse(month)!.isNaN);
    if (!isNaN) {
      int? montInt = int.tryParse(month);
      if (montInt == 1) {
        result = '$prefix Một';
      } else if (montInt == 2) {
        result = '$prefix Hai';
      } else if (montInt == 3) {
        result = '$prefix Ba';
      } else if (montInt == 4) {
        result = '$prefix Tư';
      } else if (montInt == 5) {
        result = '$prefix Năm';
      } else if (montInt == 6) {
        result = '$prefix Sáu';
      } else if (montInt == 7) {
        result = '$prefix Bảy';
      } else if (montInt == 8) {
        result = '$prefix Tám';
      } else if (montInt == 9) {
        result = '$prefix Chín';
      } else if (montInt == 10) {
        result = '$prefix Mười';
      } else if (montInt == 11) {
        result = '$prefix Mười Một';
      } else if (montInt == 12) {
        result = '$prefix Mười Hai';
      }
    }
    return result;
  }

//get date of week string
  String formatDateOfWeek(String value) {
    String result = '';
    if (value == 'Monday') {
      result = 'Thứ hai';
    } else if (value == 'Tuesday') {
      result = 'Thứ ba';
    } else if (value == 'Wednesday') {
      result = 'Thứ tư';
    } else if (value == 'Thursday') {
      result = 'Thứ năm';
    } else if (value == 'Friday') {
      result = 'Thứ sáu';
    } else if (value.contains('Saturday')) {
      result = 'Thứ bảy';
    } else if (value == 'Sunday') {
      result = 'Chủ nhật';
    }
    return result;
  }

  //check valid if in range of time
  bool checkValidTimeRange(dynamic timeCheck, int secondRange) {
    bool result = false;
    try {
      if (timeCheck != null) {
        DateTime timeInserted = DateTime.fromMicrosecondsSinceEpoch(
            timeCheck.microsecondsSinceEpoch);
        if (timeInserted
            .isAfter(DateTime.now().subtract(Duration(seconds: secondRange)))) {
          result = true;
        }
      }
    } catch (e) {
      LOG.error('Error at checkValidTimeRange: $e');
    }
    return result;
  }

  String formatBankDateFromInt(int time, bool isMultipleRow) {
    String result = '';
    try {
      if (time != 0) {
        DateTime timeConverted = DateTime.fromMillisecondsSinceEpoch(time);
        DateFormat format = (isMultipleRow)
            ? DateFormat('dd/MM/yyyy\nHH:mm')
            : DateFormat('dd/MM/yyyy HH:mm');
        result = format.format(timeConverted).toString();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  String formatDateFromInt(int time, bool isMultipleRow) {
    String result = '';
    try {
      if (time != 0) {
        DateTime timeConverted =
            DateTime.fromMillisecondsSinceEpoch(time * 1000);
        DateFormat format = (isMultipleRow)
            ? DateFormat('dd/MM/yyyy\nHH:mm')
            : DateFormat('dd/MM/yyyy HH:mm');
        result = format.format(timeConverted).toString();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  String formatTimeDateFromInt(int time) {
    String result = '';
    try {
      if (time != 0) {
        DateTime timeConverted =
            DateTime.fromMillisecondsSinceEpoch(time * 1000);
        DateFormat format = DateFormat('HH:mm dd/MM/yyyy');
        result = format.format(timeConverted).toString();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  String formatTimeNotification(int timeInMillis) {
    final now = DateTime.now();
    final time = DateTime.fromMillisecondsSinceEpoch(timeInMillis * 1000);

    final difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return 'vài giây trước';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes phút trước';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours giờ trước';
    } else if (difference.inDays <= 7) {
      return '${difference.inDays} ngày trước';
    } else {
      final formatter = DateFormat('HH:mm dd/MM/yyyy');
      final formattedTime = formatter.format(time);
      return formattedTime;
    }
  }

  String formatDateFromTimeStamp(dynamic timestamp, bool isMultipleRow) {
    String result = '';
    try {
      if (timestamp != null) {
        DateTime time = DateTime.fromMicrosecondsSinceEpoch(
            timestamp.microsecondsSinceEpoch);
        DateFormat format = (isMultipleRow)
            ? DateFormat('dd/MM/yyyy\nHH:mm')
            : DateFormat('dd/MM/yyyy HH:mm');
        result = format.format(time).toString();
      }
    } catch (e) {
      LOG.error('Error at formatDateFromTimeStamp: $e');
    }
    return result;
  }

  String formatDateFromTimeStamp2(dynamic timestamp, bool isMultipleRow) {
    String result = '';
    try {
      if (timestamp != null) {
        DateTime time = DateTime.fromMicrosecondsSinceEpoch(
            timestamp.microsecondsSinceEpoch);
        DateFormat format = (isMultipleRow)
            ? DateFormat('dd/MM/yyyy\nHH:mm')
            : DateFormat('HH:mm:ss dd/MM/yyyy');
        result = format.format(time).toString();
      }
    } catch (e) {
      LOG.error('Error at formatDateFromTimeStamp: $e');
    }
    return result;
  }

  String convertDateString(String dateString) {
    String day = dateString.substring(0, 2);
    String month = dateString.substring(2, 4);
    String year = dateString.substring(4, 8);
    return '$day/$month/$year';
  }
}
