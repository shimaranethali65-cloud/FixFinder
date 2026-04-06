import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'myjobsscreen.dart';
import 'chat_screen.dart'; // ✅ ADD THIS

class WorkerAssignedJobsScreen extends StatefulWidget {
  const WorkerAssignedJobsScreen({super.key});

  @override
  State<WorkerAssignedJobsScreen> createState() =>
      _WorkerAssignedJobsScreenState();
}

class _WorkerAssignedJobsScreenState extends State<WorkerAssignedJobsScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(title: const Text("Assigned Jobs"), centerTitle: true),

      body: user == null
          ? const Center(child: Text("User not logged in"))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('jobs')
                  .where('assignedTo', isEqualTo: user!.uid)
                  .where('status', isEqualTo: 'assigned')
                  .snapshots(),

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No assigned jobs yet"));
                }

                final jobs = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final job = jobs[index].data() as Map<String, dynamic>;
                    final jobId = jobs[index].id;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// 🔹 CATEGORY
                          Text(
                            job['category'] ?? "No category",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),

                          const SizedBox(height: 6),

                          /// 🔹 LOCATION
                          Text(
                            job['location'] ?? "",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(height: 10),

                          /// 🔹 DESCRIPTION
                          Text(
                            job['description'] ?? "",
                            style: const TextStyle(fontSize: 15),
                          ),

                          const SizedBox(height: 12),

                          /// 🔹 PRICE
                          Text(
                            "💰 Price: \$${job['assignedPrice'] ?? "0"}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(height: 14),

                          /// 🔹 BUTTONS (CHAT + COMPLETE)
                          Row(
                            children: [

                              /// 💬 CHAT BUTTON
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final customerId = job['postedById'];
                                    final workerId = user!.uid;

                                    /// 🔍 Check if chat exists
                                    final query = await FirebaseFirestore.instance
                                        .collection('chats')
                                        .where('jobId', isEqualTo: jobId)
                                        .where('workerId', isEqualTo: workerId)
                                        .get();

                                    String chatId;

                                    if (query.docs.isNotEmpty) {
                                      chatId = query.docs.first.id;
                                    } else {
                                      /// ➕ Create chat
                                      final doc = await FirebaseFirestore.instance
                                          .collection('chats')
                                          .add({
                                        'jobId': jobId,
                                        'customerId': customerId,
                                        'workerId': workerId,
                                        'participants': [customerId, workerId],
                                        'lastMessage': '',
                                        'timestamp': FieldValue.serverTimestamp(),
                                      });

                                      chatId = doc.id;
                                    }

                                    /// 🚀 OPEN CHAT SCREEN
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChatScreen(chatId: chatId),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    "Chat",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 10),

                              /// ✅ MARK AS COMPLETED
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text("Complete Job"),
                                        content: const Text(
                                            "Mark this job as completed?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text("Cancel"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text("Yes"),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm == true) {
                                      await FirebaseFirestore.instance
                                          .collection('jobs')
                                          .doc(jobId)
                                          .update({'status': 'completed'});

                                      if (!mounted) return;

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const MyJobsScreen(),
                                        ),
                                      );

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Job completed successfully!"),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    "Completed",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}