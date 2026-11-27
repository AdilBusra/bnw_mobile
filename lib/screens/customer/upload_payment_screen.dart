import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/booking_service.dart';

class UploadPaymentScreen extends StatefulWidget {
  const UploadPaymentScreen({super.key});

  @override
  State<UploadPaymentScreen> createState() => _UploadPaymentScreenState();
}

class _UploadPaymentScreenState extends State<UploadPaymentScreen> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _proofBytes;
  String? _proofBase64;
  bool _isSubmitting = false;

  Future<void> _pickProofImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 900,
        maxHeight: 900,
        imageQuality: 70,
      );
      if (picked == null) return;

      final bytes = await picked.readAsBytes();
      if (bytes.lengthInBytes > 750 * 1024) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ukuran gambar terlalu besar. Pilih foto dengan ukuran lebih kecil.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _proofBytes = bytes;
        _proofBase64 = base64Encode(bytes);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memilih gambar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _submitPayment(Map<String, dynamic> args) async {
    if (_proofBase64 == null || _proofBase64!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih foto bukti transfer terlebih dahulu.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final reuploadBookingId = args['reuploadBookingId'] as String?;

      if (reuploadBookingId != null && reuploadBookingId.isNotEmpty) {
        await BookingService.reuploadPaymentProof(
          bookingId: reuploadBookingId,
          proofBase64: _proofBase64!,
        );
      } else {
        final trip = (args['trip'] is Map<String, dynamic>)
            ? args['trip'] as Map<String, dynamic>
            : args;

        final participants = (args['participants'] as num?)?.toInt() ?? 1;
        final totalAmount = (args['totalAmount'] as num?)?.toInt() ??
            ((trip['rawPrice'] as num?)?.toInt() ?? 350000) * participants;

        await BookingService.createBooking(
          trip: trip,
          customerName: (args['customerName'] as String?) ?? 'Customer',
          customerPhone: (args['customerPhone'] as String?) ?? '-',
          tripCategory: (args['tripCategory'] as String?) ?? 'Open Trip',
          selectedDate: (args['selectedDate'] as String?) ?? '-',
          participants: participants,
          totalAmount: totalAmount,
          proofBase64: _proofBase64!,
        );
      }

      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Bukti Terkirim! 🌺'),
          content: const Text(
            'Terima kasih! Pembayaranmu telah tersimpan dan sedang diverifikasi oleh admin. Cek statusnya di menu My Tickets.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              },
              child: const Text(
                'Kembali ke Beranda',
                style: TextStyle(color: Color(0xFFF5427D), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengirim pembayaran: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ?? {
      'title': 'Sipolha Peak Sunrise',
      'price': 'Rp 350.000',
    };

    final trip = (args['trip'] is Map<String, dynamic>)
        ? args['trip'] as Map<String, dynamic>
        : args;

    final totalText = (args['formattedTotal'] as String?) ??
        (trip['price'] as String?) ??
        'Rp 350.000';

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7DF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF164C55), size: 20),
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
        ),
        title: const Text(
          'Upload Payment Proof',
          style: TextStyle(color: Color(0xFF164C55), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip['title'] ?? 'Paket Trip',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF164C55),
                    ),
                  ),
                  if (args['participants'] != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${args['participants']} Peserta • ${args['tripCategory'] ?? 'Open Trip'}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                  const SizedBox(height: 12),
                  const Text(
                    'Total Pembayaran',
                    style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    totalText,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFF5427D),
                    ),
                  ),
                  const Divider(height: 24, color: Color(0xFFFFD1DC)),
                  const Text(
                    'Silakan transfer ke Rekening BCA:',
                    style: TextStyle(fontSize: 13, color: Color(0xFF164C55)),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '123-456-7890 (a.n. PT Beyond Wanders Indonesia)',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF164C55)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Bukti Transfer',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF164C55)),
                ),
                if (_proofBytes != null)
                  TextButton.icon(
                    onPressed: _isSubmitting ? null : _pickProofImage,
                    icon: const Icon(Icons.refresh_rounded, size: 18, color: Color(0xFFF5427D)),
                    label: const Text(
                      'Ganti Foto',
                      style: TextStyle(color: Color(0xFFF5427D), fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _isSubmitting ? null : _pickProofImage,
              child: Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFFF5427D).withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: _proofBytes != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.memory(_proofBytes!, fit: BoxFit.cover),
                            Positioned(
                              bottom: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4CAF50),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.white, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      'Siap Dikirim',
                                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFD1DC),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.cloud_upload_rounded, color: Color(0xFFF5427D), size: 32),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Tap untuk pilih foto struk / bukti transfer',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF164C55)),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Format JPG / PNG dari galeri',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF5427D),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                ),
                onPressed: _isSubmitting ? null : () => _submitPayment(args),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      )
                    : const Text(
                        'Kirim Bukti Pembayaran',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}