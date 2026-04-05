import 'package:flutter/material.dart';

// Screens
import 'homescreencustomer.dart';
import 'createjobscreen.dart';
import 'chatscreen.dart';
import 'profilescreencustomer.dart';
import 'jobdetailsscreen.dart';

class CustomerNavBar extends StatefulWidget {
  final int initialIndex;

  // 🔥 NEW
  final bool showJobDetails;
  final dynamic jobData;

  const CustomerNavBar({
    super.key,
    this.initialIndex = 0,
    this.showJobDetails = false,
    this.jobData,
  });

  @override
  State<CustomerNavBar> createState() => _CustomerNavBarState();
}

class _CustomerNavBarState extends State<CustomerNavBar> {
  late int _selectedIndex;

  // ✅ Normal screens
  final List<Widget> _screens = [
    const HomeScreenCustomer(),
    const CreateJobScreen(),
    const ChatScreen(),
    const ProfileScreenCustomer(),
  ];

  @override
  void initState() {
    super.initState();

    // 🔥 If coming from JobDetails → force Home tab
    _selectedIndex = widget.showJobDetails ? 0 : widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    // 🔥 SHOW JOB DETAILS INSIDE NAVBAR
    if (widget.showJobDetails && widget.jobData != null) {
      body = JobDetailsScreen(
        category: widget.jobData["category"],
        description: widget.jobData["description"],
        location: widget.jobData["location"],
        jobId: widget.jobData["jobId"],
      );
    } else {
      body = IndexedStack(
        index: _selectedIndex,
        children: _screens,
      );
    }

    return Scaffold(
      body: body,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
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