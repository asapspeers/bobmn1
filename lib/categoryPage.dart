import 'AddPage.dart';
import 'package:flutter/material.dart';
import 'searchCatPage.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(categoryPage());
List<String> categories = [
                        'Accounting & Tax Services', 
                        'Arts, Culture & Entertainment', 
                        'Auto Sales & Service', 
                        'Banking & Finance',
                        'Business Services',
                        'Community Organizations',
                        'Dentists & Orthodontists',
                        'Education',
                        'Health & Wellness',
                        'Health Care',
                        'Home Improvement',
                        'Insurance',
                        'Internet & Web Services',
                        'Legal Services',
                        'Lodging & Travel',
                        'Marketing & Advertising',
                        'News & Media',
                        'Pet Services',
                        'Real Estate',
                        'Restaurants and Nightlife',
                        'Shopping & Retail',
                        'Sports & Recreation',
                        'Transportation',
                        'Utilities',
                        'Wedding, Events & Meetings',
                        'Other'
                        ];

class categoryPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext ctxt) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: ListDisplay(),
    );
  }
}

class ListDisplay extends StatelessWidget {
  String category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( centerTitle: true ,
        title: Text("Search By Category"),
        backgroundColor: Color(0XFF000000),

      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(categories[index]),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DisCat(gotString: categories[index]),), );
            },
          );
        },
        padding: EdgeInsets.all(16.0),
      )
    );
  }
}

class DisCat extends StatefulWidget {
  final String gotString;

  DisCat({Key key, @required this.gotString}) : super(key: key);
  @override
  HomeState createState() => HomeState(gotString: gotString);

}

class HomeState extends State<DisCat> with TickerProviderStateMixin  {
    final String gotString;
    String category;
  HomeState({ @required this.gotString}) ;


  List<Item> items = List();
  List<Item> itemsNotDisplayed = List();
  int itemLength;
  Item item;
  DatabaseReference itemRef;
  

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  

  

  @override
  void initState() {

    super.initState();
    item = Item("", "","","","","");
    final FirebaseDatabase database = FirebaseDatabase.instance; //Rather then just writing FirebaseDatabase(), get the instance.  
    itemRef = database.reference().child('Businesses');
    itemRef.onChildAdded.listen(_onEntryAdded);
    itemRef.onChildChanged.listen(_onEntryChanged);
    itemsNotDisplayed = items;
    category = gotString;
    items = itemsNotDisplayed.where((u) => u.services.toLowerCase().contains(gotString.toLowerCase())).toList();

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
    
    
    if (items.isEmpty) {return Scaffold(
      appBar: AppBar( centerTitle: true ,
        title: Text(gotString),
        backgroundColor: Color(0XFF000000),

      ),
      resizeToAvoidBottomPadding: false,
      body: new Center(
        child: new Text("No " + gotString,
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30.0
        ),
        ),

      ),
    ); 
    } else  {return Scaffold(
      appBar: AppBar( centerTitle: true ,
        title: Text(gotString),
        backgroundColor: Color(0XFF000000),

      ),
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          
          Flexible(
            
            child: FirebaseAnimatedList(
              query: itemRef,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) => _listItem(index)  ,

            ),
          ),
        ],
      ),
    );
    }
  }
   /*_searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: category
        ),
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
  }*/

  _listItem(index) {
        String url;
   return new Card(
                  elevation: 2000 ,
                  child: ExpansionTile(
                    title:Text(items[index].name, textAlign: TextAlign.center,) ,
                    children: <Widget>[  
                      ListTile(
                        
                  contentPadding: EdgeInsets.symmetric(vertical: 30),
                  title:Text(items[index].name, textAlign: TextAlign.center,) ,
                  subtitle: Text(items[index].discr + "\n" + 
                                 items[index].services + "\n" 
                                  , textAlign: TextAlign.center,
                                ),
                  isThreeLine: true, 
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(onPressed: () => launch("tel://"+items[index].phoneNumber)  , child: Icon(Icons.phone)),
                    FlatButton(onPressed: ()async {
                      url = "https://www.google.com/maps/search/?api=1&query=" + items[index].address.replaceAll(" ", "+");
                    if (await canLaunch(url)) {
                    await launch(url);
                    } else {
                    throw 'Could not launch $url';
                    }}, child: Icon(Icons.room)),
                    FlatButton(onPressed: ()async {
                    url = "https://" + items[index].website;
                    if (await canLaunch(url)) {
                    await launch(url);
                    } else {
                    throw 'Could not launch $url';
                    }
                  }, child: Icon(Icons.web)),
                  ],
                )
                
                ],
                 
                )
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

  Item(this.name, this.phoneNumber , this.discr, this.services, this.address, this.website);

  Item.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        name = snapshot.value["Name"],
        phoneNumber = snapshot.value["Phones"],
        discr = snapshot.value["Description"],
        services = snapshot.value["Services"],
        website = snapshot.value["Website"],
        address = snapshot.value["Address"]
      
      
      ;
        

}