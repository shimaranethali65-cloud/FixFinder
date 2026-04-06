import 'package:flutter/material.dart';
import 'myjobsscreen.dart';
import 'homescreenworker.dart';
import 'profilescreen.dart';
import 'assignedjobsworker.dart';

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
    WorkerAssignedJobsScreen(),
    MyJobsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();

    // ✅ SAFE INDEX (NO CRASH EVER)
    _selectedIndex =
        (widget.initialIndex >= 0 && widget.initialIndex < _screens.length)
        ? widget.initialIndex
        : 0;
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
            icon: Icon(Icons.assignment),
            label: 'Assigned',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'My Jobs',
          ),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
