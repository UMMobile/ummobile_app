import 'package:intl/intl.dart';

/// Formats the [date] given to dd-MMM-yyyy string
///
/// ```
/// ddmmYYYY(DateTime.utc(1944, 6, 6)) = "06-06-1944"
/// ```
String ddmmYYYY(DateTime date) =>
    DateFormat('dd-MMM-yyyy').format(date).toString();

/// Parses the [strDate] given to a DateTime object
///
/// [strDate] must be in dd/MM/yyyy format
///
/// ```
/// ddMMyyyyFormat("06/06/1944") = DateTime.utc(1944, 6, 6)
/// ```
DateTime ddMMyyyyFormat(String strDate) =>
    DateFormat('dd/MM/yyyy').parse(strDate);
