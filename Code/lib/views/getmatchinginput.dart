import 'package:flutter/material.dart';
import 'package:graphalgorithms/views/showmatching.dart';

class MatchingPage extends StatefulWidget {
  MatchingPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MatchingPageState createState() => _MatchingPageState();
}

TextEditingController leftController = new TextEditingController();
TextEditingController rightController = new TextEditingController();

class _MatchingPageState extends State<MatchingPage> {
  @override
  void initState() {
    super.initState();
    leftController = new TextEditingController();
    rightController = new TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    leftController = null;
    rightController = null;
  }

  @override
  Widget build(BuildContext context) { // main design for getting matching inputs (number of left and right vertexes)
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 6,
                      right: MediaQuery.of(context).size.width / 6),
                  child: Text(
                    "Enter Number of vertexes on each side of the page(bipartite graph)",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                Container(height: 30),
                RightNumBox(),
                LeftNumBox(),
                Container(height: 30),
                DrawVertexButton()
              ],
            ),
          )
        ]));
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

class LeftNumBox extends StatelessWidget { // textbox for number of vertexes on the left
  const LeftNumBox({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width / 6,
          right: MediaQuery.of(context).size.width / 6),
      child: TextField(
        controller: leftController,
        cursorColor: Colors.orange,
        style: TextStyle(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
            hintText: "Left",
            hintStyle: TextStyle(color: Colors.white54, fontSize: 18),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(0, 251, 170, 1)),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(0, 251, 170, 1)),
            )),
      ),
    );
  }
}

class RightNumBox extends StatelessWidget { // textbox for number of vertexes on the right
  const RightNumBox({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width / 6,
          right: MediaQuery.of(context).size.width / 6),
      child: TextField(
        controller: rightController,
        cursorColor: Colors.orange,
        style: TextStyle(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
            hintText: "Right",
            hintStyle: TextStyle(color: Colors.white54, fontSize: 18),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(0, 251, 170, 1)),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(0, 251, 170, 1)),
            )),
      ),
    );
  }
}

class DrawVertexButton extends StatelessWidget { // button to take us to show matching page 
  const DrawVertexButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(28.0),
          side: BorderSide(color: Color.fromRGBO(35, 173, 123, 1))),
      color: Colors.transparent,
      textColor: Colors.white,
      padding: EdgeInsets.only(top: 15, left: 45, right: 45, bottom: 15),
      onPressed: () async {
        if (!rightController.text.isNotEmpty ||
            !leftController.text.isNotEmpty) {
          createErrorDialog("number of vertexes cannot be empty", context);
        } else if (!isNumeric(rightController.text) ||
            !isNumeric(leftController.text)) {
          createErrorDialog("number of vertexes must be an integer", context);
        } else if (int.tryParse(rightController.text) <= 0 ||
            int.tryParse(leftController.text) <= 0) {
          createErrorDialog(
              "number of vertexes must be greater than zero", context);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShowMatchingPage(
                    right: int.tryParse(rightController.text),
                    left: int.tryParse(leftController.text))),
          );
        }
      },
      child: Text(
        "Draw Vertexes".toUpperCase(),
        style: TextStyle(
          fontSize: 14.0,
        ),
      ),
    );
  }
}

createErrorDialog(String message, BuildContext context) { // error dialog design and actions
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.zero,
                  bottomRight: Radius.zero,
                  topRight: Radius.circular(75),
                  bottomLeft: Radius.circular(75))),
          title: Text(
            message,
            style: TextStyle(fontSize: 15.0),
          ),
          actions: <Widget>[
            ErrorOkButton(),
          ],
        );
      });
}

class ErrorOkButton extends StatelessWidget { // ok button of error dialog actions and design
  const ErrorOkButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(1.0),
        child: FlatButton(
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(25.0),
              side: BorderSide(color: Color.fromRGBO(0, 251, 170, 1))),
          color: Colors.transparent,
          textColor: Colors.black,
          padding: EdgeInsets.only(
            left: 5,
            right: 5,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Ok",
            style: TextStyle(
              fontSize: 17.0,
            ),
          ),
        ));
  }
}

bool isNumeric(String s) { //helper function to check if the input is number
  if (s == null) {
    return false;
  }
  return int.tryParse(s) == null ? false : true;
}
