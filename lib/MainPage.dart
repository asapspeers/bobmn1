import 'package:flutter/material.dart';
import 'DP.dart';

import 'AddPage.dart';

import 'categoryPage.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: MainPage(),
    ));

class MainPage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPage(),
                    ),
                  );
                },
                child: Text("Add a Business",
                    style: TextStyle(
                      fontSize: 25,
                    )),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DP(),
                    ),
                  );
                },
                child: Text("Search By Name/A-Z",
                    style: TextStyle(
                      fontSize: 25,
                    )),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DP(),
                    ),
                  );
                },
                child: Text("Search By Category",
                    style: TextStyle(
                      fontSize: 25,
                    )),
              )
            ],
          ),
        ])));
  }
}
