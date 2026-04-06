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

  // ✅ Keep screens const for performance
  final List<Widget> _screens = const [
    HomeScreenCustomer(),
    MyPostedJobsScreen(),
    CreateJobScreen(),
    ChatScreen(),
    ProfileScreenCustomer(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    // ✅ Prevent unnecessary rebuild
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Keeps state of each tab
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),

      // ✅ Modern styled navbar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 10,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work_outline),
              activeIcon: Icon(Icons.work),
              label: "My Jobs",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              activeIcon: Icon(Icons.add_circle),
              label: "Create",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat),
              label: "Chat",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}