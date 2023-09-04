import 'dart:math';
import 'package:vector_math/vector_math.dart' as Math;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ShowPrim extends StatefulWidget {
  ShowPrim({Key key, this.title, this.vertex}) : super(key: key);
  final String title;
  final int vertex;
  @override
  _ShowPrimState createState() {
    //initializing our variables
    vertexes = this.vertex;
    mst = 0;
    vertexKeys = new List<GlobalKey>();
    pressedKeys = new List<GlobalKey>();
    answerEdges = new List<OffsetPair>();
    stackWidgets = new List<Widget>();
    vertexColors = new List<Color>();
    edgesToDraw = new List<Widget>();
    edges = new List<OffsetPair>();
    answerEdgeWeights = new List<int>();
    edgeWeights = new List<int>();
    pressedIndexes = new List<int>();
    showRes = false;
    weight = null;
    graph = new List<List<int>>(vertexes);
    for (int i = 0; i < vertexes; i++) {
      graph[i] = new List<int>(vertexes);
    }
    for (int i = 0; i < vertexes; i++)
      for (int j = 0; j < vertexes; j++) graph[i][j] = 0;
    return _ShowPrimState();
  }
}
//global vars begin
int vertexes;
int weight;
int mst;
bool showRes;
List<int> answerEdgeWeights;
List<OffsetPair> answerEdges;
List<GlobalKey> vertexKeys;
List<Color> vertexColors;
List<GlobalKey> pressedKeys;
List<Widget> stackWidgets;
List<Widget> edgesToDraw;
List<int> edgeWeights;
List<int> pressedIndexes;
List<OffsetPair> edges;
List<List<int>> graph;
TextEditingController edgeController = new TextEditingController();
//global vars end
class _ShowPrimState extends State<ShowPrim> {
  @override
  void initState() {
    super.initState();
    setStackWidgets();
  }

