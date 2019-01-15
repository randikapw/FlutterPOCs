import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

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
  _NavigationHeader header;
  static const Duration _weekDuration = Duration(days: 7);

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    header = _NavigationHeader(now);
  }

  void _changeWeekTo(DateTime newDate){
    now = newDate;
    setState(() {
      header = _NavigationHeader(newDate);
    });
  }

  void _onDragEnd(DragEndDetails details){
    final double dxNorm = 1000; // Threshold which limit the swipe animation.
    final double swipngAngleNorm = 40; //in degrees.
    final double velocityX = details.velocity.pixelsPerSecond.dx / dxNorm;
    final double swipingAngle = (details.velocity.pixelsPerSecond.direction * 180 / pi).abs();

    if (velocityX > 1 && swipingAngle < swipngAngleNorm ){
      //_updateAnimation(_animationFromLeft);
      print('Swiped Left to Right');
      _changeWeekTo(now.subtract(_weekDuration));
    } else if (velocityX < -1 && swipingAngle > 180 - swipngAngleNorm){
      //_updateAnimation(_animationFromRight);
      print('Swiped Right to Left');
      _changeWeekTo(now.add(_weekDuration));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: _onDragEnd,
      child: header,
    );

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