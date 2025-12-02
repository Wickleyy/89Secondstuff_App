import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'chat_list_controller.dart';

class AdminChatListView extends GetView<AdminChatListController> {
  const AdminChatListView({super.key});

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
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator(color: isDark ? AppTheme.accentMustard : const Color(0xFFD87C34)));
                  }
                  if (controller.chatList.isEmpty) {
                    return _buildEmptyState(isDark);
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: controller.chatList.length,
                    itemBuilder: (context, index) => _buildChatCard(controller.chatList[index], index, isDark),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: isDark ? LinearGradient(colors: [AppTheme.glowPurple.withValues(alpha: 0.3), AppTheme.deepPurpleLight.withValues(alpha: 0.3)]) : null,
              color: isDark ? null : Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
            ),
            child: IconButton(icon: Icon(Icons.arrow_back_rounded, color: isDark ? AppTheme.accentMustard : const Color(0xFF4E342E)), onPressed: () => Get.back()),
          ),
          const SizedBox(width: 16),
          Text('Chat Pelanggan', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF4E342E))),
          const Spacer(),
          Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.green.withValues(alpha: 0.2), Colors.green.withValues(alpha: 0.1)]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text('${controller.chatList.length} aktif', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green)),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(gradient: isDark ? LinearGradient(colors: [AppTheme.glowPurple.withValues(alpha: 0.2), AppTheme.deepPurpleLight.withValues(alpha: 0.1)]) : LinearGradient(colors: [Colors.green.withValues(alpha: 0.1), Colors.green.withValues(alpha: 0.05)]), shape: BoxShape.circle),
            child: Icon(Icons.chat_bubble_outline, size: 56, color: isDark ? AppTheme.accentMustard.withValues(alpha: 0.5) : Colors.green.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 20),
          Text('Belum ada chat', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : Colors.grey[600])),
          const SizedBox(height: 8),
          Text('Chat dari pelanggan akan muncul di sini', style: GoogleFonts.poppins(fontSize: 13, color: isDark ? Colors.white38 : Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildChatCard(dynamic profile, int index, bool isDark) {
    final colors = [Colors.blue, Colors.green, Colors.purple, Colors.orange, Colors.teal, Colors.pink];
    final avatarColor = colors[index % colors.length];

    return GestureDetector(
      onTap: () => controller.goToChatDetail(profile),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.4), AppTheme.deepPurpleDark.withValues(alpha: 0.6)]) : null,
          color: isDark ? null : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : Colors.transparent),
          boxShadow: isDark ? [BoxShadow(color: AppTheme.glowPurple.withValues(alpha: 0.15), blurRadius: 10)] : [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10)],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(gradient: LinearGradient(colors: [avatarColor.withValues(alpha: 0.2), avatarColor.withValues(alpha: 0.1)]), shape: BoxShape.circle),
              child: Center(child: Text(profile.email?[0].toUpperCase() ?? 'U', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: avatarColor))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(profile.email ?? 'User', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF4E342E)), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      Text('Online', style: GoogleFonts.poppins(fontSize: 12, color: Colors.green)),
                      const SizedBox(width: 12),
                      Expanded(child: Text('Klik untuk melihat chat...', style: GoogleFonts.poppins(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey[500]), maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: isDark ? LinearGradient(colors: [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)]) : LinearGradient(colors: [const Color(0xFFD87C34).withValues(alpha: 0.12), const Color(0xFFD87C34).withValues(alpha: 0.05)]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.arrow_forward_ios, size: 16, color: isDark ? AppTheme.accentMustard : const Color(0xFFD87C34)),
            ),
          ],
        ),
      ),
    );
  }
}
