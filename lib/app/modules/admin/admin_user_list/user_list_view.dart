import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'user_list_controller.dart';

class AdminUserListView extends GetView<AdminUserListController> {
  const AdminUserListView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppTheme.deepPurpleDark, Color(0xFF251742), AppTheme.deepPurpleDark])
              : const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFF8F5FF), Color(0xFFFFF9F0)]),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(isDark),
              _buildSearchBar(isDark),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator(color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary));
                  }
                  
                  final users = controller.filteredUsers;
                  
                  if (users.isEmpty) {
                    return _buildEmptyState(isDark);
                  }
                  
                  return RefreshIndicator(
                    onRefresh: controller.refreshUsers,
                    color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemCount: users.length,
                      itemBuilder: (context, index) => _buildUserCard(users[index], index, isDark),
                    ),
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
            child: IconButton(icon: Icon(Icons.arrow_back_rounded, color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary), onPressed: () => Get.back()),
          ),
          const SizedBox(width: 16),
          Text('Daftar User', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppTheme.lightOnText)),
          const Spacer(),
          Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: isDark ? LinearGradient(colors: [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)]) : null,
                  color: isDark ? null : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)],
                ),
                child: Text('${controller.filteredUsers.length} user', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary)),
              )),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.4), AppTheme.deepPurpleDark.withValues(alpha: 0.6)]) : null,
          color: isDark ? null : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : Colors.transparent),
          boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
        ),
        child: TextField(
          onChanged: (value) => controller.searchQuery.value = value,
          style: GoogleFonts.poppins(color: isDark ? Colors.white : AppTheme.lightOnText),
          decoration: InputDecoration(
            hintText: 'Cari user...',
            hintStyle: GoogleFonts.poppins(color: isDark ? Colors.white38 : Colors.grey),
            prefixIcon: Icon(Icons.search, color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
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
            child: Icon(Icons.people_outline, size: 56, color: isDark ? AppTheme.accentMustard.withValues(alpha: 0.5) : AppTheme.lightPrimary.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 20),
          Text('Tidak ada user', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : Colors.grey[600])),
          const SizedBox(height: 8),
          Text('User terdaftar akan muncul di sini', style: GoogleFonts.poppins(fontSize: 13, color: isDark ? Colors.white38 : Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user, int index, bool isDark) {
    final colors = [Colors.blue, Colors.green, Colors.purple, Colors.orange, Colors.teal, Colors.pink];
    final avatarColor = colors[index % colors.length];
    final hasAvatar = user['avatar_url'] != null && user['avatar_url'].toString().isNotEmpty;

    return GestureDetector(
      onTap: () => controller.showUserDetail(user),
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
              decoration: BoxDecoration(
                gradient: hasAvatar ? null : LinearGradient(colors: [avatarColor.withValues(alpha: 0.2), avatarColor.withValues(alpha: 0.1)]),
                shape: BoxShape.circle,
              ),
              child: hasAvatar
                  ? ClipOval(
                      child: Image.network(
                        user['avatar_url'],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Center(
                          child: Text(
                            (user['email'] ?? 'U')[0].toUpperCase(),
                            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: avatarColor),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        (user['email'] ?? 'U')[0].toUpperCase(),
                        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: avatarColor),
                      ),
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user['full_name'] ?? 'Tanpa Nama',
                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppTheme.lightOnText),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user['email'] ?? '',
                    style: GoogleFonts.poppins(fontSize: 12, color: isDark ? Colors.white54 : Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (user['phone'] != null && user['phone'].toString().isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 12, color: isDark ? Colors.white38 : Colors.grey),
                        const SizedBox(width: 4),
                        Text(user['phone'], style: GoogleFonts.poppins(fontSize: 11, color: isDark ? Colors.white38 : Colors.grey)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: isDark 
                    ? LinearGradient(colors: [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)]) 
                    : LinearGradient(colors: [AppTheme.lightPrimary.withValues(alpha: 0.12), AppTheme.lightPrimary.withValues(alpha: 0.05)]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.arrow_forward_ios, size: 16, color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
