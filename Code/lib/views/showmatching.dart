import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphalgorithms/matching.dart';

class ShowMatchingPage extends StatefulWidget {
  ShowMatchingPage({Key key, this.title, this.left, this.right})
      : super(key: key);
  final String title;
  final int right;
  final int left;
  @override
  _ShowMatchingPageState createState() {
    //variables initialization
    rightNum = right;
    showRes = false;
    leftNum = left;
    rightKeys = new List<GlobalKey>();
    leftKeys = new List<GlobalKey>();
    pressedKeys = new List<GlobalKey>();
    pressedkeysisRight = new List<bool>();
    stackWidgets = new List<Widget>();
    rightColors = new List<Color>();
    leftColors = new List<Color>();
    answerEdges = new List<OffsetPair>();
    edgesToDraw = new List<Widget>();
    edges = new List<OffsetPair>();
    graph = new List<List<int>>(rightNum + leftNum);
    for (int i = 0; i < rightNum + leftNum; i++) {
      graph[i] = new List<int>(rightNum + leftNum);
    }
    for (int i = 0; i < rightNum + leftNum; i++)
      for (int j = 0; j < rightNum + leftNum; j++) graph[i][j] = 0;
    return _ShowMatchingPageState();
  }
}

//global vars begin
bool showRes;
int rightNum = 0;
int leftNum = 0;
List<GlobalKey> rightKeys;
List<Color> rightColors;
List<Color> leftColors;
List<GlobalKey> leftKeys;
List<GlobalKey> pressedKeys;
List<bool> pressedkeysisRight;
List<Widget> stackWidgets;
List<Widget> edgesToDraw;
List<OffsetPair> edges;
List<OffsetPair> answerEdges;
List<List<int>> graph;
//global vars end

class _ShowMatchingPageState extends State<ShowMatchingPage> {
  @override
  void initState() {
    super.initState();
    setStackWidgets();
  }

  @override
  Widget build(BuildContext context) { // main design of page
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
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Center(child: matchingButton()),
            ],
          )
        ]));
  }

  matchingButton() { // button that runs the matching algorithm
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
          showRes = true;
          print(showRes);
          setAnswerEdges();
          setStackWidgets();
          setState(() {});
        },
        child: Text(
          "Run Matching",
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  List<Widget> leftButtons() { // draw left vertexes and make them buttons to add edges to the graph
    List<Widget> widgets = new List<Widget>();
    double x = 2 / (leftNum + 1);
    for (int i = 0; i < leftNum; i++) {
      leftKeys.add(GlobalKey());
      leftColors.add(Colors.transparent);
      widgets.add(Align(
          alignment: Alignment(-0.8, -1 + x * (i + 1)),
          child: FlatButton(
            key: leftKeys[i],
            onPressed: () {
              answerEdges = new List<OffsetPair>();
              showRes = false;
              if (leftColors[i] == Colors.transparent)
                leftColors[i] = Colors.blue;
              else
                leftColors[i] = Colors.transparent;
              pressedKeys.add(leftKeys[i]);
              pressedkeysisRight.add(false);
              print("left pressed");
              checkKeys();
              setState(() {});
            },
            child: Text(" "),
            padding: EdgeInsets.all(7),
            disabledColor: Colors.transparent,
            color: leftColors[i],
            shape:
                CircleBorder(side: BorderSide(color: Colors.white, width: 3)),
          )));
    }
    return widgets;
  }

  List<Widget> rightButtons() { // draw right vertexes and make them buttons to add edges to the graph
    List<Widget> widgets = new List<Widget>();
    double x = 2 / (rightNum + 1);
    for (int i = 0; i < rightNum; i++) {
      rightKeys.add(GlobalKey());
      rightColors.add(Colors.transparent);
      widgets.add(Align(
          alignment: Alignment(0.8, -1 + x * (i + 1)),
          child: FlatButton(
            key: rightKeys[i],
            onPressed: () {
              answerEdges = new List<OffsetPair>();
              showRes = false;
              if (rightColors[i] == Colors.transparent)
                rightColors[i] = Colors.blue;
              else
                rightColors[i] = Colors.transparent;
              pressedKeys.add(rightKeys[i]);
              pressedkeysisRight.add(true);
              checkKeys();
              print("right pressed");
              setState(() {});
              //checkKeys();
            },
            child: Text(" "),
            padding: EdgeInsets.all(7),
            disabledColor: Colors.transparent,
            color: rightColors[i],
            shape:
                CircleBorder(side: BorderSide(color: Colors.white, width: 3)),
          )));
    }
    return widgets;
  }

  checkKeys() { // function that checks pressed vertexes to draw an edge and add that edge to the graph
    if (pressedKeys.length == 2) {
      if (pressedkeysisRight[0] != pressedkeysisRight[1]) {
        Offset p1, p2;
        int v1, v2;
        for (int i = 0; i < leftKeys.length; i++) {
          if (leftKeys[i] == pressedKeys[0]) {
            RenderBox box = leftKeys[i].currentContext.findRenderObject();
            p1 = box.localToGlobal(Offset.zero);
            v1 = i;
          }
          if (leftKeys[i] == pressedKeys[1]) {
            RenderBox box = leftKeys[i].currentContext.findRenderObject();
            p1 = box.localToGlobal(Offset.zero);
            v1 = i;
          }
        }
        for (int i = 0; i < rightKeys.length; i++) {
          if (rightKeys[i] == pressedKeys[0]) {
            RenderBox box = rightKeys[i].currentContext.findRenderObject();
            p2 = box.localToGlobal(Offset.zero);
            v2 = i + leftNum;
          }
          if (rightKeys[i] == pressedKeys[1]) {
            RenderBox box = rightKeys[i].currentContext.findRenderObject();
            p2 = box.localToGlobal(Offset.zero);
            v2 = i + leftNum;
          }
        }
        graph[v1][v2] = 1;
        graph[v2][v1] = 1;
        edges.add(OffsetPair(global: p1, local: p2));
        print("test");
      }
      print(graph);
      pressedKeys = new List<GlobalKey>();
      pressedkeysisRight = new List<bool>();
      removeButtonColors();
    }
    setStackWidgets();
    setState(() {});
  }

  setAnswerEdges() // run the maximum matching algorithm and get position of the vertexes to draw the answer edges
  {
    List<List<int>> ans = maximumMatching(graph, leftNum, rightNum);
    Offset p1, p2;
    print(ans);
    for(int i = 0 ; i < leftNum ; i ++)
    {
      for(int j = leftNum ; j < leftNum + rightNum ; j ++)
      {
        if(ans[i][j] == 1)
        {
          RenderBox box = leftKeys[i].currentContext.findRenderObject();
          p1 = box.localToGlobal(Offset.zero);
          box = rightKeys[j - leftNum].currentContext.findRenderObject();
          p2 = box.localToGlobal(Offset.zero);
          answerEdges.add(OffsetPair(global: p1,local:p2));
        }
      }
    }
  }

  removeButtonColors() { // remove blue color from pressed buttons
    for (int i = 0; i < leftColors.length; i++)
      leftColors[i] = Colors.transparent;
    for (int i = 0; i < rightColors.length; i++)
      rightColors[i] = Colors.transparent;
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
    widgets.addAll(leftButtons());
    widgets.addAll(rightButtons());
    stackWidgets = widgets;
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

class LineWidget extends StatelessWidget { //widget that draws the edges with a painter
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

class DrawLine extends CustomPainter { // painter that paints the edges
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

class AnswerLineWidget extends StatelessWidget { // widget that draws answer edges using painter
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

class DrawAnswerLine extends CustomPainter { // painter that draws edges
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
