class DateFormatter {
  static const List<String> _months = [
    'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
    'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
  ];

  /// Formatea una fecha a formato legible en español
  /// Ejemplo: 15 de marzo de 2005
  static String formatDateToSpanish(DateTime date) {
    return '${date.day} de ${_months[date.month - 1]} de ${date.year}';
  }

  /// Formatea una fecha con la edad incluida
  /// Ejemplo: 15 de marzo de 2005 (19 años)
  static String formatDateWithAge(DateTime birthDate) {
    final age = calculateAge(birthDate);
    return '${formatDateToSpanish(birthDate)} ($age años)';
  }

  /// Calcula la edad basada en la fecha de nacimiento
  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || 
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  /// Formatea una fecha a formato corto
  /// Ejemplo: 15/03/2005
  static String formatDateShort(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
           '${date.month.toString().padLeft(2, '0')}/'
           '${date.year}';
  }

  /// Formatea fecha y hora
  /// Ejemplo: 15 de marzo de 2005 - 14:30
  static String formatDateTimeToSpanish(DateTime dateTime) {
    final dateStr = formatDateToSpanish(dateTime);
    final timeStr = '${dateTime.hour.toString().padLeft(2, '0')}:'
                   '${dateTime.minute.toString().padLeft(2, '0')}';
    return '$dateStr - $timeStr';
  }

  /// Calcula los días transcurridos desde una fecha
  static int daysSince(DateTime date) {
    final now = DateTime.now();
    return now.difference(date).inDays;
  }

  /// Formatea el tiempo transcurrido de manera legible
  /// Ejemplo: "hace 7 días", "hace 2 semanas", "hace 3 meses"
  static String formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return difference.inMinutes <= 1 ? 'hace un momento' : 'hace ${difference.inMinutes} minutos';
      }
      return difference.inHours == 1 ? 'hace una hora' : 'hace ${difference.inHours} horas';
    } else if (difference.inDays == 1) {
      return 'ayer';
    } else if (difference.inDays < 7) {
      return 'hace ${difference.inDays} días';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return weeks == 1 ? 'hace una semana' : 'hace $weeks semanas';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? 'hace un mes' : 'hace $months meses';
    } else {
      final years = (difference.inDays / 365).floor();
      return years == 1 ? 'hace un año' : 'hace $years años';
    }
  }
}