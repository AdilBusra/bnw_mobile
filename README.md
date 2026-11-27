# BNW Mobile — Travel & Open Trip Booking App

Aplikasi mobile pemesanan paket wisata (*Open Trip*, *Private Trip*, *Family Trip*, *Honeymoon*, dan *Corporate*) berbasis **Flutter** dan **Firebase** yang dilengkapi portal pelanggan serta dashboard manajemen admin secara *real-time*.

## Tim Pengembang
| Nama | NIM | Program Studi |
| :--- | :--- | :--- |
| Muhammad Adil Busra | 241401027 | S-1 Ilmu Komputer — Universitas Sumatera Utara |
| Leonard Auguste | 241401078 | S-1 Ilmu Komputer — Universitas Sumatera Utara |
| Kayla Andhara | 241401081 | S-1 Ilmu Komputer — Universitas Sumatera Utara |

## Fitur Utama

### Portal Customer
* **Autentikasi & Profil Pengguna:** Registrasi, login, auto-login berbasis Firebase Auth, serta pembaruan nama, nomor WhatsApp, dan foto profil yang tersinkronisasi dengan Cloud Firestore.
* **Eksplorasi & Filter Destinasi:** Pencarian destinasi, filter kategori perjalanan, banner promo, dan tampilan kartu paket wisata *real-time*.
* **Detail Trip & Rundown Itinerary:** Informasi lengkap harga, kuota, fasilitas paket, susunan kegiatan per hari (*itinerary*), ulasan peserta, serta asisten AI chat perjalanan.
* **Wishlist Tersinkronisasi:** Simpan dan kelola daftar destinasi favorit langsung ke akun pengguna di Firestore.
* **Pemesanan & E-Ticket:** Alur booking jumlah peserta, unggah bukti transfer pembayaran, pantau status verifikasi (`Pending`, `Verified`, `Rejected`), unggah ulang bukti jika ditolak, dan pembatalan pesanan tertunda.

### Portal Admin
* **Dashboard Statistik:** Ringkasan total booking, pengguna aktif, pembayaran menunggu verifikasi, dan peringatan trip dengan kuota menipis (*Low Quota*).
* **Manajemen Paket Trip (CRUD):** Tambah, ubah, dan hapus paket perjalanan beserta kuota, fasilitas, dan gambar destinasi.
* **Verifikasi Pembayaran:** Tinjau bukti transfer dari pelanggan untuk menyetujui (*Verify*) atau menolak (*Reject*) dengan catatan admin.
* **Participant Manifest:** Rekap daftar peserta terverifikasi maupun menunggu verifikasi per paket trip lengkap dengan fitur salin manifest ke clipboard.
* **Itinerary Management (CRUD):** Pengelolaan jadwal kegiatan perjalanan per hari (*Day*, jam, judul kegiatan, titik lokasi, dan deskripsi) yang langsung tampil pada halaman detail trip pelanggan.

## Struktur Direktori `lib/`
```text
lib/
├── core/               # Konfigurasi tema, warna, dan state store admin
├── models/             # Model data (UserModel, BookingModel, PaymentModel, TripModel, ItineraryModel)
├── screens/
│   ├── admin/          # Dashboard, manajemen trip, verifikasi bayar, manifest, itinerary
│   ├── auth/           # Login dan registrasi pengguna
│   └── customer/       # Home, katalog, detail trip, booking, tiket, saved, profil, AI chat
├── services/           # Integrasi Firebase Auth & Cloud Firestore
└── widgets/            # Komponen UI reusable untuk admin dan customer