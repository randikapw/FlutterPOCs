import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'blocs/provider.dart';

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Provider( //Introduced provider instance.
      child: MaterialApp(
        title: "Log me In",
        home: Scaffold(
          body: LoginScreen(),
        ),
      ),
    );
  }
}