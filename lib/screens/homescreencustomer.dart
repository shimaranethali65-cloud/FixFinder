import 'package:flutter/material.dart';

class HomeScreenCustomer extends StatelessWidget {
  HomeScreenCustomer({super.key});

  final List<Map<String, String>> services = [
    {"name": "Plumber", "image": "assets/images/plumber.png"},
    {"name": "Electrician", "image": "assets/images/electrician.png"},
    {"name": "Tile Installer", "image": "assets/images/tile.png"},
    {"name": "Ceiling Repair Technician", "image": "assets/images/ceiling.png"},
    {"name": "Appliance Repair Technician", "image": "assets/images/appliance.png"},
    {"name": "Gardener", "image": "assets/images/gardener.png"},
    {"name": "Handyman", "image": "assets/images/handyman.png"},
    {"name": "Painter", "image": "assets/images/painter.png"},
    {"name": "Carpenter", "image": "assets/images/carpenter.png"},
    {"name": "Mason", "image": "assets/images/mason.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🔙 Back Button
              IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),

              SizedBox(height: 10),

              // 👋 Greeting
              Text(
                "Hello, User 👋",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 15),

              // 🔍 Search Box
              TextField(
                decoration: InputDecoration(
                  hintText: "Search Services",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // 🧱 Grid
              Expanded(
                child: GridView.builder(
                  itemCount: services.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    return serviceCard(
                      services[index]["name"]!,
                      services[index]["image"]!,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget serviceCard(String name, String image) {
    return Column(
      children: [
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              image,
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
