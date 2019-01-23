import 'package:flutter/material.dart';
import 'dart:async';

void main(){
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget{
  @override
  MyAppState createState() {
    return MyAppState();
  }

}

class MyAppState extends State<MyApp> with TickerProviderStateMixin {
  double _height = 50.0;
  double _width = 20.0;
  var _color = Colors.blue;

  //Dragable IconButton Configs.
  Duration _duration = Duration(microseconds: 500);
  double _bottom = 10.0, _right = 10.0;
  Curve _curve = Curves.linear;
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new AnimatedSize(
                curve: Curves.fastOutSlowIn, child: new Container(
                width: _width,
                height: _height,
                color: _color,
              ), vsync: this, duration: new Duration(seconds: 2),),
              new Divider(height: 35.0,),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new IconButton(
                      icon: new Icon(Icons.arrow_upward, color: Colors.green,),
                      onPressed: () =>
                          setState(() {
                            _color = Colors.green;
                            _height = 95.0;
                          })),
                  new IconButton(
                      icon: new Icon(Icons.arrow_forward, color: Colors.red,),
                      onPressed: () =>
                          setState(() {
                            _color = Colors.red;
                            _width = 45.0;
                          })),
                ],
              ),

              Expanded(
                child: GestureDetector(
                  child: Stack(
                    children: <Widget>[
                      AnimatedPositioned(
                        bottom: _bottom,
                        right: _right,
                        child: IconButton(icon: Icon(Icons.add), onPressed: (){
                          setState(() {
                            // _bottom += 100;
                          });
                          print('Ha Ha');
                        }),
                        duration: _duration,
                        curve: _curve,
                      ),
                    ],
                  ),
                  onHorizontalDragUpdate: (DragUpdateDetails details){
                    //print(details.delta.dx);
                    setState(() {
                      _bottom -= 2 * details.delta.dx;
                    });
                  },
                  onHorizontalDragEnd: (DragEndDetails ded){
                    double diff = _bottom - 10;
                    print(diff);
                    setState(() {
                      // Set dynamic animation duration aligning to the value of diff.
                      int newDuration = (diff * 10).round();
                      _duration = Duration(milliseconds: newDuration);
                      _curve = Curves.bounceOut;
                      _bottom = 10;
                    });
                    Timer(_duration, (){
                      _duration = Duration(milliseconds: 100);
                      _curve = Curves.linear;
                    });
                  },
                ),

              ),
            ],

          )
          ,)
    );
  }
}