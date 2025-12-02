import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:_89_secondstufff/app/modules/chat/chat_controller.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppTheme.deepPurpleDark, Color(0xFF251742), AppTheme.deepPurpleDark])
              : null,
          color: isDark ? null : colorScheme.surface,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(isDark, colorScheme),
              Expanded(child: _buildChatList(isDark, colorScheme)),
              _buildTextInput(isDark, colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isDark, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.5), AppTheme.deepPurpleDark.withValues(alpha: 0.3)]) : null,
        border: Border(bottom: BorderSide(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : colorScheme.outline.withValues(alpha: 0.1))),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: isDark ? LinearGradient(colors: [AppTheme.glowPurple.withValues(alpha: 0.3), AppTheme.deepPurpleLight.withValues(alpha: 0.3)]) : null,
              color: isDark ? null : colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(icon: Icon(Icons.arrow_back_rounded, color: isDark ? AppTheme.accentMustard : colorScheme.primary), onPressed: () => Get.back()),
          ),
          const SizedBox(width: 14),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: isDark ? [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)] : [colorScheme.primary.withValues(alpha: 0.15), colorScheme.primary.withValues(alpha: 0.05)]),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.support_agent, color: isDark ? AppTheme.accentMustard : colorScheme.primary, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Admin Support', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : colorScheme.onSurface)),
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

  Widget _buildChatList(bool isDark, ColorScheme colorScheme) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator(color: isDark ? AppTheme.accentMustard : colorScheme.primary));
      }

      if (controller.messages.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(gradient: isDark ? LinearGradient(colors: [AppTheme.glowPurple.withValues(alpha: 0.2), AppTheme.deepPurpleLight.withValues(alpha: 0.1)]) : null, shape: BoxShape.circle),
                child: Icon(Icons.chat_bubble_outline, size: 48, color: isDark ? AppTheme.accentMustard.withValues(alpha: 0.5) : colorScheme.primary.withValues(alpha: 0.4)),
              ),
              const SizedBox(height: 16),
              Text('Belum ada percakapan', style: GoogleFonts.poppins(fontSize: 16, color: isDark ? Colors.white60 : colorScheme.onSurface.withValues(alpha: 0.5))),
              const SizedBox(height: 8),
              Text('Mulai chat dengan admin!', style: GoogleFonts.poppins(fontSize: 13, color: isDark ? Colors.white38 : colorScheme.onSurface.withValues(alpha: 0.4))),
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
          final isMe = message.senderId == controller.currentUserId;
          return _buildChatBubble(message.text, isMe, isDark, colorScheme);
        },
      );
    });
  }

  Widget _buildChatBubble(String text, bool isMe, bool isDark, ColorScheme colorScheme) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: Get.width * 0.75),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          gradient: isMe
              ? LinearGradient(colors: isDark ? [AppTheme.accentMustard, AppTheme.accentRed] : [colorScheme.primary, colorScheme.secondary])
              : (isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.5), AppTheme.deepPurpleDark.withValues(alpha: 0.7)]) : null),
          color: isMe ? null : (isDark ? null : colorScheme.surfaceContainerHighest),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isMe ? const Radius.circular(20) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(20),
          ),
          boxShadow: isMe ? [BoxShadow(color: (isDark ? AppTheme.accentMustard : colorScheme.primary).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))] : null,
          border: isMe ? null : Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : colorScheme.outline.withValues(alpha: 0.1)),
        ),
        child: Text(text, style: GoogleFonts.poppins(fontSize: 14, color: isMe ? Colors.white : (isDark ? Colors.white : colorScheme.onSurface))),
      ),
    );
  }

  Widget _buildTextInput(bool isDark, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isDark ? const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppTheme.deepPurpleLight, AppTheme.deepPurpleDark]) : null,
        color: isDark ? null : colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, -4))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.4), AppTheme.deepPurpleDark.withValues(alpha: 0.6)]) : null,
                color: isDark ? null : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : Colors.transparent),
              ),
              child: TextField(
                controller: controller.textController,
                style: GoogleFonts.poppins(color: isDark ? Colors.white : colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'Ketik pesan...',
                  hintStyle: GoogleFonts.poppins(color: isDark ? Colors.white38 : colorScheme.onSurface.withValues(alpha: 0.4)),
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
              gradient: LinearGradient(colors: isDark ? [AppTheme.accentMustard, AppTheme.accentRed] : [colorScheme.primary, colorScheme.secondary]),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: (isDark ? AppTheme.accentMustard : colorScheme.primary).withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.white),
              onPressed: controller.sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
