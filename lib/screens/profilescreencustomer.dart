import 'package:flutter/material.dart';

class ProfileScreenCustomer extends StatefulWidget {
  const ProfileScreenCustomer({super.key});

  @override
  State<ProfileScreenCustomer> createState() => _ProfileScreenCustomerState();
}

class _ProfileScreenCustomerState extends State<ProfileScreenCustomer> {

  final TextEditingController nameController =
      TextEditingController(text: "John Smith");

  final TextEditingController emailController =
      TextEditingController(text: "john@gmail.com");

  final TextEditingController phoneController =
      TextEditingController(text: "0774384959");

  final TextEditingController currentPasswordController =
      TextEditingController();

  final TextEditingController newPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        leading: const Icon(Icons.arrow_back),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [

              const CircleAvatar(
                radius: 40,
                child: Icon(Icons.person, size: 40),
              ),

              const SizedBox(height: 10),

              Text(
                nameController.text,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),

              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
              ),

              TextField(
                controller: currentPasswordController,
                decoration: const InputDecoration(labelText: "Current Password"),
                obscureText: true,
              ),

              TextField(
                controller: newPasswordController,
                decoration: const InputDecoration(labelText: "New Password"),
                obscureText: true,
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  ElevatedButton(
                    onPressed: () {
                      print("Edit Profile clicked");
                    },
                    child: const Text("Edit Profile"),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      saveChanges();
                    },
                    child: const Text("Save Changes"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void saveChanges() {
    print("Email: ${emailController.text}");
    print("Phone: ${phoneController.text}");
    print("New Password: ${newPasswordController.text}");
  }
}
