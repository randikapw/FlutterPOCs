import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    home: MyWidget(),
  ));
}

class MyWidget extends StatelessWidget {

  Widget build(BuildContext context) {
    // retrieve the mediaQuery data
    final mediaQueryData = MediaQuery.of(context);
    if (mediaQueryData.accessibleNavigation) {
      return Text('Screen reader is on');
    } else {
      return Text('Screen reader is off');
    }
  }

}