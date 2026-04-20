import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SWErrorWidget extends StatelessWidget {
  const SWErrorWidget({super.key, required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SIGNAL PERDU',
              style: GoogleFonts.barlowCondensed(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 4),
            Container(height: 2, width: 60, color: const Color(0xFFFFE301)),
            const SizedBox(height: 16),
            Text(
              message,
              style: GoogleFonts.barlowCondensed(
                fontSize: 13,
                color: const Color(0xFF666666),
                height: 1.6,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                color: const Color(0xFFFFE301),
                child: Text(
                  'RÉESSAYER',
                  style: GoogleFonts.barlowCondensed(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    letterSpacing: 3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}