import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'chat_detail_controller.dart';

class AdminChatDetailView extends GetView<AdminChatDetailController> {
  const AdminChatDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppTheme.deepPurpleDark, Color(0xFF251742), AppTheme.deepPurpleDark])
              : const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFFFF6E5), Color(0xFFFFF9F0)]),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(isDark),
              Expanded(child: _buildChatList(isDark)),
              _buildTextInput(isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.5), AppTheme.deepPurpleDark.withValues(alpha: 0.3)]) : null,
        color: isDark ? null : Colors.white,
        border: Border(bottom: BorderSide(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.1))),
        boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: isDark ? LinearGradient(colors: [AppTheme.glowPurple.withValues(alpha: 0.3), AppTheme.deepPurpleLight.withValues(alpha: 0.3)]) : null,
              color: isDark ? null : const Color(0xFFD87C34).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(icon: Icon(Icons.arrow_back_rounded, color: isDark ? AppTheme.accentMustard : const Color(0xFF4E342E)), onPressed: () => Get.back()),
          ),
          const SizedBox(width: 14),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(gradient: LinearGradient(colors: isDark ? [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)] : [const Color(0xFFD87C34).withValues(alpha: 0.15), const Color(0xFFD87C34).withValues(alpha: 0.05)]), shape: BoxShape.circle),
            child: Text(controller.targetUser.email?[0].toUpperCase() ?? 'U', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? AppTheme.accentMustard : const Color(0xFFD87C34))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(controller.targetUser.email ?? 'User', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF4E342E)), maxLines: 1, overflow: TextOverflow.ellipsis),
                Row(
                  children: [
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text('Online', style: GoogleFonts.poppins(fontSize: 12, color: Colors.green)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList(bool isDark) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator(color: isDark ? AppTheme.accentMustard : const Color(0xFFD87C34)));
      }

      if (controller.messages.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(gradient: isDark ? LinearGradient(colors: [AppTheme.glowPurple.withValues(alpha: 0.2), AppTheme.deepPurpleLight.withValues(alpha: 0.1)]) : LinearGradient(colors: [const Color(0xFFD87C34).withValues(alpha: 0.1), const Color(0xFFD87C34).withValues(alpha: 0.05)]), shape: BoxShape.circle),
                child: Icon(Icons.chat_bubble_outline, size: 48, color: isDark ? AppTheme.accentMustard.withValues(alpha: 0.5) : const Color(0xFFD87C34).withValues(alpha: 0.4)),
              ),
              const SizedBox(height: 16),
              Text('Belum ada percakapan', style: GoogleFonts.poppins(fontSize: 16, color: isDark ? Colors.white60 : Colors.grey[600])),
            ],
          ),
        );
      }

      WidgetsBinding.instance.addPostFrameCallback((_) => controller.scrollToBottom());

      return ListView.builder(
        controller: controller.scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: controller.messages.length,
        itemBuilder: (context, index) {
          final message = controller.messages[index];
          final isMe = message.senderId == controller.targetUser.id;
          return _buildChatBubble(message.text, isMe, isDark);
        },
      );
    });
  }

  Widget _buildChatBubble(String text, bool isMe, bool isDark) {
    // isMe = pesan dari USER (kiri), !isMe = pesan dari ADMIN (kanan)
    return Align(
      alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: Get.width * 0.75),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          gradient: isMe
              ? (isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.5), AppTheme.deepPurpleDark.withValues(alpha: 0.7)]) : null)
              : LinearGradient(colors: isDark ? [AppTheme.accentMustard, AppTheme.accentRed] : [const Color(0xFFD87C34), const Color(0xFFE59849)]),
          color: isMe ? (isDark ? null : Colors.white) : null,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isMe ? Radius.zero : const Radius.circular(20),
            bottomRight: isMe ? const Radius.circular(20) : Radius.zero,
          ),
          boxShadow: isMe ? null : [BoxShadow(color: (isDark ? AppTheme.accentMustard : const Color(0xFFD87C34)).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))],
          border: isMe ? Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.1)) : null,
        ),
        child: Text(text, style: GoogleFonts.poppins(fontSize: 14, color: isMe ? (isDark ? Colors.white : const Color(0xFF4E342E)) : Colors.white)),
      ),
    );
  }

  Widget _buildTextInput(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isDark ? const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppTheme.deepPurpleLight, AppTheme.deepPurpleDark]) : null,
        color: isDark ? null : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, -4))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.4), AppTheme.deepPurpleDark.withValues(alpha: 0.6)]) : null,
                color: isDark ? null : Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : Colors.transparent),
              ),
              child: TextField(
                controller: controller.textController,
                style: GoogleFonts.poppins(color: isDark ? Colors.white : const Color(0xFF4E342E)),
                decoration: InputDecoration(
                  hintText: 'Ketik balasan...',
                  hintStyle: GoogleFonts.poppins(color: isDark ? Colors.white38 : Colors.grey[500]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                ),
                onSubmitted: (_) => controller.sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: isDark ? [AppTheme.accentMustard, AppTheme.accentRed] : [const Color(0xFFD87C34), const Color(0xFFE59849)]),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: (isDark ? AppTheme.accentMustard : const Color(0xFFD87C34)).withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: IconButton(icon: const Icon(Icons.send_rounded, color: Colors.white), onPressed: controller.sendMessage),
          ),
        ],
      ),
    );
  }
}
