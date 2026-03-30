import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final Color _primaryBlue = const Color(0xFF3D7BE0);
  final Color _borderBlue = const Color(0xFF6C9BFF);

  String _selectedRole = 'Customer';

  // ✅ Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // ✅ Firebase Signup Function
  Future<void> signUpUser() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        nameController.text.isEmpty) {
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

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

    if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup Successful")),
      );

      if (_selectedRole == 'Customer') {
  Navigator.pushReplacementNamed(context, '/home');
} else {
  Navigator.pushReplacementNamed(context, '/workerHome'); // future screen
}
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Signup Failed")),
      );
    }
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
                          // NAME
                          const Text('Name'),
                          const SizedBox(height: 6),
                          _StyledTextField(
                            borderBlue: _borderBlue,
                            controller: nameController,
                          ),

                          const SizedBox(height: 10),

                          // EMAIL
                          const Text('Email'),
                          const SizedBox(height: 6),
                          _StyledTextField(
                            borderBlue: _borderBlue,
                            controller: emailController,
                          ),

                          const SizedBox(height: 10),

                          // PASSWORD
                          const Text('Password'),
                          const SizedBox(height: 6),
                          _StyledTextField(
                            borderBlue: _borderBlue,
                            obscureText: true,
                            controller: passwordController,
                          ),

                          const SizedBox(height: 10),

                          // CONFIRM PASSWORD
                          const Text('Confirm Password'),
                          const SizedBox(height: 6),
                          _StyledTextField(
                            borderBlue: _borderBlue,
                            obscureText: true,
                            controller: confirmPasswordController,
                          ),

                          const SizedBox(height: 14),

                          // ROLE
                          const Text('Select Role'),
                          const SizedBox(height: 4),

                          _RoleOption(
                            label: 'Customer',
                            value: _selectedRole == 'Customer',
                            onChanged: () {
                              setState(() {
                                _selectedRole = 'Customer';
                              });
                            },
                          ),

                          _RoleOption(
                            label: 'Worker',
                            value: _selectedRole == 'Worker',
                            onChanged: () {
                              setState(() {
                                _selectedRole = 'Worker';
                              });
                            },
                          ),

                          const SizedBox(height: 14),

                          // BUTTON
                          Center(
                            child: SizedBox(
                              width: 150,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: signUpUser,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _primaryBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('Sign Up'),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // LOGIN LINK
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
          Checkbox(
            value: value,
            onChanged: (_) => onChanged(),
            activeColor: const Color(0xFF3D7BE0),
          ),
          Text(label),
        ],
      ),
    );
  }
}