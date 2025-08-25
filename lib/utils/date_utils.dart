class DateUtils {
  static DateTimeToString({required DateTime dateTIme}) {
    return '${dateTIme.year}-${padInteger(number: dateTIme.month)}-${padInteger(number: dateTIme.day)} ${padInteger(number: dateTIme.hour)}:00';
  }

  static String padInteger({required int number}) {
    return number.toString().padLeft(2, '0');
  }
}
