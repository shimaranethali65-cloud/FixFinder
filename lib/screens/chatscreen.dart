import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),

      body: Column(
        children: [

          const SizedBox(height: 20),

          /// Name box
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              "John (Plumber)",
              style: TextStyle(color: Colors.white),
            ),
          ),

          const SizedBox(height: 20),

          /// Message from worker
          Container(
            margin: const EdgeInsets.only(left: 20, bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text("I can come in 30 minutes"),
          ),

          /// Message from customer
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.only(right: 20, bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text("Okay come fast"),
            ),
          ),

          const Spacer(),

          /// Input field
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Type here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                suffixIcon: const Icon(Icons.send),
              ),
            ),
          ),
        ],
      ),
    );
  }
}