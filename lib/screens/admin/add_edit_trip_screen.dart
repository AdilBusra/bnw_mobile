import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class AddEditTripScreen extends StatefulWidget {
  final bool isEditing;

  const AddEditTripScreen({super.key, this.isEditing = false});

  @override
  State<AddEditTripScreen> createState() => _AddEditTripScreenState();
}

class _AddEditTripScreenState extends State<AddEditTripScreen> {
  // GlobalKey untuk menangani validasi form
  final _formKey = GlobalKey<FormState>();

  // Controller untuk simulasi state input
  late TextEditingController _nameController;
  late TextEditingController _destinationController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late TextEditingController _quotaController;

  @override
  void initState() {
    super.initState();
    // Mengisi nilai awal jika mode Edit (Simulasi state data existing)
    _nameController = TextEditingController(text: widget.isEditing ? "Bali Summer Getaway" : "");
    _destinationController = TextEditingController(text: widget.isEditing ? "Bali, Indonesia" : "");
    _descController = TextEditingController(text: widget.isEditing ? "A beautiful 3-day summer getaway in the heart of Bali." : "");
    _priceController = TextEditingController(text: widget.isEditing ? "2500000" : "");
    _quotaController = TextEditingController(text: widget.isEditing ? "30" : "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _destinationController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _quotaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.coconutCream,
              AppColors.softPink,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: AppColors.deepTeal),
              title: Text(
                widget.isEditing ? "Edit Trip" : "Add New Trip",
                style: GoogleFonts.fredoka(
                  color: AppColors.deepTeal,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              // FORM DENGAN VALIDASI
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Simulasi Upload Gambar dengan interaksi klik
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Simulasi: Membuka galeri untuk pilih gambar...')),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.deepTeal.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_photo_alternate_outlined, color: AppColors.islandPink, size: 48),
                            const SizedBox(height: 8),
                            Text(
                              widget.isEditing ? "Change Cover Image" : "Upload Cover Image",
                              style: GoogleFonts.plusJakartaSans(color: AppColors.deepTeal, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle("Basic Information"),

                    _buildValidatedTextField(
                      label: "Trip Name",
                      hint: "e.g., Bali Summer Getaway",
                      controller: _nameController,
                    ),
                    _buildValidatedTextField(
                      label: "Destination",
                      hint: "e.g., Bali, Indonesia",
                      controller: _destinationController,
                    ),
                    _buildValidatedTextField(
                      label: "Description",
                      hint: "Write an engaging description...",
                      controller: _descController,
                      maxLines: 4,
                    ),

                    const SizedBox(height: 16),
                    _buildSectionTitle("Dates & Capacity"),
                    Row(
                      children: [
                        Expanded(
                          child: _buildValidatedTextField(
                            label: "Price (Rp)",
                            hint: "0",
                            controller: _priceController,
                            isNumber: true,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildValidatedTextField(
                            label: "Quota",
                            hint: "Max participants",
                            controller: _quotaController,
                            isNumber: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // TOMBOL SIMPAN DENGAN VALIDASI BERGERAK
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // Menjalankan validasi form
                          if (_formKey.currentState!.validate()) {
                            // Jika validasi sukses, tampilkan feedback sukses
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  widget.isEditing ? 'Trip successfully updated!' : 'New trip successfully added!',
                                  style: GoogleFonts.plusJakartaSans(),
                                ),
                                backgroundColor: AppColors.islandPink,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            Navigator.pop(context); // Kembali ke halaman sebelumnya
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.islandPink,
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        child: Text(
                          widget.isEditing ? "Save Changes" : "Create Trip",
                          style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: GoogleFonts.fredoka(
          fontSize: 16,
          color: AppColors.deepTeal,
        ),
      ),
    );
  }

  // Input Field dengan Logika Validasi Aktif
  Widget _buildValidatedTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.deepTeal,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.deepTeal.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextFormField(
              controller: controller,
              maxLines: maxLines,
              keyboardType: isNumber ? TextInputType.number : TextInputType.text,
              style: GoogleFonts.plusJakartaSans(color: AppColors.deepTeal),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '$label cannot be empty'; // Validasi otomatis jika kosong
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.plusJakartaSans(color: AppColors.greyText.withValues(alpha: 0.5)),
                filled: false,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}