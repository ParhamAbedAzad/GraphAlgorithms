import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphalgorithms/SplashScreen.dart';
import 'package:graphalgorithms/views/getmatchinginput.dart';
import 'package:graphalgorithms/views/mst.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
//Home Page State
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) { // Main Design Of Homepage
    return Scaffold(
        body: Stack(children: <Widget>[
      Background(),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(child: MatchingButton()), // button to go to matching input page
          Center(child: MSTButton()) // botton to go to mst page
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Center(child: Text("Designed and Implemented By:", //Bottom names
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.grey
          ))),
          Center(child: Text("Amirhosein Izadjou, Parham Abedazad", // bottom names
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.grey
          )),),
          Container(
            height: 20,
          )
        ],
      )
    ]
            ));
  }
}

class Background extends StatelessWidget { // widget for our dark background
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

class MatchingButton extends StatelessWidget { // matching button navigation and design
  const MatchingButton({
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
          left: 48,
          right: 48,
          top: 20,
          bottom: 20,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MatchingPage()),
          );
        },
        child: Text(
          "Maximum Matching",
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}

class MSTButton extends StatelessWidget { //mst button navigation and design
  const MSTButton({
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
            MaterialPageRoute(builder: (context) => MSTPage()),
          );
        },
        child: Text(
          "Minimum Spanning Tree",
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
