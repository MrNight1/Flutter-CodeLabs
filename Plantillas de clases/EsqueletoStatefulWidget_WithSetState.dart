class Bird extends StatefulWidget {
  //Constructor: By convention, widget constructors only use named arguments. 
  //Named arguments can be marked as required using @required. Also by convention, 
  //the first argument is key, and the last argument is child, children, or the equivalent.
  const Bird({
    Key key,
    this.color: const Color(0xFFFFE306),
    this.child,
  }) : super(key: key);
   
  //Properties of the class
  final Color color;

  final Widget child;
  
  //Creates the mutable state for this widget at a given location in the tree
  _BirdState createState() => new _BirdState();
}

class _BirdState extends State<Bird> {
  double _size = 1.0;

  void grow() {
    setState(() { _size += 0.1; });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: widget.color,
      transform: new Matrix4.diagonal3Values(_size, _size, 1.0),
      child: widget.child,
    );
  }
}