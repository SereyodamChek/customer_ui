import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:customer_ui/screen/cradit_card.dart';
import 'package:customer_ui/screen/payment_form.dart';
import 'package:flutter/material.dart';
import 'package:customer_ui/model/product_medel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetail extends StatelessWidget {
  final ProductModel product;

  const ProductDetail({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.siemreapTextTheme(), // Apply Siemreap font
      ),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: Text(
            product.name,
            style: GoogleFonts.cabin(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: ListView(
          children: [
            // Product Image with Hero
            Hero(
              tag: product.imageUrl,
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Image.asset(
                    'assets/image.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.image_not_supported, size: 50),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Product Info Card
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: GoogleFonts.cabin(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    "\$${product.price.toStringAsFixed(2)}",
                    style: GoogleFonts.cabin(
                      color: Colors.red,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.solidChartBar,
                        size: 18,
                        color: Color.fromARGB(255, 255, 83, 83),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        product.category,
                        style: GoogleFonts.cabin(
                          color: Color.fromARGB(255, 255, 83, 83),
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        FontAwesomeIcons.calendar,
                        size: 18,
                        color: Color.fromARGB(255, 255, 83, 83),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('yyyy-MM-dd').format(product.createdAt),
                        style: GoogleFonts.cabin(
                          color: Color.fromARGB(255, 255, 83, 83),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "🚚 ដឹកជញ្ជូនឥតគិតថ្លៃ",
                      style: GoogleFonts.siemreap(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Description
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ពិពណ៌នាផលិតផល",
                    style: GoogleFonts.siemreap(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: const Color.fromARGB(221, 255, 1, 1),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: GoogleFonts.cabin(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 90),
          ],
        ),

        // Bottom Action
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey[300]!)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, -2),
                blurRadius: 6,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: const Color.fromARGB(255, 236, 71, 71),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'ជ្រើសរើសវិធីបង់ប្រាក់',
                                style: GoogleFonts.siemreap(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              ListTile(
                                leading: const Icon(
                                  FontAwesomeIcons.creditCard,
                                  color: Color.fromARGB(255, 247, 97, 97),
                                ),
                                title: Text(
                                  'កាតឥណទាន / កាតឥណពន្ធ',
                                  style: GoogleFonts.siemreap(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PaymentForm(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    "ទិញឥឡូវនេះ",
                    style: GoogleFonts.siemreap(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(
                  FontAwesomeIcons.solidComment,
                  color: Colors.blue,
                ),
                onPressed: () {
                  final snackBar = SnackBar(
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    content: AwesomeSnackbarContent(
                      title: 'ជោគជ័យ!',
                      message: 'សារ​ត្រូវ​បាន​ផ្ញើ​ទៅ​អ្នកលក់',
                      contentType: ContentType
                          .success, // success / failure / help / warning
                    ),
                  );

                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(snackBar);
                },
              ),
              IconButton(
                icon: const Icon(FontAwesomeIcons.phone, color: Colors.green),
                onPressed: () {
                  final snackBar = SnackBar(
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    content: AwesomeSnackbarContent(
                      title: 'កំពុងហៅ...',
                      message: 'កំពុងទាក់ទងទៅកាន់អ្នកលក់',
                      contentType:
                          ContentType.help, // blue/green style for call action
                    ),
                  );

                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(snackBar);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
