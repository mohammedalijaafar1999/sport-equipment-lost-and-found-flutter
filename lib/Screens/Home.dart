import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sports_equipment_lost_and_found_it_project/Controller/AuthController.dart';
import 'package:sports_equipment_lost_and_found_it_project/Screens/Auth/Login.dart';
import 'package:http/http.dart' as http;
import '../../Utils/Globals.dart' as globals;
import '../MyEquipments.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void logout() async {
    AuthController ac = new AuthController();
    bool logedOut = await ac.logout();
    if (logedOut) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    } else {
      print("logout from server failed");
    }
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    MyEquipments(),
    Text(
      'Index 1: Search',
      style: optionStyle,
    ),
    Text(
      'Index 2: Profile',
      style: optionStyle,
    ),
    Text(
      'Index 2: Settings',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text("Mafqoud"),
      ),

      body: Padding(
        padding: EdgeInsets.all(10),
        child: _widgetOptions[_selectedIndex],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        //Floating action button on Scaffold
        onPressed: () {
          //code to execute on button press
        },
        child: Icon(Icons.add), //icon inside button
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //floating action button position to center

      bottomNavigationBar: BottomAppBar(
        elevation: 15,
        //bottom navigation bar on scaffold
        color: Colors.white,
        shape: CircularNotchedRectangle(), //shape of notch
        notchMargin:
            6, //notche margin between floating button and bottom appbar
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Row(
            //children inside bottom appbar
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: _selectedIndex == 0
                      ? Theme.of(context).primaryColor
                      : Colors.black,
                  size: 36,
                ),
                onPressed: () {
                  _onItemTapped(0);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: _selectedIndex == 1
                      ? Theme.of(context).primaryColor
                      : Colors.black,
                  size: 36,
                ),
                onPressed: () {
                  _onItemTapped(1);
                },
              ),
              SizedBox(
                width: 60,
              ),
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: _selectedIndex == 2
                      ? Theme.of(context).primaryColor
                      : Colors.black,
                  size: 36,
                ),
                onPressed: () {
                  _onItemTapped(2);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: _selectedIndex == 3
                      ? Theme.of(context).primaryColor
                      : Colors.black,
                  size: 36,
                ),
                onPressed: () {
                  _onItemTapped(3);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
