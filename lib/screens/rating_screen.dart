import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RatingScreen extends StatefulWidget {
  final String workerId;
  final String jobId;

  const RatingScreen({
    super.key,
    required this.workerId,
    required this.jobId,
  });

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int selectedRating = 0;
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Rate Worker"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                const SizedBox(height: 30),

                /// ⭐ CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [

                      const Text(
                        "Your work done!",
                        style: TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "How was the service?",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// ⭐ STAR RATING
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return IconButton(
                            onPressed: () {
                              setState(() {
                                selectedRating = index + 1;
                              });
                            },
                            icon: Icon(
                              Icons.star,
                              size: 35,
                              color: index < selectedRating
                                  ? Colors.orange
                                  : Colors.grey,
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 20),

                      /// ✍️ COMMENT BOX
                      TextField(
                        controller: commentController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: "Type your Comments...",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// 🔥 KEYBOARD SPACE
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom + 20,
                ),

                /// 🔵 SUBMIT BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {

                      /// ❗ CHECK RATING
                      if (selectedRating == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select a rating"),
                          ),
                        );
                        return;
                      }

                      /// ❗ CHECK WORKER ID
                      if (widget.workerId.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Invalid worker ID"),
                          ),
                        );
                        return;
                      }

                      try {
                        print("Worker ID: ${widget.workerId}");

                        final workerRef = FirebaseFirestore.instance
                            .collection('workers')
                            .doc(widget.workerId);

                        final workerSnap = await workerRef.get();

                        double currentRating =
                            (workerSnap.data()?['rating'] ?? 0).toDouble();
                        int totalRatings =
                            (workerSnap.data()?['totalRatings'] ?? 0);

                        double newRating =
                            ((currentRating * totalRatings) + selectedRating) /
                                (totalRatings + 1);

                        /// ✅ SAFE SAVE (FIXED)
                        await workerRef.set({
                          'rating': newRating,
                          'totalRatings': totalRatings + 1,
                          'reviews': FieldValue.arrayUnion([
                            {
                              'rating': selectedRating,
                              'text': commentController.text,
                              'timestamp': Timestamp.now(),
                            }
                          ])
                        }, SetOptions(merge: true));

                        /// ✅ MARK JOB AS RATED
                        await FirebaseFirestore.instance
                            .collection('jobs')
                            .doc(widget.jobId)
                            .set({'isRated': true}, SetOptions(merge: true));

                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Rating submitted successfully"),
                            backgroundColor: Colors.green,
                          ),
                        );

                        Navigator.pop(context);

                      } catch (e) {
                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error: $e"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "SUBMIT",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}