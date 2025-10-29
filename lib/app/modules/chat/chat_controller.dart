import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/models/message_model.dart';

class ChatController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // 'user_id_123' adalah ID user (dummy)
  // 'admin_id' adalah ID admin toko (dummy)
  final String currentUserId = 'user_id_123';
  final String adminId = 'admin_id'; // <-- Ganti dari ownerId

  var messages = <Message>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load contoh percakapan
    _loadDummyMessages();
  }

  void _loadDummyMessages() {
    messages.assignAll([
      Message(
        id: '1',
        text: 'Halo, apakah produk "John Hardy Naga Gold" masih ada?',
        senderId: currentUserId,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      Message(
        id: '2',
        text: 'Halo! Masih ada, kak. Silakan diorder.',
        senderId: adminId, // <-- Ganti dari ownerId
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
      ),
      Message(
        id: '3',
        text: 'Oke, siap. Terima kasih!',
        senderId: currentUserId,
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
    ]);
  }

  void sendMessage() {
    final text = textController.text;
    if (text.isEmpty) return;

    // 1. Tambahkan pesan user ke list
    final userMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      senderId: currentUserId,
      timestamp: DateTime.now(),
    );
    messages.add(userMessage);
    textController.clear();
    _scrollToBottom();

    // 2. Buat balasan otomatis dari admin (dummy)
    Future.delayed(const Duration(seconds: 1), () {
      final adminMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: 'Baik, kak. Pesanan akan segera kami proses ya.',
        senderId: adminId, // <-- Ganti dari ownerId
        timestamp: DateTime.now(),
      );
      messages.add(adminMessage);
      _scrollToBottom();
    });
  }

  // Helper untuk auto-scroll ke pesan terbaru
  void _scrollToBottom() {
    // Beri sedikit jeda agar UI sempat update
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
