import 'package:flutter/material.dart';

class CreateJobScreen extends StatefulWidget {
  const CreateJobScreen({super.key});

  @override
  State<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> {
  String selectedJob = "Plumber";
  bool isDropdownOpen = false;

  final List<String> jobs = [
    "Plumber",
    "Electrician",
    "Tile Installer",
    "Ceiling Repair Technician",
    "Appliance Repair Technician",
    "Gardener",
    "Handyman",
    "Painter",
    "Carpenter",
    "Mason",
  ];

  final TextEditingController descriptionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Close dropdown when tapping outside
        setState(() {
          isDropdownOpen = false;
        });
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),

        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // 🔙 BACK + TITLE
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const Expanded(
                      child: Text(
                        "Create Job",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),

                const SizedBox(height: 10),

                // 🔹 JOB TITLE
                const Text(
                  "Job Title",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      isDropdownOpen = !isDropdownOpen;
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(selectedJob),
                        const Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
                ),

                // 🔥 CUSTOM DROPDOWN
                if (isDropdownOpen)
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      children: jobs.map((job) {
                        final isSelected = job == selectedJob;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedJob = job;
                              isDropdownOpen = false;
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.grey.withOpacity(0.2)
                                  : Colors.transparent,
                              border: const Border(
                                bottom:
                                    BorderSide(color: Colors.black12),
                              ),
                            ),
                            child: Text(
                              job,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                const SizedBox(height: 20),

                // 🔹 DESCRIPTION
                const Text(
                  "Description",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Type here ...",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 📍 LOCATION
                const Text(
                  "Current Location 📍",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: const Text("Location fetched"),
                ),

                const SizedBox(height: 20),

                // 🗺️ MAP IMAGE
                Center(
                  child: Image.asset(
                    "assets/images/map.png",
                    height: 120,
                  ),
                ),

                const Spacer(),

                // 🔵 BUTTON
                Center(
                  child: SizedBox(
                    width: 200,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Post Appeal",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}