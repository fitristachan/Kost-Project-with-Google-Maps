import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_mobpro/views/home/home.dart';
import 'package:flutter_mobpro/views/maps/mylocation.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class SharedPreferencesHelper {
  static final String _keyName = "Kimi no namae wa?";

  static Future<bool> saveName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_keyName, name);
  }

  static Future<String?> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyName);
  }
}


class _MyProfileScreenState extends State<MyProfileScreen> {
 TextEditingController _nameController = TextEditingController();
  String _name = "";

 int _currentIndex = 1;

  final List<Widget> _screens = [
    HomeScreen(),
    MyProfileScreen(),
    MyLocationScreen(),
  ];

  void _onItemTapped(int index) {
    if (index < _screens.length) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  _loadName() async {
    String? name = await SharedPreferencesHelper.getName();
    if (name != null) {
      setState(() {
        _name = name;
      });
    }
  }

  _saveName() async {
    String name = _nameController.text;
    if (name.isNotEmpty) {
      bool success = await SharedPreferencesHelper.saveName(name);
      if (success) {
        setState(() {
          _name = name;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return 
      Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //_screens[_currentIndex],
            Text(
              'Kimi no namae wa?',
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              _name,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Kimi no namae wa?',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveName,
              child: Text('Save'),
            ),
          ],
        ),
      );
        
  }
}