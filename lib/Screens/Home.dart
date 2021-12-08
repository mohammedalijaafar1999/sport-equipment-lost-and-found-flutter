import 'package:flutter/material.dart';
import 'package:sports_equipment_lost_and_found_it_project/Controller/AuthController.dart';
import 'package:sports_equipment_lost_and_found_it_project/Screens/Auth/Login.dart';
import 'package:sports_equipment_lost_and_found_it_project/Screens/Equipments/AddEquipment.dart';
import 'package:sports_equipment_lost_and_found_it_project/Screens/LostEquipments/ScanPage.dart';
import 'package:sports_equipment_lost_and_found_it_project/Screens/Profile/EditProfilePage.dart';
import 'package:sports_equipment_lost_and_found_it_project/Screens/Profile/ProfilePage.dart';
import 'package:sports_equipment_lost_and_found_it_project/Screens/Settings.dart';
import 'Equipments/MyEquipments.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  List<Widget> appBarActions = [];

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

  List<Widget> _widgetOptions = <Widget>[
    MyEquipments(),
    ScanPage(),
    ProfilePage(),
    Settings(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      appBarActions.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => EditProfilePage(),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Edit",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                )
              ],
            ),
          ),
        ),
      ));
    } else {
      appBarActions.clear();
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text("Mafqoud"),
        actions: appBarActions,
      ),

      body: Padding(
        padding: EdgeInsets.all(10),
        child: _widgetOptions[_selectedIndex],
      ),

      floatingActionButton: showFab
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              //Floating action button on Scaffold
              onPressed: () async {
                //code to execute on button press
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => AddEquipment(),
                  ),
                );
                setState(() {
                  _selectedIndex = 0;
                  appBarActions = [];
                });
              },
              child: Icon(Icons.add), //icon inside button
            )
          : null,

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
