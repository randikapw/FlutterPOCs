/// Beautiful UI with Flutter : https://codelabs.developers.google.com/codelabs/flutter/#0
import 'package:flutter/material.dart';

const String _name = 'Randika';

void main() {
  runApp(FriendlyChatApp());
}

class FriendlyChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Friendly Chat',
        home: ChatSreen()
    );
  }
}

class ChatSreen extends StatefulWidget {

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatSreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friendly layout'),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
            ),

          ),
          Divider(height: 1.0,),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),

    );
  }

  void _handleSubmitted(String text){
    ChatMessage cm = ChatMessage(
        text: text,
        animationController: AnimationController(
            duration: Duration(milliseconds: 700),
            vsync: this),
    );
    setState(() {
      _messages.insert(0, cm);
    });
    _textController.clear();
    cm.animationController.forward();
  }

  Widget _buildTextComposer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: InputDecoration.collapsed(hintText: "Send a message"),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {                                                   //new
    for (ChatMessage message in _messages)                           //new
      message.animationController.dispose();                         //new
    super.dispose();                                                 //new
  }
}

class ChatMessage extends StatelessWidget {

  ChatMessage({this.text,this.animationController});

  final String text;
  final AnimationController animationController;

  static final Animatable<Offset> _drawerTeween = Tween<Offset>(
    begin: Offset(-1.0, 0.0),
    end: Offset.zero
  ).chain(CurveTween(
  curve: Curves.fastOutSlowIn,
  ));

  void _reverseAnimation() {
    animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
//    return SizeTransition(
//      sizeFactor: CurvedAnimation(
//        parent: animationController,
//        curve: Curves.easeOut,
//      ),
//      axisAlignment: 0.0,
      return SlideTransition(
        position: animationController.drive(_drawerTeween),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                  child: Text(_name[0]),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_name, style: Theme.of(context).textTheme.subhead,),
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  child: Text(text),
                ),
              ],
            ),
            Expanded(
              child: Container(),
            ),
            IconButton(
              icon: Icon(Icons.undo),
              onPressed: _reverseAnimation,
            ),
          ],
        ),
      ),
    )
      ;
  }

}