import 'package:flutter/material.dart';

void main(){
  runApp( new FriendlychatApp()  );
}

class FriendlychatApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: "FriendlyChat",
      home: new ChatScreen(), //home:= Default screen or the main UI for app
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen>{
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController(); // TO manage interactions with the textField
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold( //Scaffold := Implements the basic material design visual layout structure.
      appBar: new AppBar( //AppBar:= is a horizontal bar typically shown at the top of an app using the appBar property.
        title: new Text("FriendlyChat")),
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
              padding: new EdgeInsets.all(8.0), // for white space around the message text
              reverse: true, //to make the ListView start from the bottom of the screen
              itemBuilder: (_, int index) => _messages[index], //for a function that builds each widget in [index]
                                                               // _ is a convention to indicate that it wont be used
              itemCount: _messages.length,
            ),
          ),
          new Divider(height: 1.0), //to draw a horizontal rule between the UI for displaying messages and the text input field for composing messages.
          new Container(
            decoration: new BoxDecoration(
              color: Theme.of(context).cardColor),
            child: _buildTextComposer(), //tell the app how to display the text input user control
          ),
        ],
      )
    );
  }

  Widget _buildTextComposer(){
    return new IconTheme(
        data: new IconThemeData(color: Theme.of(context).accentColor),
        child: new Container( //adds a horizontal margin between the edge of the screen and each side of the input field.
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[new Flexible(
              child: new TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted, //onSubmitted: To be notified when the user submits a message
                decoration: new InputDecoration.collapsed(
                  hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text), // => expression is shorthand for { return expression; }
              ),
             ),
            ],
          ),
        ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = new ChatMessage(text: text,);
    setState((){ //You call setState()to modify _messages and to let the framework know this part of the widget tree has changed and it needs to rebuild the UI.
      _messages.insert(0, message);
    });
  }
}
const String _name = "David";

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start, //gives it the highest position along the vertical axis.
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: new CircleAvatar(child: new Text(_name[0])), //For the avatar, the parent is a Row widget whose main axis is horizontal
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[ // For messages, the parent is a Column widget whose main axis is vertical, so CrossAxisAlignment.start aligns the text at the furthest left position along the horizontal axis.
              new Text(_name, style: Theme.of(context).textTheme.subhead),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}