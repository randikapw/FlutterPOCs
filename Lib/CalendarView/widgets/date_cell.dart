import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateCell extends StatelessWidget {
  DateCell({this.date})
      :
        // Initializing final variables.
        dayOfMonth = DateCell._generateDayOfMonth(date),
        dayOfWeek = DateFormat('EEE').format(date).toUpperCase();

  final DateTime date;
  final String dayOfWeek;
  final String dayOfMonth;

  /// Static method to decorate day of month with zero if needed.
  static String _generateDayOfMonth(DateTime date) {
    int day = date.day;
    return (day > 9 ? day.toString() : '0' + day.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(
            dayOfWeek,
            style: Theme.of(context).textTheme.body1,
          ),
          Text(
            dayOfMonth,
            style: Theme.of(context).textTheme.body1,
          ),
        ],
      ),
    );
  }
}
