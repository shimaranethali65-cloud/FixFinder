import 'package:flutter/material.dart';

// Screens
import 'homescreencustomer.dart';
import 'createjobscreen.dart';
import 'chatscreen.dart';
import 'profilescreencustomer.dart';
import 'mypostedjobscustomer.dart'; 

class CustomerNavBar extends StatefulWidget {
  final int initialIndex;

  const CustomerNavBar({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<CustomerNavBar> createState() => _CustomerNavBarState();
}

class _CustomerNavBarState extends State<CustomerNavBar> {
  late int _selectedIndex;

  final List<Widget> _screens = [
    const HomeScreenCustomer(),
    const MyPostedJobsScreen(), 
    const CreateJobScreen(),
    const ChatScreen(),
    const ProfileScreenCustomer(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

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
        children: _screens,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.work), // 👈 NEW
            label: "My Jobs",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: "Create",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
