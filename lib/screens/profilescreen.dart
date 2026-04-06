import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'editprofilescreen.dart';

class ProfileScreen extends StatefulWidget {
  final String name;
  final String role;
  final String email;
  final int jobsCompleted;
  final double rating;
  final int reviewsCount;
  final bool isVerified;
  final bool isPro;

  const ProfileScreen({
    super.key,
    this.name = 'Alex Don',
    this.role = 'Plumber',
    this.email = 'alexd@gmail.com',
    this.jobsCompleted = 85,
    this.rating = 4.9,
    this.reviewsCount = 83,
    this.isVerified = true,
    this.isPro = true,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _name;
  late String _role;
  late String _email;
  late int _jobsCompleted;
  late double _rating;
  late int _reviewsCount;
  late bool _isVerified;
  late bool _isPro;

  User? _user;
  Stream<DocumentSnapshot<Map<String, dynamic>>>? _profileStream;

  @override
  void initState() {
    super.initState();
    _name = widget.name;
    _role = widget.role;
    _email = widget.email;
    _jobsCompleted = widget.jobsCompleted;
    _rating = widget.rating;
    _reviewsCount = widget.reviewsCount;
    _isVerified = widget.isVerified;
    _isPro = widget.isPro;

    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _profileStream = FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color borderBlue = Color(0xFF7AA7FF);
    const Color lightBlue = Color(0xFF4DA6FF);
    const Color darkBlue = Color(0xFF0A63C9);

    Widget bodyForProfile({
      required String name,
      required String role,
      required String email,
      required int jobsCompleted,
      required double rating,
      required int reviewsCount,
      required bool isVerified,
      required bool isPro,
    }) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        child: Column(
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [lightBlue, darkBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.25),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 42,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isVerified)
                  _Badge(
                    text: 'Verified',
                    color: const Color(0xFF35B64A),
                    icon: Icons.verified,
                    background: const Color(0xFFE4F8E8),
                  ),
                if (isVerified && isPro) const SizedBox(width: 8),
                if (isPro)
                  _Badge(
                    text: 'Pro',
                    color: const Color(0xFFF5A623),
                    icon: Icons.workspace_premium,
                    background: const Color(0xFFFFF1D6),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: List.generate(5, (index) {
                    final threshold = index + 1;
                    final icon = rating >= threshold
                        ? Icons.star
                        : rating >= (threshold - 0.5)
                            ? Icons.star_half
                            : Icons.star_border;
                    return Icon(
                      icon,
                      size: 16,
                      color: const Color(0xFFFFB300),
                    );
                  }),
                ),
                const SizedBox(width: 6),
                Text(
                  '${rating.toStringAsFixed(1)} ($reviewsCount Reviews)',
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _InfoTile(
              icon: Icons.construction,
              label: 'Role :',
              value: role,
              borderColor: borderBlue,
            ),
            const SizedBox(height: 10),
            _InfoTile(
              icon: Icons.assignment_turned_in,
              label: 'Jobs Completed :',
              value: jobsCompleted.toString(),
              borderColor: borderBlue,
            ),
            const SizedBox(height: 10),
            _InfoTile(
              icon: Icons.alternate_email,
              label: 'Email :',
              value: email,
              borderColor: borderBlue,
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: 180,
              height: 40,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final updated = await Navigator.of(context)
                      .push<ProfileUpdate>(
                    MaterialPageRoute(
                      builder: (_) => EditProfileScreen(
                        initialName: name,
                        initialRole: role,
                        initialEmail: email,
                      ),
                    ),
                  );
                  if (updated == null) return;
                  if (_user != null) {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(_user!.uid)
                        .set(
                      {
                        'name': updated.name,
                        'role': updated.role,
                        'email': updated.email,
                      },
                      SetOptions(merge: true),
                    );
                  }
                  setState(() {
                    _name = updated.name;
                    _role = updated.role;
                    _email = updated.email;
                  });
                },
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Edit Profile'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: borderBlue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: 150,
              height: 40,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF2B2B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: _profileStream == null
            ? bodyForProfile(
                name: _name,
                role: _role,
                email: _email,
                jobsCompleted: _jobsCompleted,
                rating: _rating,
                reviewsCount: _reviewsCount,
                isVerified: _isVerified,
                isPro: _isPro,
              )
            : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: _profileStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return bodyForProfile(
                      name: _name,
                      role: _role,
                      email: _email,
                      jobsCompleted: _jobsCompleted,
                      rating: _rating,
                      reviewsCount: _reviewsCount,
                      isVerified: _isVerified,
                      isPro: _isPro,
                    );
                  }
                  final data = snapshot.data?.data();
                  final name = (data?['name'] as String?) ?? _name;
                  final role = (data?['role'] as String?) ?? _role;
                  final email = (data?['email'] as String?) ??
                      _user?.email ??
                      _email;
                  final jobsCompleted =
                      (data?['jobsCompleted'] as int?) ?? _jobsCompleted;
                  final rating = (data?['rating'] as num?)?.toDouble() ?? _rating;
                  final reviewsCount =
                      (data?['reviewsCount'] as int?) ?? _reviewsCount;
                  final isVerified =
                      (data?['isVerified'] as bool?) ?? _isVerified;
                  final isPro = (data?['isPro'] as bool?) ?? _isPro;

                  return bodyForProfile(
                    name: name,
                    role: role,
                    email: email,
                    jobsCompleted: jobsCompleted,
                    rating: rating,
                    reviewsCount: reviewsCount,
                    isVerified: isVerified,
                    isPro: isPro,
                  );
                },
              ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  final Color background;
  final IconData icon;

  const _Badge({
    required this.text,
    required this.color,
    required this.background,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color borderColor;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: borderColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: borderColor),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
