import 'package:flutter/material.dart';
import '../blocs/bloc.dart';

class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          emailFeild(),
          passwordFeild(),
          Container(margin: EdgeInsets.only(top: 15.0),),//just for spacing.
          submitButton()
        ],
      ),
    );
  }

  Widget emailFeild(){
    return StreamBuilder(
      stream: bloc.email,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'you@email.com',
            labelText: 'Email Adress',
            errorText: snapshot.error,
          ),
        );
      }
    );
  }

  Widget passwordFeild() {
    return StreamBuilder(
      stream: bloc.password,
      builder: (context, snapshot){
        return TextField(
          onChanged: bloc.changePassword,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'password',
            labelText: 'password',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget submitButton(){
    return RaisedButton(
      child: Text('Login'),
      color: Colors.blue[200],
      onPressed: (){},
    );
  }
}