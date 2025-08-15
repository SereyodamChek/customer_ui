import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentForm extends StatefulWidget {
  const PaymentForm({super.key});

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final _formKey = GlobalKey<FormState>();
  final _cardController = TextEditingController();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _cvvController = TextEditingController();
  final _expiryController = TextEditingController();
  final _dateController = TextEditingController();

  String? _selectedMethod = 'ABA Pay'; // default to ABA-like experience
  String _status = 'រងចាំ';
  DateTime? _selectedDate;

  bool _isSubmitting = false; // NEW: prevent double submits

  // ABA-like colors
  static const _abaBlue = Color.fromARGB(255, 248, 74, 74);
  static const _abaBlueDark = Color.fromARGB(255, 136, 6, 6);
  static const _abaAccent = Color.fromARGB(255, 255, 255, 255);

  @override
  void dispose() {
    _cardController.dispose();
    _nameController.dispose();
    _amountController.dispose();
    _cvvController.dispose();
    _expiryController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // NEW: Ask for 4-digit PIN; returns entered PIN or null if cancelled
  Future<String?> _askForPin() async {
    final pinController = TextEditingController();
    String? result;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 18,
            right: 18,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 18,
            top: 18,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'បញ្ចូល PIN 4 ខ្ទង់',
                style: GoogleFonts.siemreap(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: pinController,
                autofocus: true,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  letterSpacing: 10,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
                maxLength: 4,
                obscureText: true,
                obscuringCharacter: '•',
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '• • • •',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(width: 2, color: _abaBlue),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onChanged: (v) {
                  if (v.length == 4) {
                    result = v;
                    Navigator.of(ctx).pop(); // auto-submit at 4 digits
                  }
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text('បោះបង់', style: GoogleFonts.siemreap()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (pinController.text.length == 4) {
                          result = pinController.text;
                          Navigator.of(ctx).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _abaBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'បញ្ជាក់',
                        style: GoogleFonts.siemreap(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    return result;
  }

  // NEW: 3s loading overlay
  Future<void> _showLoading3s() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) Navigator.of(context).pop(); // close loading
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    if (_formKey.currentState!.validate() && _selectedDate != null) {
      // 1) Ask for PIN
      final pin = await _askForPin();
      if (!mounted) return;

      // User cancelled
      if (pin == null) return;

      // 2) Verify PIN
      if (pin != '0000') {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: const AwesomeSnackbarContent(
                title: '❌ បរាជ័យ',
                message: 'PIN មិនត្រឹមត្រូវ',
                contentType: ContentType.failure,
              ),
            ),
          );
        return;
      }

      // 3) Show 3s loading
      await _showLoading3s();
      if (!mounted) return;

      setState(() => _isSubmitting = true);

      final amt =
          double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0.0;

      final data = {
        "id": DateTime.now().millisecondsSinceEpoch.toString(),
        "card": _cardController.text,
        "name": _nameController.text,
        "amount": amt,
        "status": _status,
        "expire": _expiryController.text,
        "cvv": _cvvController.text,
        "date": _selectedDate!.toIso8601String(),
        "method": _selectedMethod,
      };

      final res = await http.post(
        Uri.parse(
          'https://post-product-beac8-default-rtdb.asia-southeast1.firebasedatabase.app/payments.json',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (!mounted) return;
      setState(() => _isSubmitting = false);

      final ok = res.statusCode == 200 || res.statusCode == 201;
      final message = ok ? 'ការទូទាត់ជោគជ័យ' : 'ការទូទាត់បរាជ័យ';

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: ok ? '✅ ជោគជ័យ' : '❌ បរាជ័យ',
              message: message,
              contentType: ok ? ContentType.success : ContentType.failure,
            ),
          ),
        );

      if (ok) {
        _formKey.currentState!.reset();
        setState(() {
          _selectedDate = null;
          _cardController.clear();
          _nameController.clear();
          _amountController.clear();
          _cvvController.clear();
          _expiryController.clear();
          _dateController.clear();
          _selectedMethod = 'ABA Pay';
          _status = 'រងចាំ';
        });
      }
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.orange,
          content: Text(
            '⚠️ សូមជ្រើសរើសកាលបរិច្ឆេទទូទាត់',
            style: GoogleFonts.siemreap(color: Colors.white),
          ),
        ),
      );
    }
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.siemreap(),
      prefixIcon: Icon(icon, color: _abaBlue),
      filled: true,
      fillColor: const Color(0xFFF4F7FB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE3ECFB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _abaBlue, width: 1.5),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _buildAmountCard() {
    final amount = _amountController.text.isEmpty
        ? 0.0
        : double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0.0;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_abaBlue, _abaBlueDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _abaBlue.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ចំនួនទឹកប្រាក់សរុប',
            style: GoogleFonts.siemreap(color: Colors.white70),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.payments_rounded, color: _abaAccent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '\$${NumberFormat('#,##0.00').format(amount)}',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.siemreap(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardFields() {
    return Column(
      children: [
        TextFormField(
          controller: _cardController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: _inputDecoration('លេខកាត', Icons.credit_card),
          validator: (value) => value!.isEmpty ? 'ត្រូវការបំពេញ' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _nameController,
          decoration: _inputDecoration('ឈ្មោះម្ចាស់កាត', Icons.person),
          validator: (value) => value!.isEmpty ? 'ត្រូវការបំពេញ' : null,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _expiryController,
                keyboardType: TextInputType.datetime,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                  LengthLimitingTextInputFormatter(7), // MM/YYYY
                ],
                decoration: _inputDecoration(
                  'ខែ/ឆ្នាំផុតកំណត់',
                  Icons.calendar_today,
                ),
                validator: (value) => value!.isEmpty ? 'ត្រូវការបំពេញ' : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _cvvController,
                obscureText: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                decoration: _inputDecoration('CVV', Icons.lock),
                validator: (value) => value!.isEmpty ? 'ត្រូវការបំពេញ' : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMethodTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
  }) {
    final selected = _selectedMethod == value;
    return InkWell(
      onTap: () => setState(() => _selectedMethod = value),
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? _abaBlue : const Color(0xFFE6EDF8),
            width: selected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? _abaBlue.withOpacity(0.18)
                  : Colors.black12.withOpacity(0.06),
              blurRadius: selected ? 16 : 10,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: selected ? _abaBlue : const Color(0xFFF1F6FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: selected ? Colors.white : _abaBlue),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.siemreap(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: selected ? _abaBlue : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.siemreap(
                      fontSize: 12.5,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selectedMethod,
              activeColor: _abaBlue,
              onChanged: (v) => setState(() => _selectedMethod = v),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Theme(
      data: theme.copyWith(
        textTheme: GoogleFonts.siemreapTextTheme(theme.textTheme),
        scaffoldBackgroundColor: const Color(0xFFF4F7FB),
        appBarTheme: AppBarTheme(
          backgroundColor: _abaBlue,
          elevation: 0,
          titleTextStyle: GoogleFonts.siemreap(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        colorScheme: theme.colorScheme.copyWith(
          primary: _abaBlue,
          secondary: _abaAccent,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text('ទូទាត់')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildAmountCard(),
                  const SizedBox(height: 16),

                  // Amount input (editable)
                  TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    ],
                    decoration: _inputDecoration(
                      'ចំនួនទឹកប្រាក់ (\$)',
                      Icons.attach_money,
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'បញ្ចូលចំនួនទឹកប្រាក់' : null,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 14),

                  // Date
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: _pickDate,
                    decoration: _inputDecoration(
                      'កាលបរិច្ឆេទទូទាត់',
                      Icons.date_range,
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'ជ្រើសរើសកាលបរិច្ឆេទ' : null,
                  ),
                  const SizedBox(height: 18),

                  // Methods (ABA, Card, PayPal)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'ជ្រើសរើសវិធីបង់ប្រាក់',
                        style: GoogleFonts.siemreap(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  _buildMethodTile(
                    title: 'ABA Pay',
                    subtitle: 'បង់ប្រាក់តាម ABA (QR/Deeplink)',
                    icon: Icons.qr_code_2_rounded,
                    value: 'ABA Pay',
                  ),
                  const SizedBox(height: 10),
                  _buildMethodTile(
                    title: 'កាត (Visa/Master)',
                    subtitle: 'បង់ប្រាក់ដោយកាតរបស់អ្នក',
                    icon: Icons.credit_card,
                    value: 'កាត',
                  ),
                  const SizedBox(height: 10),
                  _buildMethodTile(
                    title: 'PayPal',
                    subtitle: 'នឹងបញ្ជូនទៅ PayPal នៅពេលបញ្ជូន',
                    icon: Icons.account_balance_wallet_rounded,
                    value: 'PayPal',
                  ),
                  const SizedBox(height: 18),

                  // Card fields visible only if 'កាត'
                  if (_selectedMethod == 'កាត') _buildCardFields(),
                  if (_selectedMethod == 'PayPal')
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'បានជ្រើសរើស PayPal។ នឹងបញ្ជូនទៅ PayPal នៅពេលបញ្ជូន។',
                        style: GoogleFonts.siemreap(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  if (_selectedMethod == 'ABA Pay')
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'បានជ្រើសរើស ABA Pay។ អាចបន្តទៅ QR / Deeplink តាម ABA PayWay.',
                        style: GoogleFonts.siemreap(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),

                  const SizedBox(height: 22),

                  // Status
                  DropdownButtonFormField<String>(
                    value: _status,
                    decoration: _inputDecoration('ស្ថានភាព', Icons.flag),
                    items: const [
                      DropdownMenuItem(value: 'រងចាំ', child: Text('រងចាំ')),
                      DropdownMenuItem(
                        value: 'បានបញ្ចប់',
                        child: Text('បានបញ្ចប់'),
                      ),
                      DropdownMenuItem(value: 'បរាជ័យ', child: Text('បរាជ័យ')),
                    ],
                    onChanged: (val) => setState(() => _status = val!),
                  ),

                  const SizedBox(height: 28),

                  // Submit
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: _abaBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 10,
                        shadowColor: _abaBlue.withOpacity(0.35),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock),
                          const SizedBox(width: 10),
                          Text(
                            'បង់ប្រាក់ឥឡូវនេះ',
                            style: GoogleFonts.siemreap(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
