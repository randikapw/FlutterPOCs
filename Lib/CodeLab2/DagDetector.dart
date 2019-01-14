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

class SwipableViewState extends State<SwipableView> {

  String _message = 'New message';

  void _updateMessage(String newMessage){
    setState(() {
      _message = newMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (DragUpdateDetails details){
        _updateMessage('Dragging' + details.delta.toString());
      },
      onHorizontalDragEnd: (DragEndDetails details){
        final double velocityX = details.primaryVelocity;

        _updateMessage('Drag finished derected to ' + (velocityX < 0 ? 'Left' : 'Right'));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[100]
        ),
        child: Center(
          child: Text(_message),
        ),
      ),
    );
  }
}