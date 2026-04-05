import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


import '../constants/app_colors.dart';

class CreateJobScreen extends StatefulWidget {
  const CreateJobScreen({super.key});

  @override
  State<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> {
  String selectedJob = "Plumber";

  LatLng? currentLatLng;
  String locationText = "Fetching location...";

  StreamSubscription<Position>? positionStream;

  final TextEditingController descriptionController =
      TextEditingController();

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

  @override
  void initState() {
    super.initState();
    _startLocationUpdates();
  }

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(lat, lng);

      Placemark place = placemarks[0];

      List<String?> parts = [
        place.street,
        place.locality,
        place.administrativeArea,
        place.country,
      ];

      parts.removeWhere((p) => p == null || p!.isEmpty);

      return parts.join(", ");
    } catch (e) {
      return "Location not found";
    }
  }

  void _startLocationUpdates() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => locationText = "Location disabled");
      return;
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    ).listen((Position position) async {
      LatLng newLatLng =
          LatLng(position.latitude, position.longitude);

      String address = await getAddressFromLatLng(
          position.latitude, position.longitude);

      setState(() {
        currentLatLng = newLatLng;
        locationText = address;
      });
    });
  }

  @override
  void dispose() {
    positionStream?.cancel();
    descriptionController.dispose();
    super.dispose();
  }

  void _openJobSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: jobs.map((job) {
            return ListTile(
              title: Text(job),
              trailing: job == selectedJob
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                setState(() => selectedJob = job);
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  // 🔥 UPDATED NAVIGATION
  Future<void> _postJob() async {
    final user = FirebaseAuth.instance.currentUser;
    if (descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter description")),
      );
      return;
    }

    String jobId =
        DateTime.now().millisecondsSinceEpoch.toString();

    await FirebaseFirestore.instance
        .collection('jobs')
        .doc(jobId)
        .set({
      'jobId': jobId,
      'category': selectedJob,
      'description': descriptionController.text,
      'location': locationText,
      'status': 'waiting',
      'createdAt': Timestamp.now(),
      'postedBy': user?.email ?? "User",
  'postedById': user?.uid,
    });

    // ✅ GO TO NAVBAR + SHOW JOB DETAILS
    Navigator.pushNamed(
      context,
      '/home',
      arguments: {
        "index": 0,
        "showJobDetails": true,
        "jobData": {
          "category": selectedJob,
          "description": descriptionController.text,
          "location": locationText,
          "jobId": jobId,
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: SafeArea(
        child: Column(
          children: [

            /// SCROLLABLE CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// BACK BUTTON
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/home',
                              (route) => false,
                            );
                          },
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

                    const SizedBox(height: 20),

                    const Text("Job Title"),
                    const SizedBox(height: 8),

                    GestureDetector(
                      onTap: _openJobSelector,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 250, 251, 251),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color.fromARGB(255, 227, 229, 230)),
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(selectedJob),
                            const Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text("Description"),
                    const SizedBox(height: 8),

                    TextField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Type here...",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text("Current Location"),
                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Text(locationText),
                    ),

                    const SizedBox(height: 16),

                    currentLatLng != null
                        ? SizedBox(
                            height: 200,
                            child: FlutterMap(
                              options: MapOptions(
                                initialCenter: currentLatLng!,
                                initialZoom: 15,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                  userAgentPackageName:
                                      'com.example.fixfinder',
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: currentLatLng!,
                                      width: 40,
                                      height: 40,
                                      child: const Icon(
                                        Icons.location_pin,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : const Center(child: CircularProgressIndicator()),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            /// BUTTON
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _postJob,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Post Appeal"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}