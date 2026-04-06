import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_colors.dart';
import '../widgets/app_button.dart';
import '../widgets/stat_badge.dart';
import '../widgets/info_row.dart';
import '../widgets/review_card.dart';

class ViewProfileScreen extends StatelessWidget {
  final String workerId;
  final String workerName;
  final double bidPrice;

  const ViewProfileScreen({
    super.key,
    required this.workerId,
    required this.workerName,
    required this.bidPrice,
  });

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, 2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final workerRef =
        FirebaseFirestore.instance.collection('workers').doc(workerId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Worker Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: workerRef.snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snap.data!.data() as Map<String, dynamic>? ?? {};
          final name       = data['name']        ?? workerName;
          final location   = data['location']    ?? 'Sri Lanka';
          final profession = data['profession']  ?? 'Worker';
          final rating     = (data['rating']     ?? 4.6).toDouble();
          final jobsDone   = data['jobsDone']    ?? 0;
          final successPct = data['successPct']  ?? '98%';
          final isVerified = data['isVerified']  ?? false;
          final isPro      = data['isPro']       ?? false;
          final serviceArea= data['serviceArea'] ?? 'N/A';
          final reviews    = List<Map<String, dynamic>>.from(
              data['reviews'] ?? []);

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // ── Avatar + name + location ──
                      Center(
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: AppColors.primaryBlue,
                                  child: Text(
                                    _initials(name),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 2,
                                  right: 2,
                                  child: Container(
                                    width: 14,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.location_on,
                                    size: 14, color: Colors.redAccent),
                                const SizedBox(width: 3),
                                Text(
                                  location,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Badges row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _PillBadge(
                                    label: profession,
                                    color: AppColors.badgeBlueBg,
                                    textColor: AppColors.primaryBlue),
                                if (isVerified) ...[
                                  const SizedBox(width: 8),
                                  _PillBadge(
                                    label: '✓ Verified',
                                    color: const Color(0xFFE6F9F0),
                                    textColor: const Color(0xFF27AE60),
                                  ),
                                ],
                                if (isPro) ...[
                                  const SizedBox(width: 8),
                                  _PillBadge(
                                    label: '🔥 Pro',
                                    color: const Color(0xFFFFF3E0),
                                    textColor: const Color(0xFFF57C00),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Stats row ──
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F9FF),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            StatBadge(
                                value: rating.toString(), label: 'Rating'),
                            _divider(),
                            StatBadge(
                                value: jobsDone.toString(),
                                label: 'Jobs Done'),
                            _divider(),
                            StatBadge(
                                value: successPct.toString(),
                                label: 'Success'),
                            _divider(),
                            StatBadge(
                                value: '\$${bidPrice.toInt()}',
                                label: 'Bid'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── About section ──
                      const Text(
                        'ABOUT',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Divider(height: 16),
                      InfoRow(
                        icon: Icons.build_outlined,
                        label: 'Role',
                        value: profession,
                      ),
                      InfoRow(
                        icon: Icons.location_on_outlined,
                        label: 'Service Area',
                        value: serviceArea,
                      ),
                      InfoRow(
                        icon: Icons.star_outline,
                        label: 'Rating',
                        value: '$rating / 5',
                      ),
                      InfoRow(
                        icon: Icons.work_outline,
                        label: 'Jobs Completed',
                        value: '$jobsDone jobs',
                      ),

                      const SizedBox(height: 28),

                      // ── Recent Reviews ──
                      if (reviews.isNotEmpty) ...[
                        const Text(
                          'RECENT REVIEWS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const Divider(height: 16),
                        ...reviews.map((r) => ReviewCard(
                              reviewerName: r['name'] ?? 'Anonymous',
                              rating: (r['rating'] ?? 5).toDouble(),
                              reviewText: r['text'] ?? '',
                            )),
                      ],

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),

              // ── Hire button pinned at bottom ──
              /*
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: AppButton(
                  label: 'Hire Worker — \$${bidPrice.toInt()}',
                  onPressed: () {
                  },
                  width: double.infinity,
                ),
              ),
              */
            ],
          );
        },
      ),
    );
  }

  Widget _divider() => Container(
        height: 30,
        width: 1,
        color: Colors.grey.shade200,
      );
}

// ── Local pill badge widget ──
class _PillBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const _PillBadge({
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}