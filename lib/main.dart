import 'package:flutter/material.dart';
import 'MainPage.dart';
import 'dart:async';


void main() => runApp(
   MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: MyApp(),    
  )
);



class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
     Future.delayed(
      Duration(seconds: 2),
      (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage(),), );} ,
    );

    
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center ( 
        child: FlutterLogo(
          size: 400,
        ),
      ),
    );
  }
}