import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flip_card/flip_card.dart';

// import 'package:firebase_core/firebase_core.dart'; not nessecary

void main() => runApp(DP());

class DP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Black Owned MN',
      theme: ThemeData.light(),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  List<Item> items = List();
  List<Item> itemsNotDisplayed = List();
  int itemLength;

  Item item;
  DatabaseReference itemRef;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    item = Item("", "", "", "", "", "");
    final FirebaseDatabase database = FirebaseDatabase
        .instance; //Rather then just writing FirebaseDatabase(), get the instance.
    itemRef = database.reference();
    itemRef.onChildAdded.listen(_onEntryAdded);
    itemRef.onChildChanged.listen(_onEntryChanged);
    itemsNotDisplayed = items;
  }

  _onEntryAdded(Event event) {
    setState(() {
      items.add(Item.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    var old = items.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      items[items.indexOf(old)] = Item.fromSnapshot(event.snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    items.sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Directory'),
        backgroundColor: Color(0XFF000000),
      ),
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Flexible(
            child: FirebaseAnimatedList(
              query: itemRef,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return index == 0 ? _searchBar() : _listItem(index - 1);

                /**/
              },
            ),
          ),
        ],
      ),
    );
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(hintText: 'Search...'),
        onChanged: (text) {
          text = text.toLowerCase();

          setState(() {
            items = itemsNotDisplayed.where((item) {
              var varSearch = item.name.toLowerCase();
              return varSearch.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  _listItem(index) {
    if (items.isEmpty) {}
    String url;
    return new FlipCard(
      front: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 30),
        title: Text(
          items[index].name,
          textAlign: TextAlign.center,
        ),
      ),
      back: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          FlatButton(
              onPressed: () => launch("tel://" + items[index].phoneNumber),
              child: Icon(Icons.phone)),
          FlatButton(
              onPressed: () async {
                url = "https://www.google.com/maps/search/?api=1&query=" +
                    items[index].address.replaceAll(" ", "+");
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Icon(Icons.room)),
          FlatButton(
              onPressed: () async {
                url = "https://" + items[index].website;
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Icon(Icons.web)),
        ],
      ),
    );
  }
}

class Item {
  String key;
  String name;
  String phoneNumber;
  String discr;
  String services;
  String website;
  String address;

  Item(this.name, this.phoneNumber, this.discr, this.services, this.address,
      this.website);

  Item.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        name = snapshot.value["Company Name"],
        phoneNumber = snapshot.value["Phones"],
        discr = snapshot.value["Hours"],
        services = snapshot.value["Business Type"],
        website = snapshot.value["Website"],
        address = snapshot.value["Address"];
}
