import 'dart:async';

class Validators {
  final validateEmail = StreamTransformer<String,String>.fromHandlers(
    handleData: (email, sink){
      if(email.contains('@')){
        sink.add(email);
      } else {
        sink.addError('Enter valid email');
      }
    }
  );

  final validatePassword = StreamTransformer<String,String>.fromHandlers(
    handleData: (String password, EventSink sink){
      // TODO: Implement validation logic for password.
      sink.add(password);
    }
  );
}