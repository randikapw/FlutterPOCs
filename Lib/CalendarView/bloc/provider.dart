import 'package:flutter/material.dart';
import 'bloc.dart';

class Provider extends InheritedWidget {
  final Bloc bloc;

  Provider(this.bloc,{Key key, Widget child}):super(key: key, child: child);


  @override
  bool updateShouldNotify(_) => true; //_ in parameters means don't care about the params in this code.

  static Bloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(Provider) as Provider).bloc;

}