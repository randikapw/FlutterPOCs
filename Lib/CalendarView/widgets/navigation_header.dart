import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'date_cell.dart';
import '../bloc/bloc.dart';
import '../bloc/provider.dart';

class NavigationHeader extends StatelessWidget {

  DateTime currentDate;
  int index = 0;

  NavigationHeader(this.currentDate){
    currentYear = currentDate.year.toString();
    currentMonth = DateFormat.MMMM().format(currentDate);
    _generateCurrentShowingWeek();
  }

  ///Fields
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

//  double _getPositionFromOffset(double newOffset, BuildContext context){
//    return  _possitionLeft = (index * MediaQuery.of(context).size.width + snapshot.data.horizontalOffset
//  }

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
      StreamBuilder<NavHeaderPosition>(
          initialData: Provider.of(context).currentNavHeaderPosition,
          stream: Provider.of(context).navHeaderConfigs,
          builder: (context,snapshot){
            return AnimatedPositioned(
              bottom: 0.0,
//              top: snapshot.data,
//              left: snapshot.hasData ? index * MediaQuery.of(context).size.width + (_possitionLeft += snapshot.data.horizontalOffset) : 0.0,
              left: index * MediaQuery.of(context).size.width + snapshot.data.horizontalOffset,
              width: MediaQuery.of(context).size.width,
              duration: snapshot.data.animationDuration,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                ),
                child: Column(
                  children: <Widget>[monthInfo, weekInfo],
                ),
              ),
            );
          });

  }
}
