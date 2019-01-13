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
          IconButton(
            icon: Icon(Icons.menu),
            tooltip: 'Navigation menu',
            onPressed: null,
          ),
          // Expanded expands its child to fill the available space
          Expanded(
            child: title,
          ),
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Search',
            onPressed: null,
          ),
        ],
      ),
    );
  }

}

  class MyScafold extends StatelessWidget {

    @override
    Widget build(BuildContext context) {
      // Material is a conceptual piece of paper on which the UI appears.
      return Material(
        // Column is a vertical, linear layout.
        child: Column(
          children: <Widget>[
            MyAppBar(
              title: Text(
                'Example text',
                style: Theme.of(context).primaryTextTheme.title,
              ),
            ),
            Expanded(
              child: Center(
                child: Text('Hello World!'),
              ),
            ),
          ],
        )
      );

    }
  }

  void main() {
    runApp(
      MaterialApp(
        title: 'My App',
        home: MyScafold(),
      )
    );
  }
