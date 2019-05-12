import 'package:flutter/material.dart';
import 'pages/home.dart';

void main(){
  runApp(Application());
}


/// This is the application context.
class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar Navigation',
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Calendar',
            style: Theme.of(context).textTheme.title,
          ),
        ),
        body: HomePage(),
      ),
    );
  }
}