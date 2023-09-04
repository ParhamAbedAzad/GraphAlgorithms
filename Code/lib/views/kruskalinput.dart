import 'package:flutter/material.dart';
import 'package:graphalgorithms/views/showkruskal.dart';

class KruskalPage extends StatefulWidget {
  KruskalPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _KruskalPageState createState() => _KruskalPageState();
}

TextEditingController vertexController = new TextEditingController();

class _KruskalPageState extends State<KruskalPage> { // page that takes number of vertexes for kruskal with error handling
  @override
  Widget build(BuildContext context) {// main design of the page
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
        body: Stack(children: <Widget>[Background(),Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 6,
                      right: MediaQuery.of(context).size.width / 6),
                  child: Text(
                    "Enter Number of vertexes",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                Container(height: 30),
                VertexBox(),
                Container(height: 30),
                DrawVertexButton()
              ],
            ),
          )]));
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

class DrawVertexButton extends StatelessWidget { // button that handles the errors of input and sends us to showprim page
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
        if (!vertexController.text.isNotEmpty) {
          createErrorDialog("number of vertexes cannot be empty", context);
        } else if (!isNumeric(vertexController.text)) {
          createErrorDialog("number of vertexes must be an integer", context);
        } else if (int.tryParse(vertexController.text) <= 0) {
          createErrorDialog(
              "number of vertexes must be greater than zero", context);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ShowKruskal(vertex: int.tryParse(vertexController.text))),
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

createErrorDialog(String message, BuildContext context) {// error dialog design and actionsss
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

class ErrorOkButton extends StatelessWidget {// ok button of error dialog design and action
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

class VertexBox extends StatelessWidget { // textbox for number of vertexes
  const VertexBox({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width / 6,
          right: MediaQuery.of(context).size.width / 6),
      child: TextField(
        controller: vertexController,
        cursorColor: Colors.orange,
        style: TextStyle(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
            hintText: "Number of Vertexes",
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

bool isNumeric(String s) { // helper function to check if the input is number
  if (s == null) {
    return false;
  }
  return int.tryParse(s) == null ? false : true;
}
