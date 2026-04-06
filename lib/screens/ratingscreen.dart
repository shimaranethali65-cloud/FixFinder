import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RatingScreen extends StatefulWidget {
  // We pass the worker's unique ID when navigating to this screen
  final String workerId;

  const RatingScreen({super.key, required this.workerId});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _currentRating = 0; // Tracks which star is clicked
  bool _isSubmitting = false; // Prevents double-clicking the submit button

  // --- DATABASE LOGIC ---
  Future<void> _submitRating() async {
    setState(() => _isSubmitting = true);

    final workerRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.workerId);

    try {
      // Transactions ensure the count is accurate even if multiple people rate at once
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(workerRef);

        if (!snapshot.exists) {
          throw Exception("Worker document not found!");
        }

        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        // Get existing totals or default to 0
        double currentSum = data['ratingSum']?.toDouble() ?? 0.0;
        int currentCount = data['reviewCount'] ?? 0;

        // Update the document with new totals
        transaction.update(workerRef, {
          'ratingSum': currentSum + _currentRating,
          'reviewCount': currentCount + 1,
        });
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Thank you for your $_currentRating-star rating!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Go back to the previous screen
      }
    } catch (e) {
      debugPrint("Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Submission failed. Please try again.")),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // --- UI BUILDER ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rate Service"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "How was your experience?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // Interactive Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      _currentRating = index + 1;
                    });
                  },
                  icon: Icon(
                    index < _currentRating ? Icons.star : Icons.star_border,
                    size: 45,
                    color: Colors.amber,
                  ),
                );
              }),
            ),

            const SizedBox(height: 40),

            // Submit Button
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: (_currentRating == 0 || _isSubmitting)
                    ? null
                    : _submitRating,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Submit Rating",
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
