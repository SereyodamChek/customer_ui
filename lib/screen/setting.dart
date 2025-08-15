import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool _notification = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF2F2F7); // iOS grouped background

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.blue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "ការកំណត់",
          style: GoogleFonts.siemreap(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // Profile card (like iCloud banner in iOS Settings)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                child: _CardGroup(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {}, // TODO
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.blue[100],
                              child: const Icon(
                                FontAwesomeIcons.solidUser,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "ឈ្មោះអ្នកប្រើ",
                                    style: GoogleFonts.siemreap(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "ព័ត៌មានគណនី និងសន្តិសុខ",
                                    style: GoogleFonts.siemreap(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              CupertinoIcons.chevron_forward,
                              size: 18,
                              color: Colors.black38,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Account section
            SliverToBoxAdapter(child: _SectionHeader(title: "គ្រប់គ្រងគណនី")),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _CardGroup(
                  children: [
                    _SettingTile(
                      leadingBg: Colors.blue,
                      leadingIcon: FontAwesomeIcons.solidUser,
                      title: "ព័ត៌មានគណនី",
                      subtitle: "កែប្រែព័ត៌មានផ្ទាល់ខ្លួន",
                    ),
                    _DividerThin(),
                    _SettingTile(
                      leadingBg: Colors.orange,
                      leadingIcon: FontAwesomeIcons.lock,
                      title: "ផ្លាស់ប្តូរពាក្យសម្ងាត់",
                    ),
                    _DividerThin(),
                    _SettingTile(
                      leadingBg: Colors.green,
                      leadingIcon: FontAwesomeIcons.language,
                      title: "ភាសា",
                      subtitle: "ភាសាខ្មែរ / English",
                    ),
                  ],
                ),
              ),
            ),

            // Notifications section
            SliverToBoxAdapter(child: _SectionHeader(title: "ការជូនដំណឹង")),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _CardGroup(
                  children: [
                    _SettingSwitchTile(
                      leadingBg: Colors.red,
                      leadingIcon: FontAwesomeIcons.solidBellSlash,
                      title: "បើកការជូនដំណឹង",
                      value: _notification,
                      onChanged: (v) => setState(() => _notification = v),
                    ),
                  ],
                ),
              ),
            ),

            // Appearance section
            SliverToBoxAdapter(child: _SectionHeader(title: "រចនាប័ទ្ម")),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _CardGroup(
                  children: [
                    _SettingSwitchTile(
                      leadingBg: Colors.purple,
                      leadingIcon: FontAwesomeIcons.moon,
                      title: "រចនាប័ទ្មងងឹត",
                      value: _darkMode,
                      onChanged: (v) => setState(() => _darkMode = v),
                    ),
                  ],
                ),
              ),
            ),

            // Others
            SliverToBoxAdapter(child: _SectionHeader(title: "ផ្សេងៗ")),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _CardGroup(
                  children: [
                    _SettingTile(
                      leadingBg: Colors.indigo,
                      leadingIcon: FontAwesomeIcons.questionCircle,
                      title: "ជំនួយ និងគាំទ្រ",
                    ),
                    _DividerThin(),
                    _SettingTile(
                      leadingBg: Colors.teal,
                      leadingIcon: FontAwesomeIcons.info,
                      title: "អំពីកម្មវិធី",
                    ),
                    _DividerThin(),
                    _SettingTile(
                      leadingBg: Colors.red,
                      leadingIcon: FontAwesomeIcons.arrowRightFromBracket,
                      title: "ចាកចេញ",
                      titleColor: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

// ---------- UI Blocks with Khmer OS Siemreap font ----------

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 6),
      child: Text(
        title,
        style: GoogleFonts.siemreap(
          fontSize: 13,
          color: Colors.black54,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _CardGroup extends StatelessWidget {
  final List<Widget> children;
  const _CardGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        color: Colors.white,
        child: Column(children: children),
      ),
    );
  }
}

class _DividerThin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 0.3, indent: 56);
  }
}

class _SettingTile extends StatelessWidget {
  final Color leadingBg;
  final IconData leadingIcon;
  final String title;
  final String? subtitle;
  final bool showChevron;
  final Color? titleColor;

  const _SettingTile({
    required this.leadingBg,
    required this.leadingIcon,
    required this.title,
    this.subtitle,
    this.showChevron = true,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: leadingBg.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(leadingIcon, size: 18, color: leadingBg),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.siemreap(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: titleColor ?? Colors.black,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: GoogleFonts.siemreap(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                ],
              ),
            ),
            if (showChevron)
              const Icon(
                CupertinoIcons.chevron_forward,
                size: 18,
                color: Colors.black38,
              ),
          ],
        ),
      ),
    );
  }
}

class _SettingSwitchTile extends StatelessWidget {
  final Color leadingBg;
  final IconData leadingIcon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingSwitchTile({
    required this.leadingBg,
    required this.leadingIcon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: leadingBg.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(leadingIcon, size: 18, color: leadingBg),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.siemreap(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeColor: CupertinoColors.activeGreen,
          ),
        ],
      ),
    );
  }
}
