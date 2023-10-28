import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String get getStartDate {
    DateFormat transactionDateFormat = DateFormat('dd MMM', 'vi_VN');
    return transactionDateFormat.format(this);
  }

  String get getEndDate {
    DateFormat transactionDateFormat = DateFormat('dd MMM yyyy', 'vi_VN');
    return transactionDateFormat.format(this);
  }
}
