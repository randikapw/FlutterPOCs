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

class CalendarNavState extends State<CalendarNav> with TickerProviderStateMixin{

  static const Duration _weekDuration = Duration(days: 7);
  DateTime now;
  final List<_NavigationHeader> _headers = <_NavigationHeader>[];

  ///ANIMATION RELATED DATA
  AnimationController animationController; //Always keep in mind to dispose this controller when disposing the widget

  static final Animatable<Offset> _tweenLeaveFromLeft = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-1.0, 0.0)
  ).chain(CurveTween(
    curve: Curves.easeIn,
  ));

  static final Animatable<Offset> _tweenLeaveFromRight = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(1.0, 0.0)
  ).chain(CurveTween(
    curve: Curves.easeIn,
  ));

  static final Animatable<Offset> _tweenEnterFromRight = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset.zero
  ).chain(CurveTween(
    curve: Curves.easeIn,
  ));

  static final Animatable<Offset> _tweenEnterFromLeft = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset.zero
  ).chain(CurveTween(
    curve: Curves.easeIn,
  ));
  

  Animation<Offset> _animationLeaveFromLeft;
  Animation<Offset> _animationLeaveFromRight;
  Animation<Offset> _animationEnterFromLeft;
  Animation<Offset> _animationEnterFromRight;
  Animation<Offset> _currentAnimation;
  Animation<Offset> _stay;



  @override
  void dispose() {
    animationController.dispose();
  }

  @override
  void initState() {
    super.initState();
    now = DateTime.now();

    animationController = AnimationController(
        duration: Duration(milliseconds: 700),
        vsync: this);
    _animationLeaveFromLeft = animationController.drive(_tweenLeaveFromLeft);
    _animationLeaveFromRight = animationController.drive(_tweenLeaveFromRight);
    _animationEnterFromLeft = animationController.drive(_tweenEnterFromLeft);
    _animationEnterFromRight = animationController.drive(_tweenEnterFromRight);
    _currentAnimation = _animationEnterFromRight;
    _stay = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(animationController);

    _headers.add(_NavigationHeader(now,_stay));
  }

  //Animation status listners
  void _onLeftToRightAnimationCompleted(AnimationStatus status){
    if (AnimationStatus.completed == status) {
      animationController.removeStatusListener(
          _onLeftToRightAnimationCompleted);
      if (_headers.length > 1) {
        _headers.removeLast();
      }
    }
  }


  void _onRightToLeftAnimationCompleted(AnimationStatus status){
    if (AnimationStatus.completed == status) {
        print('Animation completed.');
        animationController.removeStatusListener(_onRightToLeftAnimationCompleted);
        _headers.removeAt(0);
    }
  }

  void _changeWeekTo(DateTime newDate){
    int dayDiff = newDate.difference(now).inDays;
    now = newDate;
    print(dayDiff);
    if (dayDiff == 0){
      return;
    } else if (dayDiff > 0) {
      setState(() {
        _NavigationHeader newHeader = _NavigationHeader(
            newDate, _animationEnterFromRight);
        _headers.add(newHeader);
        _headers.first._currentAnimation = _animationLeaveFromLeft;
        animationController.reset();
        animationController.forward();
        animationController.addStatusListener(_onRightToLeftAnimationCompleted);
      });
    } else {
      setState(() {
        _NavigationHeader newHeader = _NavigationHeader(
            newDate, _animationEnterFromLeft);
        _headers.add(newHeader);
        _headers.first._currentAnimation = _animationLeaveFromRight;
        animationController.reset();
        animationController.forward();
        animationController.addStatusListener(_onLeftToRightAnimationCompleted);
      }
      );
    }
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
      child: Stack(
        children: _headers,
      ),
    );

  }


}


class _NavigationHeader extends StatelessWidget {
  /// Constructor.
  _NavigationHeader(this.currentDate,this._currentAnimation){
    _generateCurrentShowingWeek();
    currentYear = currentDate.year.toString();
    currentMonth = DateFormat.MMMM().format(currentDate);
  }

  ///Fields
  DateTime currentDate;
  List<_WeekDay> currentShowingWeek;
  Animation<Offset> _currentAnimation;
  String currentYear,currentMonth;

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
        Text(currentYear + ', ', style: Theme.of(context).textTheme.title,),
        Text(currentMonth, style: Theme.of(context).textTheme.title,),
      ],
    );
    // Generate week view and navigation buttons.
    final Widget weekInfo = Row(
      children: currentShowingWeek,
    );

    // Return above generated widgets arranging in a column.
    return SlideTransition(
      position: _currentAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          children: <Widget>[
            monthInfo,
            weekInfo
          ],
        ),
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