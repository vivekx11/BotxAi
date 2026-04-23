// date utils upadte 

import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();
  
  static String formatMessageTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return DateFormat('HH:mm').format(dateTime);
    } else if (difference.inDays < 7) {
      return DateFormat('EEE HH:mm').format(dateTime);
    } else {
      return DateFormat('MMM dd, HH:mm').format(dateTime);
    }
  }
  
  static String formatFullDate(DateTime dateTime) {
    return DateFormat('MMMM dd, yyyy').format(dateTime);
  }
  
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }
  
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy HH:mm').format(dateTime);
  }
  
  static String getCurrentTime() {
    return DateFormat('HH:mm').format(DateTime.now());
  }
  
  static String getCurrentDate() {
    return DateFormat('EEEE, MMMM dd, yyyy').format(DateTime.now());
  }
  
  static String getCurrentDay() {
    return DateFormat('EEEE').format(DateTime.now());
  }
  
  static String respondToTimeQuery() {
    final now = DateTime.now();
    final time = DateFormat('HH:mm').format(now);
    final period = now.hour < 12 ? 'morning' : now.hour < 17 ? 'afternoon' : 'evening';
    return 'It\'s $time in the $period.';
  }
  
  static String respondToDateQuery() {
    final date = getCurrentDate();
    return 'Today is $date.';
  }
  
  static String respondToDayQuery() {
    final day = getCurrentDay();
    return 'Today is $day.';
  }
  
  static bool isToday(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }
  
  static bool isYesterday(DateTime dateTime) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day;
  }
  
  static String getRelativeDate(DateTime dateTime) {
    if (isToday(dateTime)) {
      return 'Today';
    } else if (isYesterday(dateTime)) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM dd').format(dateTime);
    }
  }
  
  static String formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds.remainder(60)}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}
