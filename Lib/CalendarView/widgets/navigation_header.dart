import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../CalendarNavigationWidget.dart';
import 'date_cell.dart';

class NavigationHeader extends StatefulWidget {

  DateTime currentDate;
  double _possitonTop,_possitionLeft = 0.0;
  NavigationHeaderState _state;

  NavigationHeader(this.currentDate,this._possitonTop);

  @override
  State createState() {
    _state = NavigationHeaderState(this.currentDate,);
    return _state;
  }

  void setTop(double top) {
    if(_state != null && _state.mounted) {
      _state.setState(() {
        _possitonTop = top;
      });
    }
  }



  void offsetHorizontally(double diff) {
    if(_state != null && _state.mounted) {

      _state.setState(() {
        _possitionLeft += diff;
      });
    } else {
      print("Warning!!!");
      _possitionLeft += diff;
    }
  }
}

class NavigationHeaderState extends State<NavigationHeader> {
  /// Constructor.
  NavigationHeaderState(this.currentDate) {
    currentYear = currentDate.year.toString();
    currentMonth = DateFormat.MMMM().format(currentDate);
    _generateCurrentShowingWeek();
  }


  ///Fields
  DateTime currentDate;
  List<DateCell> currentShowingWeek;
  String currentYear, currentMonth;

  void _generateCurrentShowingWeek() {
    currentShowingWeek = <DateCell>[];
    int nowWeekDay = currentDate.weekday;
    DateTime weekStartDate; //Monday.
    if (nowWeekDay == 1) {
      weekStartDate = currentDate;
    } else {
      Duration duration = Duration(days: nowWeekDay - 1);
      weekStartDate =
          currentDate.subtract(duration); //Monday of the current week.
    }
    //Adding first day to List
    currentShowingWeek.add(DateCell(date: weekStartDate));
    //Adding rest of six days to List
    for (var i = 1; i < 7; i++) {
      currentShowingWeek
          .add(DateCell(date: weekStartDate.add(Duration(days: i))));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Generate month view and navigation buttons.
    final Widget monthInfo = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          currentYear + ', ',
          style: Theme.of(context).textTheme.title,
        ),
        Text(
          currentMonth,
          style: Theme.of(context).textTheme.title,
        ),
      ],
    );
    // Generate week view and navigation buttons.
    final Widget weekInfo = Row(
      children: currentShowingWeek,
    );

    // Return above generated widgets arranging in a column.
    return
      AnimatedPositioned(
        top: widget._possitonTop,
        left: widget._possitionLeft,
        width: MediaQuery.of(context).size.width,
        duration: Duration(milliseconds: 1),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          child: Column(
            children: <Widget>[monthInfo, weekInfo],
          ),
        ),
      );
  }
}
