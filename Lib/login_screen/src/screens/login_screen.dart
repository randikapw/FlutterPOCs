import 'package:flutter/material.dart';
import '../blocs/bloc.dart';
import '../blocs/provider.dart';

class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          emailFeild(bloc),
          passwordFeild(bloc),
          Container(margin: EdgeInsets.only(top: 15.0),),//just for spacing.
          submitButton()
        ],
      ),
    );
  }

  Widget emailFeild(Bloc bloc){
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

  Widget passwordFeild(Bloc bloc) {
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