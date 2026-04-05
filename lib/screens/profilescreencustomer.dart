import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreenCustomer extends StatefulWidget {
  const ProfileScreenCustomer({super.key});

  @override
  State<ProfileScreenCustomer> createState() =>
      _ProfileScreenCustomerState();
}

class _ProfileScreenCustomerState
    extends State<ProfileScreenCustomer> {

  final user = FirebaseAuth.instance.currentUser;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  bool isLoading = true;
  bool isEditing = false; // 🔥 NEW

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  /// 🔥 LOAD USER DATA
  Future<void> loadUserData() async {
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    if (doc.exists) {
      final data = doc.data()!;

      nameController.text = data['name'] ?? '';
      emailController.text = data['email'] ?? '';
    }

    setState(() => isLoading = false);
  }

  /// 🔥 UPDATE PROFILE
  Future<void> updateProfile() async {
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'name': nameController.text,
        'email': emailController.text,
      });

      await user!.updateEmail(emailController.text);

      if (newPasswordController.text.isNotEmpty) {
        await user!.updatePassword(newPasswordController.text);
      }

      setState(() => isEditing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              /// TITLE
              const Text(
                "My Profile",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              /// AVATAR
              const CircleAvatar(
                radius: 45,
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, size: 40, color: Colors.white),
              ),

              const SizedBox(height: 10),

              Text(
                nameController.text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Text(emailController.text),

              const SizedBox(height: 25),

              /// FORM CARD
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [

                    _inputField("Name", nameController),
                    const SizedBox(height: 15),

                    _inputField("Email", emailController),
                    const SizedBox(height: 15),

                    _inputField("Current Password",
                        currentPasswordController,
                        isPassword: true),
                    const SizedBox(height: 15),

                    _inputField("New Password",
                        newPasswordController,
                        isPassword: true),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// 🔥 BUTTONS
              Row(
                children: [

                  /// EDIT BUTTON
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          isEditing = true;
                        });
                      },
                      child: const Text("Edit Profile"),
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// SAVE BUTTON
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isEditing ? updateProfile : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 INPUT FIELD (ENABLE/DISABLE)
  Widget _inputField(
      String label,
      TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      enabled: isEditing, // 🔥 KEY FEATURE
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor:
            isEditing ? Colors.white : Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}