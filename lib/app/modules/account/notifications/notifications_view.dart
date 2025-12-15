import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'package:_89_secondstufff/app/data/services/notification_service.dart';
import 'package:timeago/timeago.dart' as timeago; // Error import hilang setelah 'flutter pub add timeago'

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppTheme.deepPurpleDark, Color(0xFF251742), AppTheme.deepPurpleDark],
                )
              : null,
          color: isDark ? null : theme.colorScheme.surface,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(isDark),
              Expanded(
                child: GetX<NotificationService>(
                  builder: (controller) {
                    if (controller.notifications.isEmpty) {
                      return _buildEmptyState(isDark);
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: controller.notifications.length,
                      itemBuilder: (context, index) {
                        final notification = controller.notifications[index];
                        return _buildNotificationCard(notification, isDark, controller);
                      },
                    );
                  },
                ),
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
              gradient: isDark
                  ? LinearGradient(colors: [AppTheme.glowPurple.withValues(alpha: 0.3), AppTheme.deepPurpleLight.withValues(alpha: 0.3)])
                  : null,
              color: isDark ? null : Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary),
              onPressed: () => Get.back(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Notifikasi',
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppTheme.lightOnText),
            ),
          ),
          GetX<NotificationService>(
            builder: (controller) {
              if (controller.notifications.isEmpty) return const SizedBox.shrink();
              return PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: isDark ? Colors.white70 : Colors.grey),
                color: isDark ? AppTheme.deepPurpleLight : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                onSelected: (value) {
                  if (value == 'read_all') {
                    controller.markAllAsRead();
                    Get.snackbar('Berhasil', 'Semua notifikasi ditandai sudah dibaca', snackPosition: SnackPosition.BOTTOM);
                  } else if (value == 'clear_all') {
                    controller.clearAllNotifications();
                    Get.snackbar('Berhasil', 'Semua notifikasi dihapus', snackPosition: SnackPosition.BOTTOM);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'read_all',
                    child: Row(
                      children: [
                        Icon(Icons.done_all, size: 20, color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary),
                        const SizedBox(width: 12),
                        Text('Tandai Semua Dibaca', style: GoogleFonts.poppins(color: isDark ? Colors.white : Colors.black87)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'clear_all',
                    child: Row(
                      children: [
                        const Icon(Icons.delete_sweep, size: 20, color: Colors.red),
                        const SizedBox(width: 12),
                        Text('Hapus Semua', style: GoogleFonts.poppins(color: isDark ? Colors.white : Colors.black87)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
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
            decoration: BoxDecoration(
              gradient: isDark
                  ? LinearGradient(colors: [AppTheme.glowPurple.withValues(alpha: 0.2), AppTheme.deepPurpleLight.withValues(alpha: 0.1)])
                  : LinearGradient(colors: [AppTheme.lightPrimary.withValues(alpha: 0.1), AppTheme.lightPrimary.withValues(alpha: 0.05)]),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: 56,
              color: isDark ? AppTheme.accentMustard.withValues(alpha: 0.5) : AppTheme.lightPrimary.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Belum ada notifikasi',
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Notifikasi akan muncul di sini',
            style: GoogleFonts.poppins(fontSize: 13, color: isDark ? Colors.white38 : Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification, bool isDark, NotificationService controller) {
    final timeAgo = timeago.format(notification.createdAt, locale: 'id');

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => controller.removeNotification(notification.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: () {
          if (!notification.isRead) {
            controller.markAsRead(notification.id);
          }
          // Navigate based on type
          if (notification.data != null) {
            // FIXED: Mengubah _navigateFromNotification menjadi navigateFromNotification (harus public di service)
            controller.navigateFromNotification(notification.data!);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: isDark
                ? LinearGradient(colors: [
                    notification.isRead
                        ? AppTheme.deepPurpleLight.withValues(alpha: 0.3)
                        : AppTheme.deepPurpleLight.withValues(alpha: 0.5),
                    notification.isRead
                        ? AppTheme.deepPurpleDark.withValues(alpha: 0.5)
                        : AppTheme.deepPurpleDark.withValues(alpha: 0.7),
                  ])
                : null,
            color: isDark ? null : (notification.isRead ? Colors.white : Colors.blue.withValues(alpha: 0.05)),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? (notification.isRead ? AppTheme.glowPurple.withValues(alpha: 0.1) : AppTheme.glowPurple.withValues(alpha: 0.3))
                  : (notification.isRead ? Colors.transparent : Colors.blue.withValues(alpha: 0.2)),
            ),
            boxShadow: isDark
                ? [BoxShadow(color: AppTheme.glowPurple.withValues(alpha: notification.isRead ? 0.05 : 0.15), blurRadius: 10)]
                : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    notification.iconColor.withValues(alpha: 0.2),
                    notification.iconColor.withValues(alpha: 0.1),
                  ]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(notification.icon, color: notification.iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: isDark ? Colors.white60 : Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      timeAgo,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: isDark ? Colors.white38 : Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}