import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/models/message_model.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';

class ChatController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final SupabaseService _supabase = Get.find<SupabaseService>();
  late final String currentUserId;
  var adminId = ''.obs;
  var isAdminOnline = false.obs;

  var messages = <Message>[].obs;
  var isLoading = true.obs;

  StreamSubscription<List<Map<String, dynamic>>>? _messageSubscription;

  @override
  void onInit() {
    super.onInit();
    currentUserId = _supabase.currentUser!.id;
    _supabase.joinPresenceChannel();
    _initializeChat();
    
    // Listen to online users changes
    ever(_supabase.onlineUsers, (_) {
      if (adminId.value.isNotEmpty) {
        isAdminOnline.value = _supabase.isUserOnline(adminId.value);
      }
    });
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    _messageSubscription?.cancel();
    super.onClose();
  }

  Future<void> _initializeChat() async {
    try {
      isLoading.value = true;
      await _fetchAdminId();
      if (adminId.value.isEmpty) {
        throw Exception("Admin tidak ditemukan.");
      }

      await _fetchInitialMessages();
      _subscribeToNewMessages();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memulai chat: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
      scrollToBottom();
    }
  }

  Future<void> _fetchAdminId() async {
    try {
      final response = await _supabase.client
          .from('profiles')
          .select('id')
          .eq('role', 'admin')
          .single();
      adminId.value = response['id'];
      isAdminOnline.value = _supabase.isUserOnline(adminId.value);
    } catch (e) {
      print("Error fetching admin ID: $e");
    }
  }

  Future<void> _fetchInitialMessages() async {
    if (adminId.value.isEmpty) return;
    try {
      final response = await _supabase.client
          .from('messages')
          .select()
          .or(
            'and(sender_id.eq.$currentUserId,receiver_id.eq.${adminId.value}),'
            'and(sender_id.eq.${adminId.value},receiver_id.eq.$currentUserId)',
          )
          .order('created_at', ascending: true);

      final messageList =
          (response as List).map((data) => Message.fromJson(data)).toList();
      messages.assignAll(messageList);
    } catch (e) {
      print("Error fetching messages: $e");
    }
  }

  void _subscribeToNewMessages() {
    if (adminId.value.isEmpty) return;

    _messageSubscription?.cancel();

    _messageSubscription = _supabase.client
        .from('messages')
        .stream(primaryKey: ['id']).listen((data) {
      // Filter manual
      final filtered = data.where((row) {
        final sender = row['sender_id'];
        final receiver = row['receiver_id'];

        final isUserToAdmin =
            sender == currentUserId && receiver == adminId.value;

        final isAdminToUser =
            sender == adminId.value && receiver == currentUserId;

        return isUserToAdmin || isAdminToUser;
      }).toList();

      final newMessages = filtered.map((e) => Message.fromJson(e)).toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

      messages.assignAll(newMessages);
      scrollToBottom();
    });
  }

  void sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty || adminId.value.isEmpty) return;

    final message = Message(
      id: 0,
      senderId: currentUserId,
      receiverId: adminId.value,
      text: text,
      createdAt: DateTime.now(),
    );

    try {
      await _supabase.client.from('messages').insert(message.toJsonForInsert());

      textController.clear();
      scrollToBottom();
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengirim pesan: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void scrollToBottom() {
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
}
