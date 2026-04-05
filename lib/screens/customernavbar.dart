import 'package:flutter/material.dart';

// ✅ Import your screens
import 'homescreencustomer.dart';
import 'createjobscreen.dart';
import 'chatscreen.dart';
import 'profilescreencustomer.dart';

class CustomerNavBar extends StatefulWidget {
  const CustomerNavBar({super.key});

  @override
  State<CustomerNavBar> createState() => _CustomerNavBarState();
}

class _CustomerNavBarState extends State<CustomerNavBar> {

  int _selectedIndex = 0;

  // ✅ Your actual screens
  final List<Widget> _screens = [
    const HomeScreenCustomer(),
    const CreateJobScreen(),
    const ChatScreen(),
    const ProfileScreenCustomer(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: "Create",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}