import 'package:flutter/material.dart';

class MyJobsScreen extends StatelessWidget {
  const MyJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const jobs = <String>[
      'Installed new kitchen sink',
      'Repaired leaking shower head',
      'Fixed toilet flush system',
      'Sealed pipe joint leak',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'My Jobs',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  _GradientIconCircle(),
                  SizedBox(width: 12),
                  Text(
                    'Jobs You Completed',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Expanded(
                child: ListView.separated(
                  itemCount: jobs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 18),
                  itemBuilder: (context, index) {
                    return _CompletedJobCard(title: jobs[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompletedJobCard extends StatelessWidget {
  const _CompletedJobCard({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2F7CFF), width: 1.6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const _GradientCheckBadge(),
        ],
      ),
    );
  }
}

class _GradientIconCircle extends StatelessWidget {
  const _GradientIconCircle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF23D26B), Color(0xFF0AA84F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Icon(Icons.check, color: Colors.white, size: 18),
    );
  }
}

class _GradientCheckBadge extends StatelessWidget {
  const _GradientCheckBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF2E86FF), Color(0xFF1CCB5C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(Icons.check, color: Colors.white, size: 18),
    );
  }
}
