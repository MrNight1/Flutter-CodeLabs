import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';  // For using customized theme
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart'; // For google sign-in
import 'dart:async';

//Variable for sign-in
final googleSignIn = new GoogleSignIn();

/*
The previous snippet uses multiple await expressions to execute Google Sign-In methods in sequence.
If the value of the currentUser property is null, your app will first execute signInSilently(),
get the result and store it in the user variable. The signInSilently method attempts
to sign in a previously authenticated user, without interaction.
After this method finishes executing, if the value of user is still null,
your app will start the sign-in process by executing the signIn() method.

After a user signs in, we can access the profile photo from the GoogleSignIn instance.
 */
Future<Null> _ensureLoggedIn() async {
  GoogleSignInAccount user = googleSignIn.currentUser;
  if (user == null)
    user = await googleSignIn.signInSilently();
  if (user == null) {
    await googleSignIn.signIn();
  }
}



void main(){
  runApp( new FriendlychatApp()  );
}

//Customized theme for IOS
final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

//Customized theme for Android
final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

class FriendlychatApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: "FriendlyChat",
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: new ChatScreen(), //home:= Default screen or the main UI for app
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin{
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController(); // TO manage interactions with the textField
  bool _isComposing = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold( //Scaffold := Implements the basic material design visual layout structure.
        appBar: new AppBar( //AppBar:= is a horizontal bar typically shown at the top of an app using the appBar property.
          title: new Text("FriendlyChat"),
          elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
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

  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
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
              onChanged: (String text){
                setState((){
                  _isComposing = text.length > 0;
                });
              },
              onSubmitted: _handleSubmitted, //onSubmitted: To be notified when the user submits a message
              decoration: new InputDecoration.collapsed(
                  hintText: "Send a message"),
            ),
          ),
          new Container(
            margin: new EdgeInsets.symmetric(horizontal: 4.0),
            child: new IconButton(
              icon: new Icon(Icons.send),
              onPressed: _isComposing
                  ? () => _handleSubmitted(_textController.text) // => expression is shorthand for { return expression; }
                  : null,
            ),
          ),
          ],
        ),
      ),
    );
  }

  Future<Null> _handleSubmitted(String text) async{
    _textController.clear();
    setState(() {
      _isComposing = false;
    });

    await _ensureLoggedIn();
    _sendMessage(text: text);
    /*
    ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 700),
        vsync: this,
      ),
    );

    setState((){ //You call setState()to modify _messages and to let the framework know this part of the widget tree has changed and it needs to rebuild the UI.
      _messages.insert(0, message);
    });
    message.animationController.forward();
    */
  }

  void _sendMessage({ String text }) {
    ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 700),
        vsync: this,
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }
}
const String _name = "David";

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start, //gives it the highest position along the vertical axis.
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(
                  backgroundImage: new NetworkImage(googleSignIn.currentUser.photoUrl)) //Foto de perfil de la cuenta autenticada
              ), //For the avatar, the parent is a Row widget whose main axis is horizontal

            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[ // For messages, the parent is a Column widget whose main axis is vertical, so CrossAxisAlignment.start aligns the text at the furthest left position along the horizontal axis.
                  new Text(googleSignIn.currentUser.displayName, style: Theme.of(context).textTheme.subhead),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Text(text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}