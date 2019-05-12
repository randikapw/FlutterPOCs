import 'package:flutter/material.dart';

class SwipeContainer extends StatelessWidget {

  SwipeContainer({
    @required this.child,
    this.onSwipeLeft,
    this.onSwipeRight,
  });

  final Widget child;
  final Function(String,int) onSwipeLeft, onSwipeRight;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: _onHDragEnd,
      child: Stack(
       children: <Widget>[
         AnimatedPositioned(
             left: 100,
             width: 100,
             height: 200,
             child: this.child,
             duration: Duration(
               seconds: 1,
             )
         )
       ],
      )
    );
  }

  _onHDragEnd(DragEndDetails details) {
    print(details.toString());
  }



}