import 'dart:convert';

import 'package:customer_ui/model/product_medel.dart';
import 'package:customer_ui/screen/home_page.dart';
import 'package:customer_ui/screen/message.dart';
import 'package:customer_ui/screen/product_detail.dart';
import 'package:customer_ui/screen/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class OtherScreen extends StatefulWidget {
  const OtherScreen({super.key});

  @override
  State<OtherScreen> createState() => _OtherScreenState();
}

class _OtherScreenState extends State<OtherScreen> {
  // Start on the Cart tab for this screen (index 1)
  int _selectedIndex = 1;

  List<ProductModel> products = [];
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  String selectedCategory = "All";

  final List<String> categories = const [
    "Phones",
    "Computers",
    "Beds/Chairs",
    "Watches",
    "Sports",
    "Toys",
  ];

  @override
  void initState() {
    super.initState();
    fetchAll();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchAll() async {
    final res = await http.get(
      Uri.parse(
        'https://post-product-beac8-default-rtdb.asia-southeast1.firebasedatabase.app/products.json',
      ),
    );
    if (res.statusCode == 200 && res.body != 'null') {
      final Map<String, dynamic> data = json.decode(res.body);
      final List<ProductModel> loaded = [];

      data.forEach((key, value) {
        loaded.add(ProductModel.fromJson({"id": key, ...value}));
      });

      setState(() {
        products = loaded;
      });
    } else {
      setState(() {
        products = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        toolbarHeight: 60,
        titleSpacing: 8,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
        title: Container(
          height: 42,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(25),
          ),
          child: TextField(
            controller: searchController,
            onChanged: (val) {
              setState(() {
                searchQuery = val.trim().toLowerCase();
              });
            },
            decoration: const InputDecoration(
              hintText: "Search products",
              hintStyle: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 85, 85, 85),
              ),
              prefixIcon: Icon(
                FontAwesomeIcons.search,
                color: Color.fromARGB(255, 255, 129, 129),
                size: 22,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  FontAwesomeIcons.cartShopping,
                  color: Colors.black,
                ),
                onPressed: () {
                  // Show featured products dialog filtered by selectedCategory and searchQuery
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        contentPadding: const EdgeInsets.all(0),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: FeaturedProductsByCategory(
                            products: products,
                            category: selectedCategory,
                            searchQuery: searchQuery,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: const Text(
                    '3', // cart count
                    style: TextStyle(color: Colors.white, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(FontAwesomeIcons.sliders, color: Colors.black),
            onPressed: () {
              // Open filter screen (if needed)
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category bar
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length + 1, // +1 for "All"
                itemBuilder: (context, index) {
                  final category = index == 0 ? "All" : categories[index - 1];
                  final isSelected = selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      selectedColor: const Color(0xFFEE5757),
                      backgroundColor: Colors.grey[200],
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            // Display featured products filtered by selectedCategory and searchQuery
            FeaturedProductsByCategory(
              products: products,
              category: selectedCategory,
              searchQuery: searchQuery,
            ),
          ],
        ),
      ),
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
            snakeShape: SnakeShape.indicator, // clean dot/indicator
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),

            // Colors
            snakeViewColor: const Color(0xFFEE5757),
            selectedItemColor: const Color(0xFFEE5757),
            unselectedItemColor: Colors.grey[600],
            backgroundColor: Colors.white,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() => _selectedIndex = index);

              if (index == 0) {
                // Home
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              } else if (index == 1) {
                // Other / Cart
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const OtherScreen()),
                );
              } else if (index == 2) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MessageScreen(),
                  ),
                );
              } else if (index == 3) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Profile()),
                );
              }
            },

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
}

// -----------------------------------------------------------------------------
// Widget to show featured products filtered by category and search query
// -----------------------------------------------------------------------------
class FeaturedProductsByCategory extends StatelessWidget {
  final List<ProductModel> products;
  final String category;
  final String searchQuery;

  const FeaturedProductsByCategory({
    Key? key,
    required this.products,
    required this.category,
    this.searchQuery = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter by category
    final filteredByCategory = category == "All"
        ? products
        : products.where((p) => p.category == category).toList();

    // Further filter by search query (case insensitive)
    final filteredProducts = filteredByCategory.where((p) {
      return p.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            'Featured Products for "$category"',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 190,
          child: filteredProducts.isEmpty
              ? const Center(child: Text("No products found"))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: SizedBox(
                        width: 170, // your card width
                        height: 190, // force card to fit
                        child: ProductCard(
                          product: product,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetail(product: product),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  ProductCard({
    required ProductModel product,
    required Null Function() onTap,
  }) {}
}
