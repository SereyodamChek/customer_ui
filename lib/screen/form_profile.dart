// ignore_for_file: unused_field

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:customer_ui/screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../model/customer_model.dart';

class FormProfile extends StatefulWidget {
  const FormProfile({super.key});

  @override
  State<FormProfile> createState() => _FormProfileState();
}

class _FormProfileState extends State<FormProfile> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  String _selectedGender = 'Male';
  String _selectedAddress = 'Phnom Penh';
  String _selectedStatus = 'Active';
  DateTime? _selectedDate;

  File? _imageFile;
  Uint8List? _image;

  bool _isSubmitting = false;

  // Brand palette
  static const kPrimary = Color(0xFFEF5350);
  static const kPrimaryDark = Color(0xFFE53935);
  static const kSurface = Color(0xFFF6F7FB);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  InputDecoration _dec(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: kPrimaryDark),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE7ECF3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kPrimaryDark, width: 1.4),
      ),
    );
  }

  String get _dobText {
    final d = _selectedDate;
    if (d == null) return '';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final bytes = await file.readAsBytes();
      setState(() {
        _imageFile = file;
        _image = bytes;
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: Theme.of(
              ctx,
            ).colorScheme.copyWith(primary: kPrimaryDark),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    if (!_formKey.currentState!.validate()) return;

    if (_imageFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please upload an image")));
      return;
    }

    try {
      setState(() => _isSubmitting = true);

      // Upload image
      final cloudinary = CloudinaryPublic(
        'dk7rrqx1j',
        'ProductApp656',
        cache: false,
      );
      final upload = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          _imageFile!.path,
          folder: "Customers",
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      final customer = CustomerModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        gender: _selectedGender,
        email: _emailController.text.trim(),
        address: _selectedAddress,
        phoneNumber: _phoneController.text.trim(),
        dateOfBirth: _selectedDate?.toIso8601String() ?? '',
        status: _selectedStatus,
        imageUrl: upload.secureUrl,
      );

      final res = await http.post(
        Uri.parse(
          'https://post-product-beac8-default-rtdb.asia-southeast1.firebasedatabase.app/customers.json',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(customer.toJson()),
      );

      if (!mounted) return;
      setState(() => _isSubmitting = false);

      if (res.statusCode == 200 || res.statusCode == 201) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Customer profile saved')));
        _formKey.currentState!.reset();
        setState(() {
          _imageFile = null;
          _image = null;
          _selectedDate = null;
          _selectedGender = 'Male';
          _selectedAddress = 'Phnom Penh';
          _selectedStatus = 'Active';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save customer')),
        );
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      debugPrint("Upload error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error uploading image')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSurface,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [kPrimary, kPrimaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Customer Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          children: [
            // Avatar card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 42,
                        backgroundColor: const Color(0xFFEFF3F9),
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!)
                            : null,
                        child: _imageFile == null
                            ? const Icon(
                                Icons.person,
                                size: 42,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: InkWell(
                          onTap: _pickImage,
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              color: kPrimaryDark,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Add a friendly face to your profile',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Form card
            Container(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: _dec('Name', Icons.person),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Enter name' : null,
                    ),
                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: _dec('Gender', Icons.wc),
                      items: const ['Male', 'Female', 'Other']
                          .map(
                            (g) => DropdownMenuItem(value: g, child: Text(g)),
                          )
                          .toList(),
                      onChanged: (v) => setState(
                        () => _selectedGender = v ?? _selectedGender,
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _dec('Email', Icons.email),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Enter email';
                        final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                        if (!regex.hasMatch(value))
                          return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: _selectedAddress,
                      decoration: _dec('Address', Icons.home),
                      items:
                          const [
                                'Phnom Penh',
                                'Kandal',
                                'Siem Reap',
                                'Battambang',
                                'Takeo',
                              ]
                              .map(
                                (a) =>
                                    DropdownMenuItem(value: a, child: Text(a)),
                              )
                              .toList(),
                      onChanged: (v) => setState(
                        () => _selectedAddress = v ?? _selectedAddress,
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: _dec('Phone Number', Icons.phone),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Enter phone number';
                        if (v.length < 8) return 'Enter a valid phone number';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // DOB
                    TextFormField(
                      readOnly: true,
                      controller: TextEditingController(text: _dobText),
                      onTap: _pickDate,
                      decoration: _dec('Date of Birth', Icons.calendar_today),
                    ),
                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      decoration: _dec('Status', Icons.info),
                      items: const ['Active', 'Inactive', 'Pending']
                          .map(
                            (s) => DropdownMenuItem(value: s, child: Text(s)),
                          )
                          .toList(),
                      onChanged: (v) => setState(
                        () => _selectedStatus = v ?? _selectedStatus,
                      ),
                    ),

                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Submit
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submit,
                icon: _isSubmitting
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(_isSubmitting ? 'Saving...' : 'Save Customer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 6,
                  shadowColor: kPrimaryDark.withOpacity(0.3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
