String humanDate(String date) {
  final DateTime dateTime = DateTime.parse(date);
  final String day = dateTime.day.toString().padLeft(2, '0');
  final String month = dateTime.month.toString().padLeft(2, '0');
  final String year = dateTime.year.toString();
  final String hour = dateTime.hour.toString().padLeft(2, '0');
  final String minute = dateTime.minute.toString().padLeft(2, '0');
  return 'Agendado: $day/$month/$year às $hour:$minute';
}

int convertDateToMinutes(String date) {
  final DateTime dateTime = DateTime.parse(date);
  final DateTime now = DateTime.now();
  final int difference = dateTime.difference(now).inMinutes;
  //trate se diferenca for negativa
  if (difference < 0) {
    return 0;
  }
  return difference;
}

int convertDateToHours(String date) {
  final DateTime dateTime = DateTime.parse(date);
  final DateTime now = DateTime.now();
  final int difference = dateTime.difference(now).inHours;
  return difference;
}

int convertDateToDays(String date) {
  final DateTime dateTime = DateTime.parse(date);
  final DateTime now = DateTime.now();
  final int difference = dateTime.difference(now).inDays;
  return difference;
}

int convertDateToWeeks(String date) {
  final DateTime dateTime = DateTime.parse(date);
  final DateTime now = DateTime.now();
  final int difference = dateTime.difference(now).inDays;
  return difference ~/ 7;
}

int convertDateToMonths(String date) {
  final DateTime dateTime = DateTime.parse(date);
  final DateTime now = DateTime.now();
  final int difference = dateTime.difference(now).inDays;
  return difference ~/ 30;
}

//funcao para converter a data para varios formatos dependendo do tempo, exemplo: 1 dia, 2 horas, 3 minutos etc

String convertDate(String date) {
  final int minutes = convertDateToMinutes(date);
  final int hours = convertDateToHours(date);
  final int days = convertDateToDays(date);
  final int weeks = convertDateToWeeks(date);
  final int months = convertDateToMonths(date);

  if (minutes < 60) {
    return '$minutes minutos';
  } else if (hours < 24) {
    return '$hours horas';
  } else if (days < 7) {
    return '$days dias';
  } else if (weeks < 4) {
    return '$weeks semanas';
  } else {
    return '$months meses';
  }
}
