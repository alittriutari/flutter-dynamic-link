import 'dart:async';

import 'package:dynamic_link/dynamic_link_service.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

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

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final DynamicLinkService _dynamicLinkService = DynamicLinkService();
  Timer _timerLink;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    print('state ' + state.toString());
    if (state == AppLifecycleState.resumed) {
      _timerLink = Timer(Duration(milliseconds: 850), () {
        _dynamicLinkService.retrieveDynamicLink(context);
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose

    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          height: 50,
          width: 100,
          child: FutureBuilder<Uri>(
            future: _dynamicLinkService.createDynamicLink(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Uri uri = snapshot.data;
                return TextButton(
                    onPressed: () {
                      print(uri.toString());
                      Share.share(uri.toString());
                    },
                    child: Text('Share'));
              } else {
                return Text('null');
              }
            },
          ),
        ),
      ),
    );
  }
}