  @override
  Widget build(BuildContext context) { // main design for prim page
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
          Stack(children: stackWidgets),
          AnimatedOpacity( // a widget that appears when user presses the button on bottom of the page. it shows the minimum cost
              opacity: showRes ? 1 : 0,
              duration: Duration(milliseconds: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 50,
                  ),
                  Center(
                      child: Text("Minimum cost: " + mst.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 20)))
                ],
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Center(child: primButton()),
            ],
          )
        ]));
  }

  List<Widget> vertexButtons() { //make vertexes as buttons so they can be clickable.
    List<Widget> widgets = new List<Widget>();
    double x = 360 / vertexes;
    double angle = 0;
    for (int i = 0; i < vertexes; i++) {
      vertexKeys.add(GlobalKey());
      vertexColors.add(Colors.transparent);
      widgets.add(Align(
          alignment: Alignment(
              cos(Math.radians(angle)), sin(Math.radians(angle)) * 0.6),
          child: FlatButton(
            key: vertexKeys[i],
            onPressed: () { // when a vertex button is pressed, we find which one is pressed and we add it to an array. when the size of the array gets to 2, we make an edge and add the edge to the graph
              answerEdges.clear();
              answerEdgeWeights.clear();
              showRes = false;
              if (vertexColors[i] == Colors.transparent)
                vertexColors[i] = Colors.blue;
              else
                vertexColors[i] = Colors.transparent;
              pressedKeys.add(vertexKeys[i]);
              pressedIndexes.add(i);
              print("vertex pressed");
              checkKeys();
              setState(() {});
            },
            child: Text(" "),
            padding: EdgeInsets.all(7),
            disabledColor: Colors.transparent,
            color: vertexColors[i],
            shape:
                CircleBorder(side: BorderSide(color: Colors.white, width: 3)),
          )));
      angle += x;
    }
    return widgets;
  }

  primButton() { // button to calculate mst using prim
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
        onPressed: () { //when the button is pressed, we calculate the mst and redraw everything.
          showRes = true;
          primMST();
          setStackWidgets();
          setState(() {});
        },
        child: Text(
          "show MST using prim",
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  ///prim Start
  bool createsMST(int u, int v, List<bool> inMST) {
    if (u == v) return false;
    if (inMST[u] == false && inMST[v] == false)
      return false;
    else if (inMST[u] == true && inMST[v] == true) return false;
    return true;
  }

  Future<void> primMST() async {
    mst = 0;
    List<List<int>> cost = new List<List<int>>(vertexes);
    List<bool> inMST = new List<bool>.filled(vertexes, false);
    inMST[0] = true;
    int edgeNo = 0;
    for (int i = 0; i < vertexes; i++) {
      cost[i] = new List<int>(vertexes);
      for (int j = 0; j < vertexes; j++) {
        if (graph[i][j] == 0) {
          cost[i][j] = 1000 * 1000 * 1000;
        } else
          cost[i][j] = graph[i][j];
      }
    }
    try {
      while (edgeNo < vertexes - 1) {
        int min = 1000 * 1000 * 1000, a = -1, b = -1;
        for (int i = 0; i < vertexes; i++) {
          for (int j = 0; j < vertexes; j++) {
            if (cost[i][j] < min) {
              if (createsMST(i, j, inMST)) {
                min = cost[i][j];
                a = i;
                b = j;
              }
            }
          }
        }
        mst += min;
        edgeNo++;
        inMST[b] = inMST[a] = true;
        Offset p1, p2;
        RenderBox box = vertexKeys[a].currentContext.findRenderObject();
        p1 = box.localToGlobal(Offset.zero);
        box = vertexKeys[b].currentContext.findRenderObject();
        p2 = box.localToGlobal(Offset.zero);
        answerEdges.add(OffsetPair(global: p1, local: p2));
        answerEdgeWeights.add(min);
      }
    } catch (e) {
      showRes = false;
      mst = 0;
      await createErrorDialog("graph must be connected", context);
    }
  }

  ///prim End
  checkKeys() async {//handles changes to buttons. if needed, it will draw an edge between the vertexes and add it to our graph array
    if (pressedKeys.length == 2 && pressedKeys[0] == pressedKeys[1]) {
      print(graph);
      pressedKeys = new List<GlobalKey>();
      pressedIndexes = new List<int>();
      removeButtonColors();
      setState(() {});
    }
    if (pressedKeys.length == 2 &&
        graph[pressedIndexes[0]][pressedIndexes[1]] == 0) {
      Offset p1, p2;
      int v1, v2;
      RenderBox box =
          vertexKeys[pressedIndexes[0]].currentContext.findRenderObject();
      p1 = box.localToGlobal(Offset.zero);
      box = vertexKeys[pressedIndexes[1]].currentContext.findRenderObject();
      p2 = box.localToGlobal(Offset.zero);
      v1 = pressedIndexes[0];
      v2 = pressedIndexes[1];
      print("1");
      await createWeightDialog("set edge weight", context);
      print("2");
      if (weight != null) {
        graph[v1][v2] = weight;
        graph[v2][v1] = weight;
        edges.add(OffsetPair(global: p1, local: p2));
        edgeWeights.add(weight);
        weight = null;
        edgeController.clear();
      }
      print(graph);
      pressedKeys = new List<GlobalKey>();
      pressedIndexes = new List<int>();
      removeButtonColors();
      setState(() {});
    }
    if (pressedKeys.length == 2 &&
        graph[pressedIndexes[0]][pressedIndexes[1]] != 0) {
      print(graph);
      pressedKeys = new List<GlobalKey>();
      pressedIndexes = new List<int>();
      removeButtonColors();
      setState(() {});
    }
    setStackWidgets();
  }

  removeButtonColors() { // removes the blue colors from buttons.
    for (int i = 0; i < vertexColors.length; i++)
      vertexColors[i] = Colors.transparent;
  }

  setStackWidgets() {
    List<Widget> widgets = new List<Widget>();
    widgets.add(Background());
    widgets.add(
      AnimatedOpacity(
          opacity: showRes ? 0 : 1,
          duration: Duration(milliseconds: 500),
          child: CustomPaint(
            size: Size.infinite,
            painter: DrawLine(Offset.zero, Offset.zero),
          )),
    );
    widgets.add(
      AnimatedOpacity(
          opacity: showRes ? 1 : 0,
          duration: Duration(milliseconds: 500),
          child: CustomPaint(
            size: Size.infinite,
            painter: DrawAnswerLine(Offset.zero, Offset.zero),
          )),
    );
    if (!showRes)
      for (int i = 0; i < edgeWeights.length; i++) {
        widgets.add(edgeWeightWidget(i));
      }
    else
      for (int i = 0; i < answerEdgeWeights.length; i++) {
        widgets.add(answerEdgeWeightWidget(i));
      }
    widgets.addAll(vertexButtons());
    stackWidgets = widgets;
  }

  edgeWeightWidget(int i) { // widget that draws weights of the edges
    return Positioned(
        top: (edges[i].global.dy + edges[i].local.dy) / 2 +
            15 +
            (edges[i].global.dy - edges[i].local.dy) / 4,
        left: (edges[i].global.dx + edges[i].local.dx) / 2 +
            38 +
            (edges[i].global.dx - edges[i].local.dx) / 4,
        child: Text(
          edgeWeights[i].toString(),
          style: TextStyle(color: Colors.yellow, fontSize: 20),
        ));
  }

  answerEdgeWeightWidget(int i) {// widget that draws weights of the edges for the answer
    return Positioned(
        top: (answerEdges[i].global.dy + answerEdges[i].local.dy) / 2 +
            15 +
            (answerEdges[i].global.dy - answerEdges[i].local.dy) / 4,
        left: (answerEdges[i].global.dx + answerEdges[i].local.dx) / 2 +
            38 +
            (answerEdges[i].global.dx - answerEdges[i].local.dx) / 4,
        child: Text(
          answerEdgeWeights[i].toString(),
          style: TextStyle(color: Colors.yellow, fontSize: 20),
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

class LineWidget extends StatelessWidget { // a widget that draws the edges using painter
  const LineWidget({
    Key key,
    @required this.p1,
    @required this.p2,
  }) : super(key: key);

  final Offset p1;
  final Offset p2;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: CustomPaint(
      painter: DrawLine(p1, p2),
      child: Container(),
    ));
  }
}

class DrawLine extends CustomPainter { // a widget that paints the edges 
  Offset p1;
  Offset p2;

  DrawLine(Offset p1, Offset p2) {
    this.p1 = p1;
    this.p2 = p2;
  }
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;

    for (int i = 0; i < edges.length; i++) {
      Offset x = edges[i].global;
      x = Offset(x.dx + 44, x.dy + 24);
      Offset y = edges[i].local;
      y = Offset(y.dx + 44, y.dy + 24);
      canvas.drawLine(x, y, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class AnswerLineWidget extends StatelessWidget { // widget that draws the answer edges using a painter
  const AnswerLineWidget({
    Key key,
    @required this.p1,
    @required this.p2,
  }) : super(key: key);

  final Offset p1;
  final Offset p2;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: CustomPaint(
      painter: DrawLine(p1, p2),
      child: Container(),
    ));
  }
}

class DrawAnswerLine extends CustomPainter { // painter that paints the answer edges
  Offset p1;
  Offset p2;

  DrawAnswerLine(Offset p1, Offset p2) {
    this.p1 = p1;
    this.p2 = p2;
  }
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 1;

    for (int i = 0; i < answerEdges.length; i++) {
      Offset x = answerEdges[i].global;
      x = Offset(x.dx + 44, x.dy + 24);
      Offset y = answerEdges[i].local;
      y = Offset(y.dx + 44, y.dy + 24);
      canvas.drawLine(x, y, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
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

class ErrorOkButton extends StatelessWidget { // ok button of the error design and action
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

createWeightDialog(String message, BuildContext context) async { // dialog that asks for weight of the edge
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
          content: EdgeBox(),
          actions: <Widget>[
            OkButton(),
          ],
        );
      });
}

class OkButton extends StatelessWidget { // set button for the edges
  const OkButton({
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
          onPressed: () async {
            if (!edgeController.text.isNotEmpty) {
              createErrorDialog("number of vertexes cannot be empty", context);
            } else if (!isNumeric(edgeController.text)) {
              createErrorDialog(
                  "number of vertexes must be an integer", context);
            } else if (int.tryParse(edgeController.text) <= 0) {
              createErrorDialog(
                  "number of vertexes must be greater than zero", context);
            } else {
              weight = int.tryParse(edgeController.text);
              Navigator.pop(context);
            }
          },
          child: Text(
            "SET",
            style: TextStyle(
              fontSize: 17.0,
            ),
          ),
        ));
  }
}

bool isNumeric(String s) { // helper function to check if a string is a number
  if (s == null) {
    return false;
  }
  return int.tryParse(s) == null ? false : true;
}

class EdgeBox extends StatelessWidget { // text input of weight of the edge
  const EdgeBox({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width / 6,
          right: MediaQuery.of(context).size.width / 6),
      child: TextField(
        controller: edgeController,
        cursorColor: Colors.orange,
        style: TextStyle(color: Colors.black, fontSize: 18),
        decoration: InputDecoration(
            hintText: "Edge Weight",
            hintStyle: TextStyle(color: Colors.black, fontSize: 16),
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
