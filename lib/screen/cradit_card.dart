import 'package:customer_ui/screen/payment_form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

// TODO: Use the correct import for your ABA SDK:
//// import 'package:aba_checkout/aba_checkout.dart'; // example
//// or: import 'package:aba_kh/aba_checkout_container.dart';

// Dummy interface to satisfy sample; REMOVE when using real package.
class ABACheckoutContainer extends StatelessWidget {
  final double amount;
  final double shipping;
  final String firstname;
  final String lastname;
  final String email;
  final String phone;
  final List<Map<String, dynamic>> items;
  final String checkoutApiUrl;
  final String merchant;
  final ValueChanged<dynamic>? onBeginCheckout;
  final ValueChanged<dynamic>? onFinishCheckout;
  final ValueChanged<dynamic>? onBeginCheckTransaction;
  final ValueChanged<dynamic>? onFinishCheckTransaction;
  final bool enabled;
  const ABACheckoutContainer({
    super.key,
    required this.amount,
    required this.shipping,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.items,
    required this.checkoutApiUrl,
    required this.merchant,
    this.onBeginCheckout,
    this.onFinishCheckout,
    this.onBeginCheckTransaction,
    this.onFinishCheckTransaction,
    this.enabled = true,
  });
  @override
  Widget build(BuildContext context) {
    // Replace with real widget from your SDK.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: enabled
              ? () {
                  onBeginCheckout?.call({'mock': true});
                  Future.delayed(const Duration(seconds: 2), () {
                    onFinishCheckout?.call({'mock': true});
                  });
                }
              : null,
          child: const Text('Pay with ABA'),
        ),
      ],
    );
  }
}

class CraditCard extends StatefulWidget {
  const CraditCard({super.key});

  @override
  State<CraditCard> createState() => _CraditCardState();
}

class _CraditCardState extends State<CraditCard> {
  String? _selectedMethod;

  // ---- Mock/placeholder checkout data (wire with your real data) ----
  bool _isLoading = false;
  double _total = 49.99;
  double _shipping = 2.00;
  String _firstname = 'Udom';
  String _lastname = 'Customer';
  String _email = 'udom@example.com';
  String _phone = '012345678';
  String _checkoutApiUrl = 'https://your-api/checkout'; // replace
  String _merchant = 'YOUR_MERCHANT_ID'; // replace
  final List<Map<String, dynamic>> _items = [
    {'name': 'Sample Item', 'qty': 1, 'price': 49.99},
  ];
  // -------------------------------------------------------------------

