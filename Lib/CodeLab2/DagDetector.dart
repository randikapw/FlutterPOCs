import 'package:flutter/material.dart';

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
      begin: Offset(-1.0, 0.0),
      end: Offset.zero
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
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return GestureDetector(
      onHorizontalDragUpdate: (DragUpdateDetails details){
        _updateMessage('Dragging' + details.delta.toString());
      },
      onHorizontalDragEnd: (DragEndDetails details){
        final double velocityNorm = 500; // Threshold which limit the swipe animation.
        final double velocityX = details.primaryVelocity / velocityNorm;
        if (velocityX > 1){
          _updateAnimation(_animationFromLeft);
        } else if (velocityX < -1){
          _updateAnimation(_animationFromRight);
        }
        _updateMessage('Drag finished derected to ' + (velocityX < 0 ? 'Left ' : 'Right ') + velocityX.toString());
      },
      child: SlideTransition(
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

    );


  }

  @override
  void dispose() {
    animationController.dispose();
  }

}