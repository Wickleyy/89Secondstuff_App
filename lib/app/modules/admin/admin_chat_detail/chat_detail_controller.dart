import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/models/message_model.dart';
import 'package:_89_secondstufff/app/data/models/profiles_model.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';
import 'package:_89_secondstufff/app/data/services/notification_service.dart';

class AdminChatDetailController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final SupabaseService _supabase = Get.find<SupabaseService>();

  late final String _adminId;
  late final Profile targetUser;
  var isUserOnline = false.obs;

  var messages = <Message>[].obs;
  var isLoading = true.obs;

  StreamSubscription<List<Map<String, dynamic>>>? _messageSubscription;

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is Profile) {
      targetUser = arg;
    } else {
      Get.back();
      Get.snackbar('Error', 'Gagal memuat data user.');
      return;
    }

    _adminId = _supabase.currentUser!.id;
    _supabase.joinPresenceChannel();
    _initializeChat();
    
    // Listen to online users changes
    ever(_supabase.onlineUsers, (_) {
      isUserOnline.value = _supabase.isUserOnline(targetUser.id);
    });
    isUserOnline.value = _supabase.isUserOnline(targetUser.id);
  }

  Future<void> _initializeChat() async {
    try {
      isLoading.value = true;
      await _fetchInitialMessages();
      _subscribeToNewMessages(); // Langganan ke pesan baru
    } catch (e) {
      Get.snackbar('Error', 'Gagal memulai chat: $e');
    } finally {
      isLoading.value = false;
      scrollToBottom();
    }
  }

  Future<void> _fetchInitialMessages() async {
    try {
      final response = await _supabase.client
          .from('messages')
          .select()
          .or(
            // Pesan DARI admin KE user, ATAU DARI user KE admin
            'and(sender_id.eq.$_adminId,receiver_id.eq.${targetUser.id}),'
            'and(sender_id.eq.${targetUser.id},receiver_id.eq.$_adminId)',
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
    _messageSubscription?.cancel();
    
    int previousMessageCount = messages.length;
    
    _messageSubscription = _supabase.client
        .from('messages')
        .stream(primaryKey: ['id']).listen((data) {
      // Filter manual
      final filtered = data.where((row) {
        final sender = row['sender_id'];
        final receiver = row['receiver_id'];

        // Cek apakah pesan ini adalah bagian dari percakapan saat ini
        final isUserToAdmin = sender == targetUser.id && receiver == _adminId;
        final isAdminToUser = sender == _adminId && receiver == targetUser.id;

        return isUserToAdmin || isAdminToUser;
      }).toList();

      // Buat list pesan baru dari data yang sudah difilter
      final newMessages = filtered.map((e) => Message.fromJson(e)).toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

      // Check if there's a new message from user
      if (newMessages.length > previousMessageCount) {
        final latestMessage = newMessages.last;
        if (latestMessage.senderId == targetUser.id) {
          // Show notification for new message from user
          if (Get.isRegistered<NotificationService>()) {
            NotificationService.to.showChatNotification(
              senderName: targetUser.fullName ?? 'User',
              message: latestMessage.text,
              senderId: latestMessage.senderId,
              isAdmin: true,
            );
          }
        }
      }
      
      previousMessageCount = newMessages.length;
      messages.assignAll(newMessages);
      scrollToBottom();
    });
  }

  void sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    final message = Message(
      id: 0,
      senderId: _adminId, // Admin mengirim
      receiverId: targetUser.id, // Ke user
      text: text,
      createdAt: DateTime.now(),
    );

    try {
      await _supabase.client.from('messages').insert(message.toJsonForInsert());

      textController.clear();
      scrollToBottom();
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengirim pesan: $e');
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

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    _messageSubscription?.cancel();
    super.onClose();
  }
}
