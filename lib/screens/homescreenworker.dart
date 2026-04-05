import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreenWorker extends StatefulWidget {
  const HomeScreenWorker({super.key});

  @override
  State<HomeScreenWorker> createState() => _HomeScreenWorkerState();
}

class _HomeScreenWorkerState extends State<HomeScreenWorker> {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? _workerStream;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _workerStream = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .snapshots();
    }
  }

  String? _readWorkerCategory(Map<String, dynamic>? data) {
    if (data == null) return null;

    final directTradeFields = [
      data['profession'],
      data['jobTitle'],
      data['workerRole'],
      data['speciality'],
      data['specialty'],
      data['trade'],
      data['category'],
    ];

    for (final value in directTradeFields) {
      final text = value?.toString().trim();
      if (text != null && text.isNotEmpty) {
        return text;
      }
    }

    final role = data['role']?.toString().trim();
    if (role == null || role.isEmpty) return null;
    if (role.toLowerCase() == 'worker' || role.toLowerCase() == 'customer') {
      return null;
    }
    return role;
  }

  String _normalizeCategory(String value) {
    return value.trim().toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final jobsStream = FirebaseFirestore.instance
        .collection('jobs')
        .orderBy('createdAt', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Worker Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.work_outline, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Available Jobs',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Jobs added from the backend will appear here for workers.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: _workerStream,
                builder: (context, snapshot) {
                  if (_workerStream == null) {
                    return const Center(
                      child: Text(
                        'Please log in to view jobs.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Failed to load jobs.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  }

                  final workerCategory = _readWorkerCategory(
                    snapshot.data?.data(),
                  );

                  if (workerCategory == null || workerCategory.isEmpty) {
                    return const Center(
                      child: Text(
                        'Add your job role in profile to see matching jobs.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: jobsStream,
                    builder: (context, jobsSnapshot) {
                      if (jobsSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (jobsSnapshot.hasError) {
                        return const Center(
                          child: Text(
                            'Failed to load jobs.',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      }

                      final docs = jobsSnapshot.data?.docs ?? [];
                      final normalizedWorkerCategory = _normalizeCategory(
                        workerCategory,
                      );

                      final availableJobs = docs.where((doc) {
                        final data = doc.data();
                        final status = (data['status'] ?? '')
                            .toString()
                            .toLowerCase();
                        final category = (data['category'] ?? '')
                            .toString()
                            .trim();

                        return status != 'completed' &&
                            status != 'cancelled' &&
                            _normalizeCategory(category) ==
                                normalizedWorkerCategory;
                      }).toList();

                      if (availableJobs.isEmpty) {
                        return Center(
                          child: Text(
                            'No $workerCategory jobs available right now.',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: availableJobs.length,
                        itemBuilder: (context, index) {
                          final job = availableJobs[index].data();
                          final jobId =
                              (job['jobId'] ?? availableJobs[index].id)
                                  .toString();
                          final category = (job['category'] ?? 'Untitled Job')
                              .toString();
                          final description =
                              (job['description'] ?? 'No description added')
                                  .toString();
                          final location =
                              (job['location'] ?? 'Location not available')
                                  .toString();
                          final status = (job['status'] ?? 'waiting')
                              .toString();

                          return _JobCard(
                            jobId: jobId,
                            category: category,
                            description: description,
                            location: location,
                            status: status,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final String jobId;
  final String category;
  final String description;
  final String location;
  final String status;

  const _JobCard({
    required this.jobId,
    required this.category,
    required this.description,
    required this.location,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Description: $description',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              'Location: $location',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              'Status: ${status.toUpperCase()}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkerJobDetailsScreen(
                        jobId: jobId,
                        category: category,
                        description: description,
                        location: location,
                        status: status,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'View',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkerJobDetailsScreen extends StatelessWidget {
  final String jobId;
  final String category;
  final String description;
  final String location;
  final String status;

  const WorkerJobDetailsScreen({
    super.key,
    required this.jobId,
    required this.category,
    required this.description,
    required this.location,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Job Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Job ID: $jobId',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Text(
              'Location: $location',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Text(
              'Status: ${status.toUpperCase()}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
