import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ✅ IMPORT YOUR HOME SCREENS
import 'homescreencustomer.dart';
import 'homescreenworker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final Color _primaryBlue = const Color(0xFF3D7BE0);
  final Color _borderBlue = const Color(0xFF6C9BFF);

  String _selectedRole = 'Customer';
  bool _isLoading = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // 🔐 SIGNUP FUNCTION
  Future<void> signUpUser() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        nameController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 🔐 Create user
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = credential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'role': _selectedRole,
          'jobsCompleted': 0,
          'rating': 0.0,
          'reviewsCount': 0,
          'isVerified': false,
          'isPro': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup Successful")),
      );

      // ✅ ROLE-BASED NAVIGATION
      if (_selectedRole == "Customer") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreenCustomer()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreenWorker()),
        );
      }

    } on FirebaseAuthException catch (e) {
      String message = "Signup Failed";

      if (e.code == 'email-already-in-use') {
        message = "Email already exists";
      } else if (e.code == 'weak-password') {
        message = "Password must be at least 6 characters";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: 2),

              const Center(
                child: Text(
                  'Create an Account',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Center(
                child: Image.asset(
                  'assets/images/SignUp.png',
                  height: 96,
                ),
              ),

              const SizedBox(height: 12),

              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 350),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(22, 18, 22, 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDFDFF),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: _borderBlue, width: 1.2),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x26000000),
                        blurRadius: 14,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 6,
                        right: 6,
                        top: 96,
                        bottom: 56,
                        child: IgnorePointer(
                          child: Center(
                            child: Opacity(
                              opacity: 0.14,
                              child: Image.asset(
                                'assets/images/SignUpBG.png',
                                width: 240,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Name'),
                          const SizedBox(height: 6),
                          _StyledTextField(
                            borderBlue: _borderBlue,
                            controller: nameController,
                          ),

                          const SizedBox(height: 10),

                          const Text('Email'),
                          const SizedBox(height: 6),
                          _StyledTextField(
                            borderBlue: _borderBlue,
                            controller: emailController,
                          ),

                          const SizedBox(height: 10),

                          const Text('Password'),
                          const SizedBox(height: 6),
                          _StyledTextField(
                            borderBlue: _borderBlue,
                            obscureText: true,
                            controller: passwordController,
                          ),

                          const SizedBox(height: 10),

                          const Text('Confirm Password'),
                          const SizedBox(height: 6),
                          _StyledTextField(
                            borderBlue: _borderBlue,
                            obscureText: true,
                            controller: confirmPasswordController,
                          ),

                          const SizedBox(height: 14),

                          const Text('Select Role'),

                          _RoleOption(
                            label: 'Customer',
                            value: _selectedRole == 'Customer',
                            onChanged: () {
                              setState(() => _selectedRole = 'Customer');
                            },
                          ),

                          _RoleOption(
                            label: 'Worker',
                            value: _selectedRole == 'Worker',
                            onChanged: () {
                              setState(() => _selectedRole = 'Worker');
                            },
                          ),

                          const SizedBox(height: 14),

                          Center(
                            child: SizedBox(
                              width: 150,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : signUpUser,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _primaryBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text('Sign Up'),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'Already have an account? ',
                                style: const TextStyle(color: Colors.black87),
                                children: [
                                  TextSpan(
                                    text: 'Login',
                                    style: TextStyle(
                                      color: _primaryBlue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(context, '/login');
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// 🔹 TextField Widget
class _StyledTextField extends StatelessWidget {
  const _StyledTextField({
    required this.borderBlue,
    this.obscureText = false,
    this.controller,
  });

  final Color borderBlue;
  final bool obscureText;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderBlue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderBlue, width: 1.5),
        ),
      ),
    );
  }
}

// 🔹 Role Option Widget
class _RoleOption extends StatelessWidget {
  const _RoleOption({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChanged,
      child: Row(
        children: [
          Radio<bool>(
            value: true,
            groupValue: value,
            onChanged: (_) => onChanged(),
            activeColor: const Color(0xFF3D7BE0),
          ),
          Text(label),
        ],
      ),
    );
  }
}
