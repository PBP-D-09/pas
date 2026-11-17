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

Modul yang diimplementasikan pada aplikasi mobile beserta pembagian kerja per
anggota (mengikuti pembagian modul di Proyek Tengah Semester):

| Modul    | Anggota                      |
| -------- | ---------------------------- |
| Accounts | Joachim Susatiyo             |
| Catalog  | Muhammad Zaky Robbani        |
| Orders   | Anantha Kamal Eirian         |
| Map      | Awiddy Munaya Rajanadoli     |
| Reviews  | I Komang Arka Darma Laksana  |


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

Aplikasi mobile tidak menggunakan data statis sebagai sumber data utama. Autentikasi memakai DRF Token Authentication: endpoint login/register mengembalikan `token`, dipakai lewat header `Authorization: Token <key>` di setiap requestnya.

Endpoint Django REST Framework modul **Accounts**:

| Endpoint                               | Method           | Akses              |
| -------------------------------------- | ---------------- | ------------------ |
| `/api/v1/accounts/register/`           | POST             | Publik             |
| `/api/v1/accounts/register/tenant/`    | POST             | Publik             |
| `/api/v1/accounts/login/`              | POST             | Publik             |
| `/api/v1/accounts/logout/`             | POST             | Login              |
| `/api/v1/accounts/me/`                 | GET              | Login              |
| `/api/v1/accounts/profile/`            | GET/PATCH/PUT    | Pelanggan          |
| `/api/v1/accounts/profile/photo/`      | POST             | Pelanggan          |
| `/api/v1/accounts/diets/`              | GET              | Pelanggan          |
| `/api/v1/accounts/diets/toggle/`       | POST             | Pelanggan          |
| `/api/v1/accounts/allergies/`          | GET/POST         | Pelanggan          |
| `/api/v1/accounts/allergies/<id>/`     | DELETE           | Pelanggan          |
| `/api/v1/accounts/eco-points/`         | GET              | Pelanggan          |
| `/api/v1/accounts/eco-points/history/` | GET              | Pelanggan          |
| `/api/v1/accounts/eco-points/reset/`   | POST             | Pelanggan          |
| `/api/v1/accounts/diet-activities/`    | GET              | Pelanggan          |
| `/api/v1/accounts/recommendations/`    | GET              | Pelanggan          |
| `/api/v1/accounts/tenant/`             | GET/PATCH/PUT    | Tenant             |
| `/api/v1/accounts/tenant/photo/`       | POST             | Tenant             |
| `/api/v1/accounts/admin/insights/`     | GET              | Staff              |

Endpoint Django REST Framework modul **Map** (alamat pengiriman dan lokasi tenan):

| Endpoint                                | Method                  | Akses     |
| --------------------------------------- | ----------------------- | --------- |
| `/api/v1/map/tenants/`                  | GET                     | Publik    |
| `/api/v1/map/tenants/filters/`          | GET                     | Publik    |
| `/api/v1/map/search/?q=`                | GET                     | Login     |
| `/api/v1/map/reverse/?lat=&lng=`        | GET                     | Login     |
| `/api/v1/map/addresses/`                | GET/POST                | Login     |
| `/api/v1/map/addresses/<id>/`           | GET/PATCH/PUT/DELETE    | Pemilik   |
| `/api/v1/map/addresses/<id>/default/`   | POST                    | Pemilik   |
| `/api/v1/map/tenant/location/`          | GET/PUT/PATCH/DELETE    | Tenant    |

Catatan modul Map:

- `tenants/` menerima filter `q`, `city`, `category`, `open_now`, `radius` (1/3/5/10 km), serta `lat` dan `lng` sebagai titik pusat jarak. Nomor telepon tenan hanya ikut dikirim jika request membawa token.
- `search/` dan `reverse/` meneruskan pencarian ke OpenStreetMap Nominatim lewat server Django (cache 24 jam), jadi aplikasi mobile tidak memanggil Nominatim secara langsung.
- Alamat milik pengguna lain dibalas `404`. Alamat pertama otomatis menjadi alamat utama, dan hanya ada satu alamat utama per akun.
- Koordinat dikirim dan diterima sebagai angka, lalu dibulatkan ke 6 angka desimal.

## Pembagian Tugas

### Map (Awiddy Munaya Rajanadoli)

Modul Map menampilkan lokasi tenan pada peta OpenStreetMap dan mengelola alamat pengiriman pengguna di aplikasi mobile.

- **Peta tenan (publik)**: menampilkan pin lokasi tenan beserta jam buka, kategori makanan, radius pengiriman, dan jarak dari posisi pengguna. Daftar dapat difilter berdasarkan kota, kategori, status buka, dan radius.
- **Alamat pengiriman (pelanggan)**: CRUD alamat pengiriman dengan memilih titik di peta atau mencari alamat lewat Nominatim, mengisi patokan lokasi dan catatan kurir, serta memilih alamat utama yang dipakai saat checkout di modul Orders.
- **Lokasi tenan (tenant)**: tenant mengatur titik lokasi usaha, alamat, jam operasional, dan radius pengiriman.
- **Integrasi**: semua data berasal dari endpoint `/api/v1/map/` pada web Django, diakses melalui `ApiClient` di `lib/core/network/` dan Clean Architecture di `lib/features/map/`.

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
