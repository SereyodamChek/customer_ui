import 'dart:convert';
import 'dart:ui'; // for BackdropFilter (glass)
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:customer_ui/controller/user_controller.dart';
import 'package:customer_ui/model/product_medel.dart';
import 'package:customer_ui/model/user_model.dart';
import 'package:customer_ui/screen/form_profile.dart';
import 'package:customer_ui/screen/message.dart';
import 'package:customer_ui/screen/other_screen.dart';
import 'package:customer_ui/screen/product_detail.dart';
import 'package:customer_ui/screen/profile.dart';
import 'package:customer_ui/screen/setting.dart';
import 'package:customer_ui/widget/login.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserModel? currentUser;

  int _currentBanner = 0;
  int _selectedIndex = 0;

  final List<String> bannerImages = [
    'assets/image_1.jpg',
    'assets/image_2.jpg',
    'assets/image_3.png',
  ];

  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.phone_android, 'label': 'Phones'},
    {'icon': Icons.computer, 'label': 'Computers'},
    {'icon': Icons.chair, 'label': 'Beds/Chairs'},
    {'icon': Icons.watch, 'label': 'Watches'},
    {'icon': Icons.sports_basketball, 'label': 'Sports'},
    {'icon': Icons.toys, 'label': 'Toys'},
  ];

  List<ProductModel> products = [];

  // Premium palette
  static const Color kPrimary = Color(0xFFEF5350);
  static const Color kPrimaryDark = Color(0xFFE53935);
  static const Color kAccent = Color(0xFFFF8A65);

  @override
  void initState() {
    super.initState();
    fetchAll();
    loadUser();
  }

  Future<void> loadUser() async {
    final users = await UserController().fetchUsers();
    if (!mounted) return;
    setState(() => currentUser = users.isNotEmpty ? users.first : null);
  }

  Future<void> fetchAll() async {
    final res = await http.get(
      Uri.parse(
        'https://post-product-beac8-default-rtdb.asia-southeast1.firebasedatabase.app/products.json',
      ),
    );
    if (!mounted) return;

    if (res.statusCode == 200 && res.body != 'null') {
      final Map<String, dynamic> data = json.decode(res.body);
      final loaded = <ProductModel>[];
      data.forEach((key, value) {
        loaded.add(ProductModel.fromJson({"id": key, ...value}));
      });
      setState(() => products = loaded);
    } else {
      setState(() => products = []);
    }
  }

  void _onTapNav(int index) {
    setState(() => _selectedIndex = index);

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OtherScreen()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MessageScreen()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Profile()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [kPrimary, kPrimaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shopping_bag_outlined, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'Online Shop',
              style: GoogleFonts.cabin(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.gear, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Setting()),
              );
            },
          ),
          IconButton(
            icon: const Icon(FontAwesomeIcons.solidBell, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    content: const AwesomeSnackbarContent(
                      title: 'Coming Soon!',
                      message: 'Notifications will be coming soon 🎉',
                      contentType: ContentType.help,
                    ),
                  ),
                );
            },
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [kPrimary, kPrimaryDark]),
              ),
              child: currentUser == null
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundImage: AssetImage('assets/IMG_7469.JPG'),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Welcome, ${currentUser!.name.isNotEmpty ? currentUser!.name : 'User'}!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          currentUser!.email.isNotEmpty
                              ? currentUser!.email
                              : 'No Email Available',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
            ),
            _drawerTile(FontAwesomeIcons.home, 'Home', () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            }),
            _drawerTile(FontAwesomeIcons.cartPlus, 'Categories', () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const OtherScreen()),
              );
            }),
            _drawerTile(FontAwesomeIcons.shoppingCart, 'Cart', () {}),
            _drawerTile(FontAwesomeIcons.userTag, 'Profile', () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const FormProfile()),
              );
            }),
            const Divider(height: 1, color: Colors.grey),
            ListTile(
              leading: const FaIcon(
                FontAwesomeIcons.rightFromBracket,
                color: kPrimaryDark,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(color: kPrimaryDark),
              ),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const Login()),
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Search (glassmorphism)
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.65),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.7),
                              width: 0.8,
                            ),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search products',
                              hintStyle: GoogleFonts.cabin(
                                color: Colors.grey[600],
                              ),
                              prefixIcon: const Icon(
                                FontAwesomeIcons.search,
                                size: 18,
                                color: kPrimaryDark,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 52,
                  width: 52,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [kAccent, kPrimaryDark],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryDark.withOpacity(0.28),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: const AwesomeSnackbarContent(
                              title: 'Filters',
                              message: 'Advanced filters coming soon ✨',
                              contentType: ContentType.help,
                            ),
                          ),
                        );
                    },
                    icon: const Icon(
                      FontAwesomeIcons.sliders,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Categories (elevated chips)
            SizedBox(
              height: 104,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFE0E0), Color(0xFFFFF3F3)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 34,
                            child: Icon(
                              category['icon'],
                              color: kPrimaryDark,
                              size: 26,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category['label'],
                          style: GoogleFonts.cabin(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 14),

            // Banner carousel (overlay + CTA)
            CarouselSlider(
              options: CarouselOptions(
                height: 190,
                viewportFraction: 0.9,
                autoPlay: true,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() => _currentBanner = index);
                },
              ),
              items: bannerImages.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(item, fit: BoxFit.cover),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.0),
                                Colors.black.withOpacity(0.45),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          right: 16,
                          bottom: 16,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.local_fire_department,
                                      color: kPrimaryDark,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Hot Deals',
                                      style: GoogleFonts.cabin(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(
                                        elevation: 0,
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        content: const AwesomeSnackbarContent(
                                          title: 'Promo',
                                          message: 'Open promotions',
                                          contentType: ContentType.success,
                                        ),
                                      ),
                                    );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryDark,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Shop now',
                                  style: GoogleFonts.cabin(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 8),

            // Indicator dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: bannerImages.asMap().entries.map((entry) {
                final active = _currentBanner == entry.key;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: active ? 20 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: active ? kPrimaryDark : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              }).toList(),
            ),

            // Featured title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  Text(
                    'Featured Products',
                    style: GoogleFonts.cabin(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            // Featured products (premium cards)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                height: 210,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return PremiumProductCard(
                      product: product,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetail(product: product),
                          ),
                        );
                      },
                      onAdd: () {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Added to cart',
                                message: product.name,
                                contentType: ContentType.success,
                              ),
                            ),
                          );
                      },
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),

      // ---------- Snake Bottom Navigation Bar (UNCHANGED POSITION) ----------
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 8),
                color: Colors.black.withOpacity(0.08),
              ),
            ],
          ),
          child: SnakeNavigationBar.color(
            behaviour: SnakeBarBehaviour.floating,
            snakeShape: SnakeShape.indicator, // clean dot indicator
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            // Colors
            snakeViewColor: const Color(0xFFEE5757),
            selectedItemColor: const Color(0xFFEE5757),
            unselectedItemColor: Colors.grey[600],
            backgroundColor: Colors.white,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            currentIndex: _selectedIndex,
            onTap: _onTapNav,

            items: const [
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.house),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.cartShopping),
                label: 'Other',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.commentDots),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.solidUser),
                label: 'Account',
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListTile _drawerTile(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: FaIcon(icon, color: kPrimaryDark),
      title: Text(label, style: GoogleFonts.cabin(fontWeight: FontWeight.w600)),
      onTap: onTap,
    );
  }
}

// ---------- Premium Product Card ----------
class PremiumProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final VoidCallback? onAdd;

  const PremiumProductCard({
    Key? key,
    required this.product,
    this.onTap,
    this.onAdd,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // height is inherited from parent SizedBox (190)
        width: 170,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // IMAGE FLEXES to fill leftover space -> no overflow
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset('assets/image.png', fit: BoxFit.cover),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: Color(0xFFFFC107),
                            ),
                            SizedBox(width: 4),
                            Text(
                              '4.8',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // TEXT (tight paddings)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Text(
                  product.name,
                  maxLines: 1, // keep to 1 line to be safe in 190px
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cabin(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 2, 12, 0),
                child: Text(
                  "\$${product.price.toStringAsFixed(2)}",
                  style: GoogleFonts.cabin(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: _HomePageState.kPrimaryDark,
                  ),
                ),
              ),

              // CTA (fixed, compact)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
                child: SizedBox(
                  height: 34,
                  child: ElevatedButton.icon(
                    onPressed: onAdd,
                    icon: const Icon(Icons.add_shopping_cart, size: 16),
                    label: Text(
                      'Add',
                      style: GoogleFonts.cabin(fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: _HomePageState.kPrimaryDark,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
