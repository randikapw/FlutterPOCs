import 'package:flutter/material.dart';

class SwipeContainer extends StatefulWidget {
  SwipeContainer({
    @required this.child,
    this.onSwipeLeft,
    this.onSwipeRight,
  });

  final Widget Function() child;
  final bool Function(String, int) onSwipeLeft, onSwipeRight;

  @override
  State<SwipeContainer> createState() {
    return SwipeContainerState();
  }
}

class SwipeContainerState extends State<SwipeContainer>
    with SingleTickerProviderStateMixin {

  static final Animatable<Offset> _tweenLeft = Tween<Offset>(
    begin: const Offset( -1,0.0),
    end: Offset.zero,
  );

  static final Animatable<Offset> _tweenRight = Tween<Offset>(
    begin: const Offset( 1,0.0),
    end: Offset.zero,
  );



  static final Animatable<Offset> _tweenInit = Tween<Offset>(
    begin: const Offset(0.0,1),
    end: Offset.zero,
  );

  AnimationController aController;
  Animation<Offset> _possitionCurrent,_possitionFromLeft,_possitionFromRight;

  @override
  void initState() {
    super.initState();
    aController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _possitionFromRight = aController.drive(_tweenRight);
    _possitionFromLeft = aController.drive(_tweenLeft);
    _possitionCurrent = aController.drive(_tweenInit);
  }

  @override
  Widget build(BuildContext context) {
    aController.forward();
    return SlideTransition(
      position: _possitionCurrent,
        child: GestureDetector(
            onHorizontalDragEnd: _onHDragEnd,
            child: widget.child()
        )
    );
  }

  _onHDragEnd(DragEndDetails details) {
    print(details.toString());

    setState(() {
      if (details.velocity.pixelsPerSecond.dx > 0) {
        if(widget.onSwipeRight != null && widget.onSwipeRight("hi",1)){
          _possitionCurrent = _possitionFromLeft;
        } else {

        }
      } else {
        _possitionCurrent = _possitionFromRight;
      }
    });

    aController.reset();
    aController.forward();
  }

  @override
  void dispose() {
    aController.dispose();
    super.dispose();
  }

}
