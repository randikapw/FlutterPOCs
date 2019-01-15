import 'package:flutter/material.dart';
import 'dart:math';

void main(){
  runApp(DragListner());
}

class DragListner extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DragableTester',
      home: SwipableView(),
    );
  }
}

class SwipableView extends StatefulWidget {

  @override
  SwipableViewState createState() => SwipableViewState();
}

class SwipableViewState extends State<SwipableView> with TickerProviderStateMixin {

  SwipableViewState(){
    animationController = AnimationController(
        duration: Duration(milliseconds: 700),
        vsync: this);
    _animationFromLeft = animationController.drive(_drawerTweenLeft);
    _animationFromRight = animationController.drive(_drawerTweenRight);
    _currentAnimation = _animationFromRight;
  }

  String _message = 'New message';
  AnimationController animationController; //Always keep in mind to dispose this controller when disposing the widget

  static final Animatable<Offset> _drawerTweenLeft = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(1.0, 0.0)
  ).chain(CurveTween(
    curve: Curves.fastOutSlowIn,
  ));


  static final Animatable<Offset> _drawerTweenRight = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset.zero
  ).chain(CurveTween(
    curve: Curves.fastOutSlowIn,
  ));

  Animation<Offset> _animationFromLeft;
  Animation<Offset> _animationFromRight;
  Animation<Offset> _currentAnimation;


  void _updateMessage(String newMessage){
    setState(() {
      _message = newMessage;
    });
  }

  void _updateAnimation(Animation animation){
    setState(() {
      _currentAnimation = animation;
    });
    animationController.reset();
    animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return GestureDetector(
      onHorizontalDragUpdate: (DragUpdateDetails details){
        _updateMessage('Dragging' + details.delta.toString());
      },
      onHorizontalDragEnd: (DragEndDetails details){
        final double dxNorm = 1000; // Threshold which limit the swipe animation.
        final double swipngAngleNorm = 40; //in degrees.
        final double velocityX = details.velocity.pixelsPerSecond.dx / dxNorm;
        final double swipingAngle = (details.velocity.pixelsPerSecond.direction * 180 / pi).abs();

        if (velocityX > 1 && swipingAngle < swipngAngleNorm ){
          _updateAnimation(_animationFromLeft);
        } else if (velocityX < -1 && swipingAngle > 180 - swipngAngleNorm){
          _updateAnimation(_animationFromRight);
        }
        _updateMessage(
            'Drag finished derected to ' +
                (velocityX < 0 ? 'Left ' : 'Right ') + 'angle ' + swipingAngle.toString()
        );
      },
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.blue[100]
            ),
            child: Center(
              child: Text(_message),
            ),
          ),
          SlideTransition(
          position: _currentAnimation,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.blue[100]
            ),
            child: Center(
              child: Text(_message),
            ),
          ),
        ),
        ],
      ),


    );


  }

  @override
  void dispose() {
    animationController.dispose();
  }

}