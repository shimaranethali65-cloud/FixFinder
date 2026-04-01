import 'package:flutter/material.dart';

class CreateJobScreen extends StatefulWidget {
  const CreateJobScreen({super.key});

  @override
  State<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> {
  String selectedJob = "Plumber";

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

  final descriptionController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final selectedService =
        ModalRoute.of(context)!.settings.arguments as String?;

    if (selectedService != null) {
      selectedJob = selectedService;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // 🔙 Back
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),

                const SizedBox(height: 10),

                // Title
                const Center(
                  child: Text(
                    "Create Job",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Job Title
                const Text(
                  "Job Title",
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 6),

                DropdownButtonFormField<String>(
                  value: selectedJob,
                  items: jobs.map((job) {
                    return DropdownMenuItem(
                      value: job,
                      child: Text(job),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedJob = value!;
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Description
                const Text(
                  "Description",
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 6),

                TextField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Type here ....",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Location
                const Row(
                  children: [
                    Text(
                      "Current Location",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.location_pin, color: Colors.red, size: 16),
                  ],
                ),

                const SizedBox(height: 6),

                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Location fetched",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Map Image
                Center(
                  child: Image.asset(
                    'assets/images/map.png', // 🔥 add this image
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 30),

                // Button
                Center(
                  child: SizedBox(
                    width: 200,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Job Posted")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Post Appeal",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}