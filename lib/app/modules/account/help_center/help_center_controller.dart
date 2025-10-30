import 'package:get/get.dart';

class FAQ {
  final String question;
  final String answer;
  var isExpanded = false.obs;

  FAQ({required this.question, required this.answer});
}

class HelpCenterController extends GetxController {
  var faqs = <FAQ>[].obs;
  var selectedCategory = 'Semua'.obs;

  @override
  void onInit() {
    super.onInit();
    loadFAQs();
  }

  void loadFAQs() {
    faqs.assignAll([
      FAQ(
        question: 'Bagaimana cara membuat akun?',
        answer:
            'Klik tombol Sign Up di halaman login, isi email, username, dan password Anda, lalu konfirmasi email Anda. Akun sudah siap digunakan!',
      ),
      FAQ(
        question: 'Bagaimana cara mengubah password?',
        answer:
            'Pergi ke halaman Akun, pilih Edit Profil, kemudian pilih opsi "Ubah Password" dan ikuti instruksinya.',
      ),
      FAQ(
        question: 'Berapa lama proses pengiriman?',
        answer:
            'Pengiriman standar memakan waktu 3-5 hari kerja. Pengiriman express tersedia dalam 1-2 hari kerja dengan biaya tambahan.',
      ),
      FAQ(
        question: 'Bagaimana jika produk tidak sesuai?',
        answer:
            'Anda dapat mengajukan pengembalian dalam waktu 7 hari. Hubungi customer service kami dengan foto produk dan informasi pesanan Anda.',
      ),
      FAQ(
        question: 'Apakah ada biaya tambahan selain harga produk?',
        answer:
            'Harga yang ditampilkan sudah termasuk pajak. Biaya pengiriman akan ditambahkan saat checkout sesuai pilihan Anda.',
      ),
      FAQ(
        question: 'Bagaimana cara melacak pesanan saya?',
        answer:
            'Pergi ke Riwayat Pesanan, klik pesanan yang ingin dilacak, dan Anda akan melihat status dan nomor tracking pengiriman.',
      ),
    ]);
  }

  void toggleFAQ(int index) {
    faqs[index].isExpanded.value = !faqs[index].isExpanded.value;
  }
}