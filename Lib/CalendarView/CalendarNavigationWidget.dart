import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main(){
  runApp(Application());
}

/// This is the application context.
class Application extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar Navigation',
      home: Scaffold(
        appBar: AppBar(title: Text('Calendar', style: Theme.of(context).textTheme.title,),),
        body: CalendarNav(),
      ),

    );
  }
}

class CalendarNav extends StatefulWidget {

  @override
  CalendarNavState createState() => CalendarNavState();
}

class CalendarNavState extends State<CalendarNav> {

  DateTime now;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return _NavigationHeader(now);
  }


}


class _NavigationHeader extends StatelessWidget {
  /// Constructor.
  _NavigationHeader(this.currentDate){
    _generateCurrentShowingWeek();
  }

  ///Fields
  DateTime currentDate;
  List<_WeekDay> currentShowingWeek;

  void _generateCurrentShowingWeek(){
    currentShowingWeek = <_WeekDay>[];
    int nowWeekDay = currentDate.weekday;
    DateTime weekStartDate; //Monday.
    if (nowWeekDay == 1){
      weekStartDate = currentDate;
    } else {
      Duration duration = Duration(days: nowWeekDay - 1);
      weekStartDate = currentDate.subtract(duration); //Monday of the current week.
    }
    //Adding first day to List
    currentShowingWeek.add(_WeekDay(date:weekStartDate));
    //Adding rest of six days to List
    for(var i = 1; i < 7; i++){
      currentShowingWeek.add(_WeekDay(date:weekStartDate.add(Duration(days: i))));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Generate month view and navigation buttons.
    final Widget monthInfo = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('2019, ', style: Theme.of(context).textTheme.title,),
        Text('Januray', style: Theme.of(context).textTheme.title,),
      ],
    );
    // Generate week view and navigation buttons.
    final Widget weekInfo = Row(
      children: currentShowingWeek,
    );

    // Return above generated widgets arranging in a column.
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        children: <Widget>[
          monthInfo,
          weekInfo
        ],
      ),
    );
  }

}

class _WeekDay extends StatelessWidget {

  _WeekDay({this.date}):
      // Initializing final variables.
      dayOfMonth = _WeekDay._generateDayOfMonth(date),
      dayOfWeek = DateFormat('EEE').format(date).toUpperCase();

  final DateTime date;
  final String dayOfWeek;
  final String dayOfMonth;
  Function x = (){};
  /// Static method to decorate day of month with zero if needed.
  static String _generateDayOfMonth(DateTime date){
    int day = date.day;
    return (day > 9 ? day.toString() : '0' + day.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(dayOfWeek, style: Theme.of(context).textTheme.body1,),
          Text(dayOfMonth, style: Theme.of(context).textTheme.body1,),
        ],
      ),
    );
  }

}