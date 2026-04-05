import 'package:flutter/material.dart';
import 'viewjobdetailsscreen.dart';

class HomeScreenWorker extends StatelessWidget {
  const HomeScreenWorker({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello, Worker 👋"),
        leading: const Icon(Icons.arrow_back),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
        children: [

          Row(
            children: const [
              Icon(Icons.handyman),
              SizedBox(width: 10),
              Text(
                "Nearby Jobs",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
            ],
          ),

          const SizedBox(height: 20),

          jobCard(context, "Fix leaking pipe"),
          jobCard(context, "Repair broken water pipe"),
          jobCard(context, "Fix pipe joint leak"),
          jobCard(context, "Fix leaking shower"),
          jobCard(context, "Repair toilet flush"),
        ],
      ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const MyJobsScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const ProfileScreen(),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: 'My Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget jobCard(BuildContext context, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text(title),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewJobDetailsScreen(),
                ),
              );
            },
            child: const Text("View"),
          )
        ],
      ),
    );
  }
}