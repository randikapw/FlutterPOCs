/// Reference : https://flutter.io/docs/development/ui/widgets-intro#basic-widgets
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {

  final Widget title;

  ///constructor
  MyAppBar({this.title});


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.0, // In logical pixels.
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(color: Colors.blue[100]),
      // Row is a horizontal layout.
      child: Row(
        // <Widget> is the type of items in the list.
        children: <Widget>[

        ],
      ),
    );
  }


}
