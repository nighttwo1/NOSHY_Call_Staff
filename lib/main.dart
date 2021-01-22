import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marquee/marquee.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    SystemChrome.setEnabledSystemUIOverlays([]);
    //App to landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return MaterialApp(
      title: 'Flutter Demo',
      //debug label disable
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _autoText = "여기 맥주2병 소주 1병이요~~";
  double _speed = 100.0;
  bool _isvisible = false;
  Color _backgroundColor = Colors.black;
  AudioCache _audioCache;
  bool _isGestureEnabled = true;


  @override
  void initState() {
    super.initState();
    _audioCache = AudioCache(prefix: "", fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void onTap(){
    print("tap");
    setState(() {
      _isvisible = true;
      _isGestureEnabled = false;
    });
    Future.delayed(const Duration(milliseconds: 5000), (){
      setState(() {
        _isvisible = false;
        _isGestureEnabled = true;
        print("false");

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        backgroundColor: _backgroundColor,

      // appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(widget.title),
      // ),

      body: Stack(
        children: <Widget>[

          new GestureDetector(
            onTap: _isGestureEnabled ? onTap: null,
            onPanEnd: (details){
              double speed = details.velocity.pixelsPerSecond.dx.abs().floorToDouble();
              setState((){
                if(speed/5>20){
                  _speed = speed/5;
                }
                print(speed);
              });
            },
            onLongPress: (){
              TextEditingController _controller = TextEditingController(text: _autoText);
              FocusNode _focusNode = FocusNode();
              _focusNode.addListener(() {
                if(_focusNode.hasFocus){
                  _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
                }
              });
              showDialog(context: context,
                  builder: (context){
                    return AlertDialog(
                      title: new Text("화면에 띄울 새로운 텍스트를 입력해주세요"),
                      content: TextFormField(
                        controller: _controller,
                        onFieldSubmitted: (value){
                          Navigator.pop(context, _controller.text);
                        },
                        focusNode: _focusNode,
                      ),
                      actions: <Widget>[
                        new FlatButton(onPressed: (){
                          Navigator.pop(context, _autoText);
                        }, child: new Text("취소")),
                        new FlatButton(onPressed: (){
                          Navigator.pop(context, _controller.text);
                        }, child: new Text("확인"))
                      ],
                    );
                  }
              ).then((value){
                if(value == null){
                  value = _autoText;
                }
                setState((){
                  _autoText = value;
                  SystemChrome.setEnabledSystemUIOverlays([]);
                });
              });

            },
            child: Center(

              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.

              // child: Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     new Expanded(
              //         flex: 1,
              //         child: new SingleChildScrollView(
              //           scrollDirection: Axis.horizontal,
              //           child: new Text("집에 보내줘요ㅠ", style: new TextStyle(fontSize:120, color:Colors.black), textAlign: TextAlign.left,
              //           ),
              //         )
              //     )
              //
              //   ],
              // ),
              // A widget that repeats text and automatically scrolls it infinitely.
              child: Marquee(
                text: _autoText,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 140, color: Colors.white),
                scrollAxis: Axis.horizontal,
                blankSpace: 100.0,
                velocity: _speed,
                startPadding: 10.0,
              ),


              // //problem: scrollview not located vertically center.
              // //solution: wrap SingleChildScrollView in a Center
              //   child: new SingleChildScrollView(
              //     scrollDirection: Axis.horizontal,
              //     child: new Text("집에 보내줘요ㅠ", style: new TextStyle(fontSize:120, color:Colors.black), textAlign: TextAlign.left,
              //     ),
              //   )

              // child: Column(
              //   // Column is also a layout widget. It takes a list of children and
              //   // arranges them vertically. By default, it sizes itself to fit its
              //   // children horizontally, and tries to be as tall as its parent.
              //   //
              //   // Invoke "debug painting" (press "p" in the console, choose the
              //   // "Toggle Debug Paint" action from the Flutter Inspector in Android
              //   // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
              //   // to see the wireframe for each widget.
              //   //
              //   // Column has various properties to control how it sizes itself and
              //   // how it positions its children. Here we use mainAxisAlignment to
              //   // center the children vertically; the main axis here is the vertical
              //   // axis because Columns are vertical (the cross axis would be
              //   // horizontal).
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     Text(
              //       'You have pushed the button this many times:',
              //     ),
              //     Text(
              //       '$_counter',
              //       style: Theme.of(context).textTheme.headline4,
              //     ),
              //
              //   ],
              // ),


            ),
          ),
          new Visibility(
              visible: _isvisible,
              child: Positioned(
                  child: new IconButton(
                    icon: Icon(Icons.audiotrack, color: Colors.green, size: 30.0,),
                    onPressed: (){
                      _audioCache.play('callserver.mp3');
                      print("clicked");
                    },
                  ),
                  right: 10,
                  top: 10)
          ),
        ],
      )

      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
