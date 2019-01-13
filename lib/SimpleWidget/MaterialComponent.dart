///Reference : https://flutter.io/docs/development/ui/widgets-intro#using-material-components
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
void main(){
  runApp(MaterialApp(
    title: 'Flutter tutorial',
    home: TutorialHome(),
  ));
}

class TutorialHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Scafold is a layout for the major Material component.
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.menu),
            tooltip: '',
            onPressed: null),
        title: Text('Example Titile'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: null,
          )
        ],
      ),
      // body is the majority of the screen.
      body: Center(
        child: Row(
          children: <Widget>[
            Text('Hello, world!'),
            Expanded(
              child: Container(),
            ),
            Expanded(
              child: MyButton(),
            ),
          ],

        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add', // used by assistive technologies
        child: Icon(Icons.add),
        onPressed: null,
      ),
    );
  }
}


///below code is referred to: https://flutter.io/docs/development/ui/widgets-intro#handling-gestures

class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //print('MyButton was tapped!');
        Fluttertoast.showToast(
            msg: "This is Center Short Toast",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white
        );
      },
      child: Container(
        height: 36.0,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.lightGreen[500],
        ),
        child: Center(
          child: Text('Engage'),
        ),
      ),
    );
  }
}