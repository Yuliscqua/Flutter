import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SWLoadingWidget extends StatelessWidget {
  const SWLoadingWidget({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              backgroundColor: Color(0xFF111111),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFE301)),
              minHeight: 2,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: GoogleFonts.barlowCondensed(
              fontSize: 11,
              color: const Color(0xFF666666),
              letterSpacing: 4,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}