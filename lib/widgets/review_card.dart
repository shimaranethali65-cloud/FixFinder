import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ReviewCard extends StatelessWidget {
  final String reviewerName;
  final double rating;
  final String reviewText;

  const ReviewCard({
    super.key,
    required this.reviewerName,
    required this.rating,
    required this.reviewText,
  });

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, 2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.circleBlue,
            child: Text(
              _initials(reviewerName),
              style: const TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      reviewerName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: List.generate(5, (i) {
                        return Icon(
                          i < rating.floor()
                              ? Icons.star
                              : (i < rating
                                    ? Icons.star_half
                                    : Icons.star_border),
                          size: 13,
                          color: AppColors.starYellow,
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  reviewText,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
