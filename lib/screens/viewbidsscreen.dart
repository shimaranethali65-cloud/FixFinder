import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_colors.dart';
import '../widgets/active_job_card.dart';
import '../widgets/worker_bid_card.dart';

class ViewBidsScreen extends StatelessWidget {
  final String jobId; // pass this when navigating

  const ViewBidsScreen({super.key, required this.jobId});

  Color _avatarColor(String name) {
    final colors = [
      AppColors.avatarBlue,
      AppColors.avatarGreen,
      AppColors.avatarRed,
      AppColors.avatarOrange,
      AppColors.avatarPurple,
    ];
    return colors[name.hashCode % colors.length];
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    // Fetch the job doc to show in the banner
    final jobRef = FirebaseFirestore.instance.collection('jobs').doc(jobId);
    // Fetch bids subcollection
    final bidsRef = FirebaseFirestore.instance
    .collection('bids')
    .where('jobId', isEqualTo: jobId);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Worker Bids',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: jobRef.snapshots(),
        builder: (context, jobSnap) {
          if (!jobSnap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final jobData = jobSnap.data!.data() as Map<String, dynamic>? ?? {};
          final jobTitle = jobData['title'] ?? 'No Title';
          final jobStatus = jobData['status'] ?? 'Waiting for Bids';

          return StreamBuilder<QuerySnapshot>(
            stream: bidsRef.orderBy('createdAt', descending: true).snapshots(),
            builder: (context, bidsSnap) {
              if (!bidsSnap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final bids = bidsSnap.data!.docs;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    ActiveJobCard(jobTitle: jobTitle, status: jobStatus),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${bids.length} Bids Received',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        Row(
                          children: const [
                            Text(
                              'Sort',
                              style: TextStyle(
                                color: AppColors.primaryBlue,
                                fontSize: 14,
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: AppColors.primaryBlue,
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Expanded(
                      child: ListView.separated(
                        itemCount: bids.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final data =
                              bids[i].data() as Map<String, dynamic>;
                          final workerName = data['workerEmail'] ?? 'Worker';

                          return WorkerBidCard(
                            name: workerName,
                            initials: _initials(workerName),
                            avatarColor: _avatarColor(workerName),
                            rating:
                                (data['rating'] ?? 4.6).toDouble(),
                            profession:
                                data['profession'] ?? 'Worker',
                            price: double.tryParse(data['price'].toString()) ?? 0,
                            isTopRated: data['isTopRated'] ?? false,
                            onViewProfile: () {
                              Navigator.pushNamed(
                                context,
                                '/workerProfile',
                                arguments: {
                                  'workerId': data['workerId'],
                                  'workerName': workerName,
                                },
                              );
                            },
                            onSelect: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(14),
                                  ),
                                  title: Text('Select $workerName?'),
                                  content: Text(
                                    'Assign this job to $workerName for \$${data['price']}?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            AppColors.primaryBlue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text(
                                        'Confirm',
                                        style: TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                await jobRef.update({
  'assignedTo': data['workerId'],        
  'assignedPrice': data['price'],      
  'status': 'assigned',                  
  'selectedWorkerName': workerName,      
});

// 🔥 2. CREATE CHAT (THIS IS NEW)
  final chatId = jobId;

  final chatRef = FirebaseFirestore.instance
      .collection('chats')
      .doc(chatId);

  await chatRef.set({
    'jobId': jobId,
    'customerId': jobData['postedById'], // 👈 IMPORTANT
    'workerId': data['workerId'],
    'lastMessage': '',
    'timestamp': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));
                                                          
  // 🔹 3. UI FEEDBACK
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$workerName selected!'),
        backgroundColor: AppColors.primaryBlue,
      ),
    );
  }
}
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          '$workerName selected!'),
                                      backgroundColor:
                                          AppColors.primaryBlue,
                                    ),
                                  );
                                }
                              }
                            ,
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),
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