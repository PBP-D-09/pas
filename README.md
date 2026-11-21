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

Endpoint Django REST Framework modul **Catalog**:

| Endpoint                                             | Method           | Akses              |
| ---------------------------------------------------- | ---------------- | ------------------ |
| `/api/v1/catalog/tenants/<id>/,`                     | GET              | Login              |
| `/api/v1/catalog/tenants/<id>/manage/`               | GET              | Tenant             |
| `/api/v1/catalog/tenants/menu-item/add/`             | POST             | Tenant             |
| `/api/v1/catalog/tenants/menu-item/<id>/edit/`       | GET              | Tenant             |
| `/api/v1/catalog/tenants/menu-item/<id>/save/`       | PATCH            | Tenant             |
| `/api/v1/catalog/tenants/menu-item/<id>/delete/`     | DELETE           | Tenant             |
| `/api/v1/catalog/tenants/menu-category/add/`         | POST             | Tenant             |
| `/api/v1/catalog/tenants/menu-category/<id>/edit/`   | GET              | Tenant             |
| `/api/v1/catalog/tenants/menu-category/save/`        | POST             | Tenant             |
| `/api/v1/catalog/tenants/menu-category/<id>/save/`   | PATCH            | Tenant             |
| `/api/v1/catalog/tenants/menu-category/<id>/delete/` | DELETE           | Tenant             |

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

Endpoint Django REST Framework modul **Orders** (keranjang, checkout, dan riwayat pesanan):

| Endpoint                                  | Method        | Akses     |
| ----------------------------------------- | ------------- | --------- |
| `/api/v1/orders/`                         | GET           | Pelanggan |
| `/api/v1/orders/<uuid>/`                  | GET           | Pemilik   |
| `/api/v1/orders/<uuid>/cancel/`           | POST          | Pemilik   |
| `/api/v1/orders/<uuid>/note/`             | PATCH         | Pemilik   |
| `/api/v1/orders/<uuid>/reorder/`          | POST          | Pemilik   |
| `/api/v1/orders/cart/`                    | GET           | Pelanggan |
| `/api/v1/orders/cart/items/`              | POST          | Pelanggan |
| `/api/v1/orders/cart/items/<uuid>/`       | PATCH/DELETE  | Pemilik   |
| `/api/v1/orders/checkout/`                | GET/POST      | Pelanggan |

Catatan modul Orders:

- `GET /api/v1/orders/` menerima filter `status` (`pending`, `processing`, `on_the_way`, `delivered`, `cancelled`) dan `date_range` (`today`, `7_days`, `30_days`, atau `custom` dengan `start_date`/`end_date` berformat `YYYY-MM-DD`). Respons juga berisi `status_counts` dan jumlah wadah reusable yang belum dikembalikan.
- `GET checkout/` mengembalikan isi keranjang, alamat tersimpan (dari modul Map) beserta ongkir dan estimasi waktu, serta pilihan kemasan. Reusable container otomatis `disabled` jika stok wadah salah satu tenan habis. `POST checkout/` menerima `address_id`, `packaging_type`, dan `delivery_notes`, lalu membalas pesanan baru dengan status `201`.
- Harga, ongkir, biaya kemasan, dan Eco Points selalu dihitung ulang di server. Aplikasi mobile tidak pernah mengirim angka harga.
- Pesanan hanya bisa dibatalkan dan catatannya hanya bisa diubah selama statusnya `pending`. Pesanan, item keranjang, dan alamat milik pengguna lain dibalas `404`, dan akun tenan dibalas `403`.
- Error validasi memakai format DRF (`{"detail": "..."}` atau `{"field": ["..."]}`). `HttpApiClient` menampilkan pesan tersebut apa adanya di aplikasi.

## Pembagian Tugas

### Catalog (Muhammad Zaky Robbani)

Modul Catalog menampilkan restoran tenan yang terdaftar dan menampilkan menu item dari setiap tenan

