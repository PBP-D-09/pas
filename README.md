# SustainaBowl Mobile

## Latar Belakang

Gaya hidup masyarakat perkotaan yang makin padat membuat banyak orang kesulitan menjaga konsistensi pola makan sehat. Layanan pengantaran makanan sering kali menjadi pilihan utama pengguna, tetapi membawa dampak buruk, yaitu penumpukan sampah plastik sekali pakai dan tingginya jejak karbon dari pengiriman individual yang tidak efisien. Di sisi lain, pembeli sering bingung memastikan dari mana asal bahan makanan yang mereka konsumsi.

SustainaBowl hadir sebagai platform healthy meal ordering platform yang mengintegrasikan sustainability pada setiap transaksi. Pengguna tidak hanya memesan makanan, tetapi juga memerhatikan paket bekal sehat yang dipersonalisasi sesuai kebutuhan diet mereka dan kesehatan lingkungan.

### Manfaat SustainaBowl

- Membantu masyarakat menjaga asupan gizi harian secara terencana tanpa perlu pusing memikirkan menu setiap hari atau takut kebablasan mengonsumsi junk food.
- Menghentikan penggunaan kemasan sekali pakai dengan menyediakan opsi wadah ramah lingkungan berupa reusable container atau compostable box.

## Identitas Anggota

- Joachim Susatiyo (2506602694)
- Muhammad Zaky Robbani (2506597712)
- I Komang Arka Darma Laksana (2506656791)
- Awiddy Munaya Rajanadoli (2506622872)
- Anantha Kamal Eirian (2506656425)

## Modul Aplikasi

Modul yang akan diimplementasikan pada aplikasi mobile:

- Accounts
- Catalog
- Orders
- Map
- Reviews


## Pengguna

### Customer

Customer dapat mengelola akun dan preferensi diet, melihat rekomendasi makanan, mencari menu sehat, melakukan pemesanan, memilih kemasan ramah lingkungan, menyimpan alamat pengiriman, dan memberikan review.

### Tenant

Tenant dapat mengelola katalog makanan, memproses pesanan, mengatur lokasi usaha, serta memantau review pelanggan.

## Integrasi Data

Aplikasi Flutter akan menjadi client mobile untuk data yang tetap tersimpan pada situs web Django Sustainabowl. Setiap module akan memiliki data source yang memanggil web service Django REST Framework, kemudian repository mengubah respons JSON menjadi model dan entity yang digunakan oleh presentation layer.

```text
Flutter presentation
        ↓
Provider / ChangeNotifier
        ↓
Use case dan repository
        ↓
Django REST Framework API pada project web
        ↓
Database Sustainabowl
```

Aplikasi mobile tidak menggunakan data statis sebagai sumber data utama. Detail endpoint setiap modul akan ditambahkan setelah kontrak API Django REST Framework disepakati oleh kelompok.

## Menjalankan Project

Pastikan `devenv` tersedia, lalu jalankan:

```bash
devenv shell
flutter pub get
flutter run
```

Untuk menjalankan pemeriksaan kode:

```bash
devenv shell flutter analyze
devenv shell flutter test
```

Environment Flutter dan Android didefinisikan pada `devenv.nix`.
