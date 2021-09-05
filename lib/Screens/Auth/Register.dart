import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Color(0x623CEA)),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.ac_unit),
              label: "what",
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.ac_unit),
              label: "what",
              backgroundColor: Colors.blue,
            ),
          ],
          selectedItemColor: Colors.amber[800],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Register",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 42,
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Full Name",
                    hintStyle:
                        TextStyle(fontSize: 20.0, color: Colors.grey.shade400),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
