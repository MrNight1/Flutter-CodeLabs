class Frog extends StatelessWidget {
  const Frog({
    Key key,
    this.color: const Color(0xFF2DBD3A),
    this.child,
  }) : super(key: key);

  final Color color;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new Container(color: color, child: child);
  }
}