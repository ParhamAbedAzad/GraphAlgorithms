import 'package:flutter/material.dart';
import 'package:graphalgorithms/views/kruskalinput.dart';
import 'package:graphalgorithms/views/priminput.dart';

class MSTPage extends StatefulWidget {
  MSTPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MSTPageState createState() => _MSTPageState();
}

class _MSTPageState extends State<MSTPage> { // mst page main design. choice between kruskal and prim
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Color.fromRGBO(0, 251, 170, 1),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Stack(children: <Widget>[
          Background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(child: KruskalButton()), // kruskal button place
              Center(child: PrimButton()) // prim button place
            ],
          )
        ]
            ));
  }
}

class Background extends StatelessWidget { // background widget
  const Background({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage("assets/DarkBack.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class PrimButton extends StatelessWidget { // button that takes us to prim input page (actions and design)
  const PrimButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: FlatButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(27.0),
            side: BorderSide(color: Color.fromRGBO(35, 173, 123, 1))),
        color: Colors.transparent,
        textColor: Colors.white,
        padding: EdgeInsets.only(
          left: 40,
          right: 40,
          top: 20,
          bottom: 20,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PrimPage()),
          );
        },
        child: Text(
          "Prim",
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}

class KruskalButton extends StatelessWidget { // button that takes us to Kruskal input page (actions and design)
  const KruskalButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: FlatButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(27.0),
            side: BorderSide(color: Color.fromRGBO(35, 173, 123, 1))),
        color: Colors.transparent,
        textColor: Colors.white,
        padding: EdgeInsets.only(
          left: 30,
          right: 30,
          top: 20,
          bottom: 20,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => KruskalPage()),
          );
        },
        child: Text(
          "Kruskal",
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
