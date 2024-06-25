import 'package:flutter/material.dart';
import 'home_page.dart';
import 'list_review_page.dart';
import 'profile_page.dart';
import 'captured_image_model.dart'; // Import CapturedImageModel

void main() => runApp(EatRevApp());

class EatRevApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EatRev',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MainPage(),
      debugShowCheckedModeBanner: false, // Remove debug banner
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  CapturedImageModel _capturedImageModel = CapturedImageModel(); // Instance of CapturedImageModel

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomePage(
            capturedImageModel: _capturedImageModel,
            onCapture: (model) {
              setState(() {
                _capturedImageModel = model;
              });
            },
          ),
          ListReviewPage(
            capturedImageModel: _capturedImageModel,
          ),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Reviews',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple[800],
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        elevation: 5,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
