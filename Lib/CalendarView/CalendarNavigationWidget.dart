import 'dart:math';

import 'package:flutter/material.dart';

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
  List<NavigationHeader> _headers = <NavigationHeader>[];
  final List<_ListItem> _listItems = <_ListItem>[];
  DateTime now;

  // Motion, Positioning, Animation related variables.
  double _scrollStartPosition;
  static const double
      _MaxNavigatorHeight = 100.0,
      _MinNavigatorHeight = 40.0,
      _MinNavigatorTop = -20.0,
      _MaxNavigatorTop = 25.0;

  double _currentNavigatorHeight = _MaxNavigatorHeight;
  double currentNavigatorTop = _MaxNavigatorTop;
  double _navigatorHorzontalDraginDiff;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();

    _headers.add(NavigationHeader(now.subtract(_weekDuration),currentNavigatorTop));
    _headers.add(NavigationHeader(now,currentNavigatorTop));
    _headers.add(NavigationHeader(now.add(_weekDuration),currentNavigatorTop));
    
    final double offset = 200.0;
    _headers[0].offsetHorizontally(-offset);
    _headers[2].offsetHorizontally(offset);


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
            NavigationHeader(now.add(_weekDuration),currentNavigatorTop);
        _headers = <NavigationHeader>[];
        _headers.add(newHeader);
        //_headers.removeAt(0);
      });
    } else {
      setState(() {
        NavigationHeader newHeader =
            NavigationHeader(now.subtract(_weekDuration),currentNavigatorTop);
        //_headers.insert(0,newHeader);
       // _headers.add(newHeader);
        _headers.removeLast();
      });
    }
  }

  void _onDragEnd(DragEndDetails details) {
    final double dxNorm = 1000; // Threshold which limit the swipe animation.
    final double swipngAngleNorm = 40; //in degrees.
    final double velocityX = details.velocity.pixelsPerSecond.dx / dxNorm;
    final double swipingAngle =
        (details.velocity.pixelsPerSecond.direction * 180 / pi).abs();

    if (velocityX > 1 && swipingAngle < swipngAngleNorm) {
      //_updateAnimation(_animationFromLeft);
      print('Swiped Left to Right');
      _changeWeekTo(now.subtract(_weekDuration));
    } else if (velocityX < -1 && swipingAngle > 180 - swipngAngleNorm) {
      //_updateAnimation(_animationFromRight);
      print('Swiped Right to Left');
      _changeWeekTo(now.add(_weekDuration));
    }
  }

  void _onDragUpdae(DragUpdateDetails d){
//              _headers[0].offsetHorizontally(d.primaryDelta);
//              _headers[1].offsetHorizontally(d.primaryDelta);
    _headers.last.offsetHorizontally(d.primaryDelta);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    print("Screen Width $screenWidth");
    return Column(children: <Widget>[
      // Start navigation header
      AnimatedSize(
        vsync: this,
        duration: Duration(milliseconds: 1000),
        child: Container(
          height: _currentNavigatorHeight,
          child:
          GestureDetector(
            onHorizontalDragEnd: _onDragEnd,
            onHorizontalDragUpdate: _onDragUpdae,
            child: Stack(
              children: _headers,
            ),
          ),
        ),
      ),
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
          onNotification: (ScrollNotification notification){
            if (notification is ScrollUpdateNotification) {
             // notification.metrics.axisDirection == AxisDirection.down
              double scrollDiff = (_scrollStartPosition - notification.metrics.pixels)/4;
              _scrollStartPosition = notification.metrics.pixels;
              print(notification.metrics.extentAfter);
              //if (notification.metrics.extentAfter < 10 && scrollDiff < 0) scrollDiff *= -2;
              double proposedNavigatorHeight = _currentNavigatorHeight + scrollDiff;
              double proposedNavigatorTop = currentNavigatorTop + scrollDiff;
              proposedNavigatorTop = proposedNavigatorTop < _MinNavigatorTop ? _MinNavigatorTop : proposedNavigatorTop;
              if (proposedNavigatorHeight <= _MaxNavigatorHeight && proposedNavigatorHeight >= _MinNavigatorHeight)
              setState(() {
                _currentNavigatorHeight = proposedNavigatorHeight;
                currentNavigatorTop = proposedNavigatorTop;
                int i = 1;
                for (NavigationHeader n in _headers){
                  print(i++);
                  n.setTop(currentNavigatorTop);
                }
                print('...');
              });
            } else if(notification is ScrollStartNotification){
              _scrollStartPosition = notification.metrics.pixels;
            }
            if(notification is ScrollEndNotification) {
              print("Scroll Endd");
            }
          },
        child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          reverse: false,
          itemBuilder: (_, int index) => _listItems[index],
          itemCount: _listItems.length,
        )),
      ),
    ]);
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
