import 'package:intl/intl.dart';

String ddmmYYYY(DateTime date) =>
    DateFormat('dd-MMM-yyyy').format(date).toString();

DateTime ddMMyyyyFormat(String strDate) =>
    DateFormat('dd/MM/yyyy').parse(strDate);

String toAcademicBoolean(bool? boolean) => noNullOrFalse(boolean) ? 'S' : 'N';

bool fromAcademicBoolean(String? item) =>
    noNullOrEmpty(item) && item == 'S' ? true : false;

bool noNullOrEmpty(String? text) => text != null && text.isNotEmpty;

bool noNullOrFalse(bool? boolean) => boolean != null && boolean;
