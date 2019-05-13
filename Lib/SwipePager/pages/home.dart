import 'package:flutter/material.dart';
import '../widgets/swipeContainer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    return Column(
//      children: <Widget>[
//        Text('Row1'),
//        Expanded(
//          child: SwipeContainer(
//            child: Column(
//              children: <Widget>[
//                Text("Hi"),
//                RaisedButton(
//                  child: Text("Yes"),
//                ),
//              ],
//            ),
//          ),
//        ),
//      ],
//    );

    return Container(
      child: SwipeContainer(
      child: () => Row(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.amber,
              child: Column(
                children: <Widget>[
                  Text('t1'),
                  Expanded(
                    child: Container(color: Colors.blue, child: Text('tckl')),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
