import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EatRev', style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0))),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, size: 50),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: Text('Edit Profile'),
            ),
            ListTile(
              title: Text('Settings'),
              leading: Icon(Icons.settings),
              onTap: () {},
            ),
            ListTile(
              title: Text('Version'),
              leading: Icon(Icons.info),
              onTap: () {},
            ),
            ListTile(
              title: Text('Security'),
              leading: Icon(Icons.security),
              onTap: () {},
            ),
            ListTile(
              title: Text('Notification'),
              leading: Icon(Icons.notifications),
              onTap: () {},
            ),
            ListTile(
              title: Text('My Reviews'),
              leading: Icon(Icons.reviews),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
