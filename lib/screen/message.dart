import 'dart:ui';
import 'package:customer_ui/screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  void _goHome(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = const Color.fromARGB(255, 255, 77, 77);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'សាររបស់អ្នក', // "Your Messages"
          style: GoogleFonts.notoSansKhmer(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFFFF3E0),
                  const Color.fromARGB(255, 255, 129, 129),
                  accent.withOpacity(0.20),
                ],
              ),
            ),
          ),

          // Content in center
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.6),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 64,
                          width: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                accent,
                                const Color.fromARGB(255, 243, 76, 76),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Icon(
                            Icons.mark_chat_unread_rounded,
                            color: Colors.white,
                            size: 34,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'មិនមានសារ', // "No messages"
                          style: GoogleFonts.notoSansKhmer(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'សាររបស់អ្នកនឹងបង្ហាញនៅទីនេះពេលមាន។',
                          style: GoogleFonts.notoSansKhmer(
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.65),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Back to Home button fixed at bottom
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: accent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              ),
              child: Text(
                'ត្រឡប់ទៅទំព័រដើម', // Back to Home
                style: GoogleFonts.notoSansKhmer(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
