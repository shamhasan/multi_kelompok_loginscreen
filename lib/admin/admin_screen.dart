import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_kelompok/admin/genre_admin_screen.dart';
import 'package:multi_kelompok/admin/movie_admin_screen.dart';
import 'package:multi_kelompok/profile_ui.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const MovieAdminScreen(),
    const GenreAdminScreen(),
    const ProfileUi(),
  ];

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Movie Admin' : 'Genre Admin'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent[100],
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Movies'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Genres'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: onItemTapped,
      ),
    );
  }
}