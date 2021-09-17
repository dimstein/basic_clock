import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:wakelock/wakelock.dart';

void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Basic Clock',
      theme: ThemeData(

        //primarySwatch: Colors.,
      ),
      home: MyHomePage(title: 'Basic Clock'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late String _timeString;
  late String _dateString;
  //String _status='disabled';
  Color _statusColor=Colors.blue;
  Icon _fabIcon = Icon(Icons.bedtime_rounded, color: Colors.black);

  @override
  void initState() {

    _timeString=_formatTime(DateTime.now());
    _dateString=_formatDate(DateTime.now());
    disableWakelock();

    Timer.periodic(Duration(seconds: 1), (timer) => _getTime());
    super.initState();
  }
  disableWakelock()async=>await Wakelock.disable();

  String _formatTime(DateTime dateTime){
    return DateFormat('HH:mm:ss').format(dateTime);
  }
  String _formatDate(DateTime dateTime){
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  toggleWakelock(){
      Wakelock.enabled.then((value) async=> value ?
        Wakelock.toggle(enable: false):
        Wakelock.toggle(enable: true));
      Wakelock.enabled.then((value) async => value ?
        _statusColor=Colors.blue :
        _statusColor=Colors.green);
      //Wakelock.enabled.then((value) async=> value ? _status='disabled' :_status='enabled');
      Wakelock.enabled.then((value) async => value ?
        _fabIcon= Icon(Icons.bedtime_rounded, color: Colors.black) :
        _fabIcon=Icon(Icons.wb_sunny, color: Colors.yellow));
      setState(() {

      });
    }

  void _getTime(){
    final DateTime now = DateTime.now();
    final String formattedTime = _formatTime(now);
    final String formattedDate = _formatDate(now);
    setState(() {
      _timeString=formattedTime;
      _dateString=formattedDate;
      });
  }

  @override
  Widget build(BuildContext context) {
    //Wakelock.enable();

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black,

        title: Text(widget.title, style: TextStyle(color: Colors.blueGrey),),
      ),
      body: Container(color:Colors.black ,
        child: Center(

          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_timeString, style: TextStyle(color: Colors.blueGrey[600], fontSize: 75)
              ),
              SizedBox(height: 40),
              Text(
                _dateString,
                style: TextStyle(color: Colors.blueGrey[400], fontSize: 40),
              ),
              //Text('status of wake:    $_status', style: TextStyle(color: Colors.green),)
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleWakelock,
        tooltip: 'keep awake',
        child: _fabIcon,
        backgroundColor: _statusColor,

      ),
    );
  }
}
