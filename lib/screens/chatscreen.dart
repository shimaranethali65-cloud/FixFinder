import 'package:flutter/material.dart';
import 'ratingscreen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Previous page ekata yanna
          },
        ),
        title: const Text("Chat"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),

          // Name box
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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

          // Messages list with scroll support
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: const [
                // Incoming message
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text("I can come in 30 minutes"),
                  ),
                ),
                // Outgoing message
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("Okay come fast"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Input box
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Type here...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    // Navigate to Rating Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RatingScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
