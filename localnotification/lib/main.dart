import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
var initializationSettingsAndroid;
var initializationSettingsIOS;
var initializationSettings;

  void _incrementCounter() async {
 await  _demoNotification();
  }
  Future<void> _demoNotification () async{
    var androidPlatformChannelSpecifics = AndroidNotificationDetails('channel_ID','channel name','channel description', importance: Importance.Max,priority: Priority.High, ticker: 'test ticker' );

    var IOSChannelSpecifics = IOSNotificationDetails();
    var platafomChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics,IOSChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'hello',
      'word',
        platafomChannelSpecifics,
      payload: 'test payload'
    );
  }
  @override
  void initState(){
    super.initState();
      initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
      initializationSettingsIOS = new IOSInitializationSettings( onDidReceiveLocalNotification:onDidReceiveLocalNotification);
      initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
      
      flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: onSelectNotification
      );
  }
  Future onSelectNotification (String payload) async {
    if(payload != null){
      debugPrint("Notification payload $payload");
    }
    await Navigator.push(context,new MaterialPageRoute(builder: (context)=> new SecondRoute()));
  }

  Future onDidReceiveLocalNotification(int id,String title,String body,String payload)async{
    await showDialog(context: context,
      builder: (BuildContext context)=> CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[

        CupertinoDialogAction(
            isDefaultAction:true,
            child:Text('Ok'),
            onPressed :()async{
              Navigator.of(context,rootNavigator: true).pop();
              await Navigator.push(context, MaterialPageRoute(builder:(context)=>SecondRoute()));
            }
        )
      ],
      )
    );
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
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.notifications),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class SecondRoute extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Alert page')),
        body:Center(
          child:RaisedButton(
            child: Text('go back ...'),
            onPressed:(){
              Navigator.pop(context);
            },
          ),
        )
    );
  }
}