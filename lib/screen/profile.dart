import 'dart:ui';
import 'package:customer_ui/screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Color get _accent => const Color.fromARGB(255, 241, 91, 91); // deep blue
  Color get _accentSoft => const Color.fromARGB(255, 253, 72, 72);

  void _goHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final khmerTitle = GoogleFonts.notoSansKhmer(
      fontSize: 16,
      fontWeight: FontWeight.w700,
    );
    final khmerBody = GoogleFonts.notoSansKhmer(fontSize: 14, height: 1.4);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "គណនីរបស់ខ្ញុំ",
          style: GoogleFonts.notoSansKhmer(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        actions: [
          // Premium badge
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white.withOpacity(0.35)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.workspace_premium_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'VIP',
                    style: GoogleFonts.notoSansKhmer(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            tooltip: 'Back to Home',
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            onPressed: _goHome,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Gradient header background
          Container(
            height: 280,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_accent, _accentSoft],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Decorative glows
          Positioned(
            right: -40,
            top: -30,
            child: _GlowCircle(
              color: Colors.white.withOpacity(0.18),
              size: 160,
            ),
          ),
          Positioned(
            left: -30,
            top: 100,
            child: _GlowCircle(
              color: Colors.white.withOpacity(0.12),
              size: 120,
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _HeaderCard(
                    accent: _accent,
                    name: 'សួស្តី! Dom',
                    tier: 'សមាជិក VIP',
                  ),

                  const SizedBox(height: 14),

                  _FrostedCard(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _ProfileStat(
                            title: 'កាក់',
                            value: '123',
                            accent: _accent,
                          ),
                          _DividerDot(),
                          _ProfileStat(
                            title: 'ប័ណ្ណបញ្ចុះតម្លៃ',
                            value: '5',
                            accent: _accent,
                          ),
                          _DividerDot(),
                          _ProfileStat(
                            title: 'ពិន្ទុ',
                            value: '248',
                            accent: _accent,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  _SectionHeader(
                    title: "ការបញ្ជាទិញរបស់ខ្ញុំ",
                    style: khmerTitle,
                  ),

                  _FrostedCard(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          _OrderItem(icon: Icons.payment, label: "កំពុងបង់"),
                          _OrderItem(
                            icon: Icons.local_shipping,
                            label: "កំពុងដឹក",
                          ),
                          _OrderItem(
                            icon: Icons.check_circle,
                            label: "បានទទួល",
                          ),
                          _OrderItem(icon: Icons.replay, label: "ដាក់សំណើ"),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  _SectionHeader(title: "ជម្រើសផ្សេងទៀត", style: khmerTitle),

                  _FrostedListTile(
                    leading: Icons.location_on,
                    title: "អាសយដ្ឋានការដឹក",
                    subtitle: "កែប្រែ ឬ បន្ថែមអាសយដ្ឋាន",
                    onTap: () {},
                    bodyStyle: khmerBody,
                    accent: _accent,
                  ),
                  _FrostedListTile(
                    leading: Icons.favorite,
                    title: "ចូលចិត្ត",
                    subtitle: "ផលិតផលដែលបានសម្គាល់ចិត្ត",
                    onTap: () {},
                    bodyStyle: khmerBody,
                    accent: _accent,
                  ),
                  _FrostedListTile(
                    leading: Icons.chat_bubble_outline_rounded,
                    title: "ជជែកជាមួយលក់",
                    subtitle: "ទំនាក់ទំនងអ្នកលក់រហ័ស",
                    onTap: () {},
                    bodyStyle: khmerBody,
                    accent: _accent,
                  ),
                  _FrostedListTile(
                    leading: Icons.settings,
                    title: "ការកំណត់",
                    subtitle: "ប្រែភាសា សុវត្ថិភាព និងផ្សេងៗ",
                    onTap: () {},
                    bodyStyle: khmerBody,
                    accent: _accent,
                  ),
                  _FrostedListTile(
                    leading: Icons.help_outline,
                    title: "ជំនួយ និងគាំទ្រ",
                    subtitle: "សំណួរញឹកញាប់ និងទំនាក់ទំនង",
                    onTap: () {},
                    bodyStyle: khmerBody,
                    accent: _accent,
                  ),

                  const SizedBox(height: 20),

                  // Prominent Back to Home
                  SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _goHome,
                      icon: const Icon(Icons.home_rounded, color: Colors.white),
                      label: Text(
                        'ត្រឡប់ទៅទំព័រដើម',
                        style: GoogleFonts.notoSansKhmer(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ---------- Premium Building Blocks ---------- */

class _HeaderCard extends StatelessWidget {
  final Color accent;
  final String name;
  final String tier;

  const _HeaderCard({
    required this.accent,
    required this.name,
    required this.tier,
  });

  @override
  Widget build(BuildContext context) {
    return _FrostedCard(
      blurSigma: 22,
      opacity: 0.55,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar with gradient ring
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [accent, Colors.lightBlueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const CircleAvatar(
                radius: 36,
                backgroundImage: AssetImage('assets/IMG_7469.JPG'),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.notoSansKhmer(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.workspace_premium_rounded,
                        size: 16,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        tier,
                        style: GoogleFonts.notoSansKhmer(
                          fontSize: 13,
                          color: Colors.black.withOpacity(0.65),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String title;
  final String value;
  final Color accent;
  const _ProfileStat({
    required this.title,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.notoSansKhmer(
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: GoogleFonts.notoSansKhmer(
            fontSize: 12,
            color: Colors.black.withOpacity(0.55),
          ),
        ),
      ],
    );
  }
}

class _DividerDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      width: 1.2,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _OrderItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _OrderItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.04),
          ),
          child: Icon(icon, size: 22, color: Colors.black.withOpacity(0.75)),
        ),
        const SizedBox(height: 6),
        Text(label, style: GoogleFonts.notoSansKhmer(fontSize: 12)),
      ],
    );
  }
}

class _FrostedListTile extends StatelessWidget {
  final IconData leading;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final TextStyle bodyStyle;
  final Color accent;

  const _FrostedListTile({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.bodyStyle,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return _FrostedCard(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [accent.withOpacity(0.12), Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(leading, color: accent, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.notoSansKhmer(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: bodyStyle.copyWith(
                        fontSize: 12,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.black54,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final TextStyle? style;
  const _SectionHeader({required this.title, this.style});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 10, 4, 6),
      child: Text(title, style: style),
    );
  }
}

/// Subtle background glow circle
class _GlowCircle extends StatelessWidget {
  final Color color;
  final double size;
  const _GlowCircle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [BoxShadow(color: color, blurRadius: 60, spreadRadius: 20)],
      ),
    );
  }
}

/// Reusable frosted glass container
class _FrostedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final double blurSigma;
  final double opacity;

  const _FrostedCard({
    required this.child,
    this.margin,
    this.blurSigma = 18,
    this.opacity = 0.55,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(opacity),
              border: Border.all(
                color: Colors.white.withOpacity(0.65),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
