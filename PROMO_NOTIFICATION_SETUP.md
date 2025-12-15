# Setup Promo/Diskon Notification via Firebase Cloud Messaging

## Cara Kirim Promo ke Semua User

### 1. Buka Firebase Console
1. Pergi ke [Firebase Console](https://console.firebase.google.com)
2. Pilih project kamu
3. Klik **Messaging** di sidebar kiri (atau **Engage > Messaging**)

### 2. Buat Campaign Baru
1. Klik **"New campaign"** atau **"Create your first campaign"**
2. Pilih **"Firebase Notification messages"**
3. Klik **"Create"**

### 3. Isi Detail Notifikasi

#### Notification:
- **Notification title**: `Promo Spesial!` (atau judul promo kamu)
- **Notification text**: `Diskon 50% untuk semua produk! Gunakan kode: PROMO50`

#### Target:
- Pilih **"Topic"**
- Ketik: `promo` (atau `all_users` untuk semua user)
- Klik **"Add"**

#### Scheduling:
- Pilih **"Send now"** untuk kirim langsung
- Atau pilih **"Schedule"** untuk jadwalkan

#### Additional options (opsional):
- **Custom data**: Tambahkan key-value untuk data tambahan
  ```
  Key: type
  Value: promo
  
  Key: promo_code
  Value: PROMO50
  
  Key: discount
  Value: 50
  ```

### 4. Review & Publish
1. Klik **"Review"**
2. Cek semua detail
3. Klik **"Publish"**

---

## Contoh Promo yang Bisa Dikirim

### 1. Diskon Persentase
```
Title: Flash Sale 50%!
Body: Diskon 50% untuk semua produk fashion. Berlaku hari ini saja!
```

### 2. Gratis Ongkir
```
Title: Gratis Ongkir!
Body: Bebas ongkir untuk pembelian min Rp100.000. Kode: FREEONG
```

### 3. Promo Akhir Tahun
```
Title: Promo Akhir Tahun
Body: Diskon hingga 70% untuk semua kategori. Jangan sampai kehabisan!
```

### 4. Produk Baru
```
Title: Produk Baru Telah Hadir!
Body: Koleksi terbaru sudah tersedia. Cek sekarang!
```

---

## Topic yang Tersedia

User otomatis subscribe ke topic ini saat pertama kali buka app:

| Topic | Deskripsi |
|-------|-----------|
| `promo` | Notifikasi promo & diskon |
| `all_users` | Semua user (untuk broadcast umum) |

---

## Tips

1. **Jangan spam** - Kirim promo max 1-2x per minggu
2. **Waktu terbaik** - Kirim di jam 10-12 siang atau 7-9 malam
3. **Judul menarik** - Gunakan emoji dan kata-kata yang menarik perhatian
4. **Jelas dan singkat** - Body notifikasi max 2 baris

---

## Troubleshooting

### Notifikasi tidak muncul?
1. Pastikan app sudah di-close (background)
2. Cek apakah notifikasi diizinkan di Settings HP
3. Cek apakah user sudah subscribe ke topic

### Cara cek subscriber topic?
Di Firebase Console > Cloud Messaging > lihat statistik delivery
