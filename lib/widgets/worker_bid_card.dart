import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'app_button.dart';

class WorkerBidCard extends StatelessWidget {
  final String name;
  final String initials;
  final Color avatarColor;
  final double rating;
  final String profession;
  final double price;
  final bool isTopRated;
  final VoidCallback onViewProfile;
  final VoidCallback onSelect;

  const WorkerBidCard({
    super.key,
    required this.name,
    required this.initials,
    required this.avatarColor,
    required this.rating,
    required this.profession,
    required this.price,
    this.isTopRated = true,
    required this.onViewProfile,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 22,
                backgroundColor: avatarColor,
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Name + badge + rating
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (isTopRated)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.badgeBlueBg,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Top Rated',
                              style: TextStyle(
                                color: AppColors.primaryBlue,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Row(
                          children: List.generate(
                            5,
                            (_) => const Icon(
                              Icons.star,
                              color: AppColors.starYellow,
                              size: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$rating · $profession',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${price.toInt()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'per job',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Buttons — reuse AppButton
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'View Profile',
                  onPressed: onViewProfile,
                  variant: AppButtonVariant.outlined,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppButton(
                  label: 'Select',
                  onPressed: onSelect,
                  variant: AppButtonVariant.filled,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
