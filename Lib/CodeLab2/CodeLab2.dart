/// Beautiful UI with Flutter : https://codelabs.developers.google.com/codelabs/flutter/#0
import 'package:flutter/material.dart';

void main() {
  runApp(FriendlyChatApp());
}

class FriendlyChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Friendly Chat',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Friendly Chat'),
          ) ,
        )
    );
  }
}

class ChatSreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friendly layout'),
      ),
    );
  }
}