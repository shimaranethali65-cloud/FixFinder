import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubmitBidPage extends StatefulWidget {
  final String jobId;

  const SubmitBidPage({super.key, required this.jobId});

  @override
  State<SubmitBidPage> createState() => _SubmitBidPageState();
}

class _SubmitBidPageState extends State<SubmitBidPage> {
  final TextEditingController priceController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  bool isLoading = false;

  Future<void> submitBid() async {
    final user = FirebaseAuth.instance.currentUser;

    if (priceController.text.isEmpty || messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    String bidId = DateTime.now().millisecondsSinceEpoch.toString();

    await FirebaseFirestore.instance.collection('bids').doc(bidId).set({
      'bidId': bidId,
      'jobId': widget.jobId,
      'price': priceController.text,
      'message': messageController.text,
      'workerEmail': user?.email,
      'workerId': user?.uid,
      'createdAt': Timestamp.now(),
    });

    setState(() => isLoading = false);

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Bid submitted successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Submit Bid",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 💰 PRICE CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color.fromARGB(255, 245, 246, 247), Color.fromARGB(255, 253, 253, 253)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.attach_money, color: Color.fromARGB(255, 13, 13, 13)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Color.fromARGB(255, 13, 13, 13)),
                      decoration: const InputDecoration(
                        hintText: "Enter your price",
                        hintStyle: TextStyle(color: Color.fromARGB(179, 15, 15, 15)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 💬 MESSAGE CARD
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                  )
                ],
              ),
              child: TextField(
                controller: messageController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: "Write your message...",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// 🔵 SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : submitBid,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Submit Bid",
                        style: TextStyle(fontSize: 16,color: Colors.white,),
                      ),
              ),
            ),

            const SizedBox(height: 30),

            /// 🎨 IMAGE
            Expanded(
              child: Center(
                child: Image.asset(
                  "assets/images/submitbid.png",
                  height: 250,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}