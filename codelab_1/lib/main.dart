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

class ChatScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold( //Scaffold := Implements the basic material design visual layout structure.
      appBar: new AppBar( //AppBar:= is a horizontal bar typically shown at the top of an app using the appBar property.
        title: new Text("FriendlyChat"),
      ),
    );
  }
}