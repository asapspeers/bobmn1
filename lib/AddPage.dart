import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'DP.dart';


// import 'package:firebase_core/firebase_core.dart'; not nessecary



void main() => runApp(AddPage());

class AddPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.fallback(),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  List<Item> items = List();
  Item item;
  Item selectedUser;
  var _currentItemSelected;


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

  void handleSubmit() {
    final FormState form = formKey.currentState;

    if (form.validate()) {
      form.save();
      form.reset();
      itemRef.push().set(item.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a Business'),
        centerTitle: true,
        backgroundColor: Color(0XFF000000),
      ),
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 0,
            child: Center(
              child: Form(
                key: formKey,
                child: Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.label_important),
                      title: TextFormField(
                        initialValue: "",
                        onSaved: (val) => item.name = val,
                        validator: (val) => val == "" ? val : null,
                        decoration: new InputDecoration.collapsed(hintText: 'Name'),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.label_important),
                      title: TextFormField(
                        initialValue: '',
                        onSaved: (val) => item.phoneNumber = val,
                        validator: (val) => val == "" ? val : null,
                        decoration: new InputDecoration.collapsed(hintText: 'Phone Number'),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.label_important),
                     // isThreeLine: true,
                      title: TextFormField(
                        initialValue: '',
                        onSaved: (val) => item.discr = val,
                        validator: (val) => val == "" ? val : null,
                        decoration: new InputDecoration.collapsed(hintText: 'Description'),
                      ),
                    ),
                    
                    ListTile(
                      leading: Icon(Icons.label_important),
                      title: TextFormField(
                        initialValue: '',
                        onSaved: (value) => item.website = value,
                        validator: (value) => value == "" ? value : null,
                        decoration: new InputDecoration.collapsed(hintText: 'Website'),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.label_important),
                      //isThreeLine: true,
                      title: TextFormField(
                        initialValue: '',
                        onSaved: (val) => item.address = val,
                        validator: (val) => val == "" ? val : null,
                        decoration: new InputDecoration.collapsed(hintText: 'Address or Location'),
                      ),
                    ),
                    DropdownButton<String>(
                      hint: Text("Services"),
                      items: <String>[
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
                        ].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (String newValueSelected) {
                        setState(() {
                          this._currentItemSelected = newValueSelected;
                          item.services = newValueSelected;
                        });
                      },
                      value: _currentItemSelected,
                      
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        handleSubmit();
                      },
                    ),
                    FlatButton(
                      child: Text("See Database"),
                      onPressed: () async {
                       await Navigator.push(
              context, new MaterialPageRoute(builder: (context) => DP()));},
                    ),
                  ],
                ),
              ),
            ),
          ),
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

       toJson() {
    return {
      "Name": name,
      "Phones": phoneNumber,
      "Description": discr,
      "Services": services,
      "Website": website,
      "Address": address,
    };
  }
        

}