  final List<Map<String, String>> paymentMethods = [
    {
      'id': 'card',
      'title': 'កាតឥណទាន / កាតឥណពន្ធ',
      'subtitle': 'បង់ប្រាក់ដោយសុវត្ថិភាពប្រើកាតរបស់អ្នក',
      'icon': 'credit_card',
    },
    {
      'id': 'wallet',
      'title': 'កាបូប',
      'subtitle': 'ប្រើសមតុល្យកាបូបក្នុងកម្មវិធី',
      'icon': 'account_balance_wallet',
    },
    {
      'id': 'bank',
      'title': 'ផ្ទេរប្រាក់តាមធនាគារ (ABA)',
      'subtitle': 'បង់ប្រាក់តាមរយៈ ABA PayWay',
      'icon': 'account_balance',
    },
    {
      'id': 'cod',
      'title': 'បង់ប្រាក់ពេលទទួល',
      'subtitle': 'បង់ប្រាក់នៅពេលអ្នកទទួលផលិតផល',
      'icon': 'money',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final siemreap = GoogleFonts.siemreapTextTheme(theme.textTheme);

    return Theme(
      data: theme.copyWith(
        textTheme: siemreap,
        colorScheme: theme.colorScheme.copyWith(
          primary: const Color(0xFFFF4E4E),
          secondary: const Color(0xFFFFA04E),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: GoogleFonts.siemreap(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          iconTheme: const IconThemeData(color: Colors.black87),
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        appBar: AppBar(
          centerTitle: true,
          title: const Text('ជ្រើសរើសវិធីបង់ប្រាក់'),
        ),
        body: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          itemCount: paymentMethods.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final m = paymentMethods[index];
            final selected = _selectedMethod == m['id'];
            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => setState(() => _selectedMethod = m['id']),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: selected ? Colors.white : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFFFF4E4E)
                        : Colors.grey.shade300,
                    width: selected ? 2 : 1.2,
                  ),
                  boxShadow: [
                    if (selected)
                      BoxShadow(
                        color: const Color(0xFFFF4E4E).withOpacity(0.18),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      )
                    else
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                  ],
                  gradient: selected
                      ? LinearGradient(
                          stops: const [0.0, 1.0],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFFFF2F2),
                            const Color(0xFFFFFAF5),
                          ],
                        )
                      : null,
                ),
                child: Row(
                  children: [
                    _IconBadge(
                      icon: _getIconData(m['icon']!),
                      active: selected,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m['title']!,
                            style: GoogleFonts.siemreap(
                              fontSize: 16,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              color: selected
                                  ? const Color(0xFFB91C1C)
                                  : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            m['subtitle']!,
                            style: GoogleFonts.siemreap(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Radio<String>(
                      value: m['id']!,
                      groupValue: _selectedMethod,
                      activeColor: const Color(0xFFFF4E4E),
                      onChanged: (value) => setState(() {
                        _selectedMethod = value;
                      }),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        // Bottom CTA
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: ElevatedButton(
              onPressed: _selectedMethod == null
                  ? null
                  : () async {
                      if (_selectedMethod == 'bank') {
                        _showABACheckoutSheet(context);
                      } else if (_selectedMethod == 'card') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PaymentForm(),
                          ),
                        );
                      } else if (_selectedMethod == 'cod') {
                        _showSnack(
                          context,
                          title: 'បានជ្រើសរើស',
                          msg: 'អ្នកបានជ្រើសរើស បង់ប្រាក់ពេលទទួល',
                          type: _SnackType.success,
                        );
                      } else if (_selectedMethod == 'wallet') {
                        _showSnack(
                          context,
                          title: 'កាបូប',
                          msg: 'សមតុល្យកាបូបត្រូវបានពិនិត្យ',
                          type: _SnackType.info,
                        );
                      }
                    },
              style:
                  ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 10,
                    shadowColor: const Color.fromARGB(
                      255,
                      255,
                      78,
                      78,
                    ).withOpacity(0.4),
                    backgroundColor: const Color(0xFFFF4E4E),
                    foregroundColor: Colors.white,
                  ).merge(
                    ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith((
                        states,
                      ) {
                        if (states.contains(WidgetState.disabled)) {
                          return Colors.grey.shade300;
                        }
                        return null;
                      }),
                    ),
                  ),
              child: Text(
                'បន្ត',
                style: GoogleFonts.siemreap(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showABACheckoutSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.92,
          expand: false,
          builder: (_, controller) {
            return Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: ListView(
                controller: controller,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'ABA Checkout',
                    style: GoogleFonts.cabin(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ចុច “Pay with ABA” ដើម្បីបន្តការទូទាត់',
                    style: GoogleFonts.kantumruyPro(
                      fontSize: 14,
                      color: const Color.fromARGB(255, 253, 73, 73),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 248, 248),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color.fromARGB(255, 255, 210, 210),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.receipt_long,
                          color: Color(0xFFFF7A4E),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'សរុប: \$${(_total + _shipping).toStringAsFixed(2)} '
                            '(រួមបញ្ចូលការដឹកជញ្ជូន \$${_shipping.toStringAsFixed(2)})',
                            style: GoogleFonts.siemreap(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // >>> ABACheckoutContainer (from your SDK) <<<
                  ABACheckoutContainer(
                    amount: _total,
                    shipping: _shipping,
                    firstname: _firstname,
                    lastname: _lastname,
                    email: _email,
                    phone: _phone,
                    items: [..._items.map((e) => e).toList()],
                    checkoutApiUrl: _checkoutApiUrl,
                    merchant: _merchant,
                    onBeginCheckout: (transaction) {
                      setState(() => _isLoading = true);
                      EasyLoading.show(status: 'loading...');
                    },
                    onFinishCheckout: (transaction) {
                      setState(() => _isLoading = false);
                      EasyLoading.dismiss();
                      Navigator.of(context).maybePop();
                      _showSnack(
                        context,
                        title: 'ជោគជ័យ',
                        msg: 'ការទូទាត់បានបញ្ចប់',
                        type: _SnackType.success,
                      );
                    },
                    onBeginCheckTransaction: (transaction) {
                      setState(() => _isLoading = true);
                      EasyLoading.show(status: 'loading...');
                      // print("onBeginCheckTransaction ${transaction.toMap()}");
                    },
                    onFinishCheckTransaction: (transaction) {
                      setState(() => _isLoading = false);
                      EasyLoading.dismiss();
                      // print("onFinishCheckTransaction ${transaction.toMap()}");
                    },
                    enabled: !_isLoading,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSnack(
    BuildContext context, {
    required String title,
    required String msg,
    required _SnackType type,
  }) {
    // Simple lovely snackbar that fits Siemreap; replace with awesome_snackbar_content if desired
    final color = switch (type) {
      _SnackType.success => const Color(0xFF16A34A),
      _SnackType.info => const Color(0xFF2563EB),
      _SnackType.error => const Color(0xFFDC2626),
    };
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        content: Text(
          '$title • $msg',
          style: GoogleFonts.siemreap(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'credit_card':
        return Icons.credit_card;
      case 'account_balance_wallet':
        return Icons.account_balance_wallet;
      case 'account_balance':
        return Icons.account_balance;
      case 'money':
        return Icons.money;
      default:
        return Icons.payment;
    }
  }
}

enum _SnackType { success, info, error }

class _IconBadge extends StatelessWidget {
  final IconData icon;
  final bool active;
  const _IconBadge({required this.icon, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: active
            ? const LinearGradient(
                colors: [Color(0xFFFF7A4E), Color(0xFFFF4E4E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: active ? null : const Color(0xFFF3F4F6),
        boxShadow: active
            ? [
                BoxShadow(
                  color: const Color(0xFFFF4E4E).withOpacity(0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Icon(
        icon,
        color: active ? Colors.white : const Color(0xFF6B7280),
        size: 22,
      ),
    );
  }
}
