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
    animationFromLeft = animationController.drive(_drawerTeweenLeft);
    animationFromRigh = animationController.drive(_drawerTeweenRight);
    currentAnimation = animationFromRigh;
  }

  String _message = 'New message';
  AnimationController animationController; //Always keep in mind to dispose this controller when disposing the widget
  final sliderKey = GlobalKey();
  static final Animatable<Offset> _drawerTeweenLeft = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset.zero
  ).chain(CurveTween(
    curve: Curves.fastOutSlowIn,
  ));


  static final Animatable<Offset> _drawerTeweenRight = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset.zero
  ).chain(CurveTween(
    curve: Curves.fastOutSlowIn,
  ));

  Animation<Offset> animationFromLeft;
  Animation<Offset> animationFromRigh;
  Animation<Offset> currentAnimation;


  void _updateMessage(String newMessage){
    setState(() {
      _message = newMessage;
    });
  }

  void _updateAnimation(Animation animation){
    setState(() {
      currentAnimation = animation;
    });
  }

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return GestureDetector(
      onHorizontalDragUpdate: (DragUpdateDetails details){
        _updateMessage('Dragging' + details.delta.toString());
      },
      onHorizontalDragEnd: (DragEndDetails details){
        final double velocityX = details.primaryVelocity;
        if (velocityX > 0){
          _updateAnimation(animationFromLeft);
          animationController.reset();
          animationController.forward();
        } else {
          _updateAnimation(animationFromRigh);
          animationController.reset();
          animationController.reverse();
        }
        _updateMessage('Drag finished derected to ' + (velocityX < 0 ? 'Left' : 'Right'));
      },
      child: SlideTransition(
          key: sliderKey,
          position: currentAnimation,
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