- **katalog tenan**: menampilkan semua tenan yang terdaftar sebagai sebuah card dengan photo restaurant, review, dan berbagai kategori kuliner yang disediakan.
- **katalog menu tenan**: menampilkan semua menu yang telah dibuat oleh tenan yang dapat diorder dengan mengeklik card menu tersebut. memerlukan login untuk mengakses
- **management item menu dan category**: untuk setiap tenan yang mengakses halaman katalog menunya masing-masing, terdapat opsi untuk berpindah halaman untuk mengurus pembuatan menu baru dan kategori baru per tenan
- **integrasi**: data tenan berasal dari endpoint `/api/v1/catalog`.

### Map (Awiddy Munaya Rajanadoli)

Modul Map menampilkan lokasi tenan pada peta OpenStreetMap dan mengelola alamat pengiriman pengguna di aplikasi mobile.

- **Peta tenan (publik)**: menampilkan pin lokasi tenan beserta jam buka, kategori makanan, radius pengiriman, dan jarak dari posisi pengguna. Daftar dapat difilter berdasarkan kota, kategori, status buka, dan radius.
- **Alamat pengiriman (pelanggan)**: CRUD alamat pengiriman dengan memilih titik di peta atau mencari alamat lewat Nominatim, mengisi patokan lokasi dan catatan kurir, serta memilih alamat utama yang dipakai saat checkout di modul Orders.
- **Lokasi tenan (tenant)**: tenant mengatur titik lokasi usaha, alamat, jam operasional, dan radius pengiriman.
- **Integrasi**: semua data berasal dari endpoint `/api/v1/map/` pada web Django, diakses melalui `ApiClient` di `lib/core/network/` dan Clean Architecture di `lib/features/map/`.

### Orders (Anantha Kamal Eirian)

Modul Orders menangani keranjang belanja, checkout dengan kemasan ramah lingkungan, dan riwayat pesanan pelanggan, sama seperti halaman Orders di web.

- **Keranjang**: melihat isi keranjang, mengubah jumlah item dengan stepper, dan menghapus item. Modul lain dapat menambahkan menu ke keranjang melalui `showAddToCartDialog()` di `lib/features/orders/presentation/widgets/add_to_cart_dialog.dart`, yaitu dialog konfirmasi jumlah sebelum menambahkan ke keranjang.
- **Checkout**: memilih alamat pengiriman tersimpan (beserta ongkir dan estimasi waktu), memilih reusable container atau compostable box (beserta biaya dan Eco Points), serta menulis catatan pengiriman. Setelah pesanan dibuat, aplikasi menampilkan halaman konfirmasi.
- **Riwayat pesanan (My orders)**: daftar pesanan dengan filter status dan rentang tanggal, pengingat pengembalian wadah reusable, pembatalan pesanan `pending`, pengubahan catatan pengiriman, pesan ulang (Order again), serta tombol Review yang membuka halaman Reviews untuk menu dari pesanan yang sudah `delivered`.
- **Integrasi**: semua data berasal dari endpoint `/api/v1/orders/` pada web Django dan memakai Clean Architecture di `lib/features/orders/`.

### Autentikasi sementara untuk pengembangan

`HttpApiClient` mengirim header `Authorization: Token <key>` dari `AuthToken.current` (`lib/core/network/auth_token.dart`). Modul Accounts cukup mengisi `AuthToken.current` setelah login dan mengosongkannya saat logout. Selama alur login belum tersedia, token dapat diberikan saat menjalankan aplikasi:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000 --dart-define=API_TOKEN=<token>
```

Token didapat dari `POST /api/v1/accounts/login/` (misalnya dengan akun demo `customer@demo.sustainabowl.test` / `Demo123!` setelah `python manage.py seed_demo` di repo web). Tanpa token, halaman Orders menampilkan ajakan login dan tidak memanggil API.

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
