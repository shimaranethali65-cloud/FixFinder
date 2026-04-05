import 'package:flutter/material.dart';
import 'customernavbar.dart'; // 🔥 IMPORTANT

class HomeScreenCustomer extends StatefulWidget {
  const HomeScreenCustomer({super.key});

  @override
  State<HomeScreenCustomer> createState() => _HomeScreenCustomerState();
}

class _HomeScreenCustomerState extends State<HomeScreenCustomer> {

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

  List<Map<String, String>> filteredServices = [];

  @override
  void initState() {
    super.initState();
    filteredServices = services;
  }

  // 🔍 SEARCH FUNCTION
  void filterServices(String query) {
    final results = services.where((service) {
      final name = service["name"]!.toLowerCase();
      final input = query.toLowerCase();
      return name.contains(input);
    }).toList();

    setState(() {
      filteredServices = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🔙 Back
              IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),

              const SizedBox(height: 5),

              const Text(
                "Hello, User 👋",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // 🔍 SEARCH BAR
              TextField(
                onChanged: filterServices,
                decoration: InputDecoration(
                  hintText: "Search Services",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🧱 GRID
              Expanded(
                child: GridView.builder(
                  itemCount: filteredServices.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 18,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, index) {
                    return _serviceCard(
                      filteredServices[index]["name"]!,
                      filteredServices[index]["image"]!,
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

  // ✅ CLICKABLE CARD (🔥 FIXED NAVIGATION)
  Widget _serviceCard(String name, String image) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const CustomerNavBar(initialIndex: 1),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(image, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}