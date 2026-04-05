import 'package:flutter/material.dart';

import 'homescreenworker.dart';
import 'myjobsscreen.dart';
import 'profilescreen.dart';

class WorkerNavBar extends StatefulWidget {
  final int initialIndex;

  const WorkerNavBar({super.key, this.initialIndex = 0});

  @override
  State<WorkerNavBar> createState() => _WorkerNavBarState();
}

class _WorkerNavBarState extends State<WorkerNavBar> {
  late int _selectedIndex;

  final List<Widget> _screens = const [
    HomeScreenWorker(),
    MyJobsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: 'My Jobs',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
