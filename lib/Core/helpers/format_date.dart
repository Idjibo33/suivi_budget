String formateDate(DateTime date) {
  final day = date.day;
  final month = date.month;
  final year = date.year;
  final hour = date.hour;
  final minute = date.minute;
  final formattedDate = "$day/$month/$year à $hour:$minute";
  return formattedDate;
}
