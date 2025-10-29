import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:_89_secondstufff/app/modules/chat/chat_controller.dart';

// Ganti dari StatelessWidget ke GetView
class ChatView extends GetView<ChatController> {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat with Admin', // <-- Ganti dari Owner
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 1,
      ),
      body: Column(
        children: [
          // 1. Area Chat (Daftar Pesan)
          Expanded(
            child: Obx(
              () => ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(16.0),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  final isMe = message.senderId == controller.currentUserId;
                  return _buildChatBubble(theme, isMe, message.text);
                },
              ),
            ),
          ),
          // 2. Area Input Teks
          _buildTextInput(theme),
        ],
      ),
    );
  }

  // Widget untuk gelembung chat
  Widget _buildChatBubble(ThemeData theme, bool isMe, String text) {
    final alignment = isMe ? Alignment.centerRight : Alignment.centerLeft;
    final color = isMe
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withOpacity(0.1);
    final textColor =
        isMe ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface;

    return Align(
      alignment: alignment,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isMe ? const Radius.circular(20) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
        ),
      ),
    );
  }

  // Widget untuk input teks di bagian bawah
  Widget _buildTextInput(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.textController,
                decoration: InputDecoration(
                  hintText: 'Ketik pesan...',
                  filled: true,
                  fillColor: theme.colorScheme.onSurface.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                onSubmitted: (_) => controller.sendMessage(),
              ),
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              backgroundColor: theme.colorScheme.primary,
              radius: 24,
              child: IconButton(
                icon: Icon(Icons.send, color: theme.colorScheme.onPrimary),
                onPressed: controller.sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
