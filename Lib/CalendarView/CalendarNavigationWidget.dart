import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';

import 'bloc/bloc.dart';
import 'bloc/provider.dart';
import 'widgets/navigation_header.dart';

void main() {
  runApp(Application());
}

/// This is the application context.
class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar Navigation',
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Calendar',
            style: Theme.of(context).textTheme.title,
          ),
        ),
        body: CalendarNav(),
      ),
    );
  }
}

class CalendarNav extends StatefulWidget {
  @override
  CalendarNavState createState() => CalendarNavState();
}

class CalendarNavState extends State<CalendarNav>
    with TickerProviderStateMixin {


  static const Duration _weekDuration = Duration(days: 7);

  final Bloc bloc = Bloc();
  List<NavigationHeader> _headers = <NavigationHeader>[];
  final List<_ListItem> _listItems = <_ListItem>[];
  DateTime now;

  // Motion, Positioning, Animation related variables.
  double _scrollStartPosition,_hDragOffset = 0,_screenWidth;


  double _currentNavigatorHeight;
  double currentNavigatorTop = Bloc.MaxNavigatorTop;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();

    // Initiate listener for update currentHeight.
    bloc.navHeaderConfigs.listen((NavHeaderPosition newPosition) { _currentNavigatorHeight = newPosition.height;});

    _headers.add(NavigationHeader(now.subtract(_weekDuration)));
    _headers.add(NavigationHeader(now));
    _headers.add(NavigationHeader(now.add(_weekDuration)));
    _headers.first.index = -1;
    _headers.last.index = 1;


    for (int i = 0; i < 20; i++) {
      _listItems.add(_ListItem());
    }
  }

  void _changeWeekTo(DateTime newDate) {
    int dayDiff = newDate.difference(now).inDays;
    now = newDate;
    print(dayDiff);
    if (dayDiff == 0) {
      return;
    } else if (dayDiff > 0) { //TODO: this logic should change when date can be selected from date picker.
      setState(() {
        NavigationHeader newHeader =
            NavigationHeader(now.add(_weekDuration));
        _headers.add(newHeader);
        _headers.removeAt(0);
      });
    } else {
      setState(() {
        NavigationHeader newHeader =
            NavigationHeader(now.subtract(_weekDuration));
        _headers.insert(0,newHeader);
        _headers.removeLast();
      });
    }
    _headers.first.index = -1;
    _headers.elementAt(1).index = 0;
    _headers.last.index = 1;
  }

  void _onDragEnd(DragEndDetails details) {
    final double dxNorm = 1000; // Threshold which limit the swipe animation.
    final double swipngAngleNorm = 40; //in degrees.
    final double velocityX = details.velocity.pixelsPerSecond.dx / dxNorm;
    final double swipingAngle =
        (details.velocity.pixelsPerSecond.direction * 180 / pi).abs();

    final double absVelocityX = velocityX.abs();
    if (absVelocityX > 1) {
      DateTime newDate;
      if (velocityX > 1 && swipingAngle < swipngAngleNorm) {
        print('Swiped Left to Right');
        newDate = now.subtract(_weekDuration);
        _hDragOffset = _screenWidth;
      } else if (velocityX < -1 && swipingAngle > 180 - swipngAngleNorm) {
        print('Swiped Right to Left');
        newDate = now.add(_weekDuration);
        _hDragOffset = -_screenWidth;
      }
      print("Norm velocity : ${velocityX.abs()}");
      Duration d = Duration(milliseconds: (800 / absVelocityX).round());
      Timer(d,(){
        _changeWeekTo(newDate);
        bloc.setNavHeaderHoffsetWithDuration(_hDragOffset = 0, Duration(milliseconds: 10));
      });
      bloc.setNavHeaderHoffsetWithDuration(_hDragOffset, d);
    } else {
      // Drag end speed is not enough for navigate across weeks.
      Duration d = Duration(milliseconds: (500 * _hDragOffset.abs()/_screenWidth).round());
      Timer(d,(){
        bloc.setNavHeaderHoffsetWithDuration(_hDragOffset = 0, Duration(milliseconds: 10));
      });
      bloc.setNavHeaderHoffsetWithDuration(_hDragOffset = 0, d);
    }
  }

  void _onDragUpdae(DragUpdateDetails d){
        bloc.navHeaderSetHorizontalOffset(_hDragOffset += d.primaryDelta);
//              _headers[0].offsetHorizontally(d.primaryDelta);
//              _headers[1].offsetHorizontally(d.primaryDelta);
//    _headers.last.offsetHorizontally(d.primaryDelta);
  }

  bool _onScrollNotification (ScrollNotification notification){
    if (notification is ScrollUpdateNotification) {
      // notification.metrics.axisDirection == AxisDirection.down
      double scrollDiff = (_scrollStartPosition - notification.metrics.pixels)/4;
      _scrollStartPosition = notification.metrics.pixels;
      print(notification.metrics.extentAfter);
      //if (notification.metrics.extentAfter < 10 && scrollDiff < 0) scrollDiff *= -2;
      double proposedNavigatorHeight = _currentNavigatorHeight + scrollDiff;
      double proposedNavigatorTop = currentNavigatorTop + scrollDiff;
      proposedNavigatorTop = proposedNavigatorTop < Bloc.MinNavigatorTop ? Bloc.MinNavigatorTop : proposedNavigatorTop;
      if (proposedNavigatorHeight <= Bloc.MaxNavigatorHeight && proposedNavigatorHeight >= Bloc.MinNavigatorHeight)
        setState(() {
//          _currentNavigatorHeight = proposedNavigatorHeight;
        bloc.navHeaderSetSize(proposedNavigatorHeight);
          currentNavigatorTop = proposedNavigatorTop;
        });
    } else if(notification is ScrollStartNotification){
      _scrollStartPosition = notification.metrics.pixels;
    }
    if(notification is ScrollEndNotification) {
      print("Scroll End");
    }
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;

    Provider provider = Provider(bloc, child:
      Column(children: <Widget>[
      // Start navigation header
        StreamBuilder<NavHeaderPosition>(
            initialData: bloc.currentNavHeaderPosition,
            stream: bloc.navHeaderConfigs,
            builder: (context, snapshot) {
          return  AnimatedSize(
            vsync: this,
            duration: Duration(milliseconds: 10),
            child: Container(
              height: snapshot.data.height,
              child:
              GestureDetector(
                onHorizontalDragUpdate: _onDragUpdae,
                onHorizontalDragEnd: _onDragEnd,
                child: Stack(
                  children: _headers,
                ),
              ),
            ),
          );
    }),
      // End navigation header..
      Divider(
        height: 1.0,
      ),
      RaisedButton(
        child: Text('Remove it'),
        onPressed: (){
          setState(() {
            var t = _headers.last;
            _headers.removeLast();
            _headers.removeLast();
            _headers.add(t);
          });
        },
      ),
      // Expanding rest of the space using Flexible.
      Flexible(
        // Wrapping the list with notification listener.
        child: NotificationListener<ScrollNotification>(
          onNotification: _onScrollNotification,
        child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          reverse: false,
          itemBuilder: (_, int index) => _listItems[index],
          itemCount: _listItems.length,
        )),
      ),
    ])
    );
    if (_currentNavigatorHeight == null) {
      bloc.navHeaderSetSize(Bloc.MaxNavigatorHeight);
    }
    return provider;
  }
}



class _ListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Main Titile',
                style: Theme.of(context).textTheme.subhead,
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Text('Sub Titile'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
