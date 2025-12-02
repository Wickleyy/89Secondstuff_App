import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'map_picker_controller.dart';

class MapPickerView extends GetView<MapPickerController> {
  const MapPickerView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Obx(() => FlutterMap(
                mapController: controller.mapController,
                options: MapOptions(initialCenter: controller.selectedLocation.value, initialZoom: 15.0, onTap: controller.onMapTap),
                children: [
                  TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.example.89secondstuff'),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: controller.selectedLocation.value,
                        width: 60,
                        height: 60,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: isDark ? [AppTheme.accentMustard, AppTheme.accentRed] : [colorScheme.primary, colorScheme.secondary]),
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: (isDark ? AppTheme.accentMustard : colorScheme.primary).withValues(alpha: 0.4), blurRadius: 12, spreadRadius: 2)],
                          ),
                          child: const Icon(Icons.location_pin, color: Colors.white, size: 36),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildAppBar(isDark, colorScheme),
                  const SizedBox(height: 12),
                  _buildSearchBar(isDark, colorScheme),
                  const SizedBox(height: 8),
                  _buildSearchResults(isDark, colorScheme),
                ],
              ),
            ),
          ),
          Positioned(right: 16, bottom: 220, child: _buildMapControls(isDark, colorScheme)),
          _buildBottomSheet(isDark, colorScheme),
          Obx(() {
            if (controller.isLoading.value) {
              return Container(color: Colors.black38, child: Center(child: CircularProgressIndicator(color: isDark ? AppTheme.accentMustard : colorScheme.primary)));
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildAppBar(bool isDark, ColorScheme colorScheme) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.9), AppTheme.deepPurpleDark.withValues(alpha: 0.9)]) : null,
            color: isDark ? null : Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 10)],
          ),
          child: IconButton(icon: Icon(Icons.arrow_back_rounded, color: isDark ? AppTheme.accentMustard : colorScheme.primary), onPressed: () => Get.back()),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.9), AppTheme.deepPurpleDark.withValues(alpha: 0.9)]) : null,
            color: isDark ? null : Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 10)],
          ),
          child: Text('Pilih Lokasi', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: isDark ? Colors.white : colorScheme.onSurface)),
        ),
      ],
    );
  }

  Widget _buildSearchBar(bool isDark, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.95), AppTheme.deepPurpleDark.withValues(alpha: 0.95)]) : null,
        color: isDark ? null : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 12)],
      ),
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.onSearchChanged,
        style: GoogleFonts.poppins(color: isDark ? Colors.white : colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: 'Cari alamat...',
          hintStyle: GoogleFonts.poppins(color: isDark ? Colors.white38 : colorScheme.onSurface.withValues(alpha: 0.4)),
          prefixIcon: Icon(Icons.search, color: isDark ? AppTheme.accentMustard : colorScheme.primary),
          suffixIcon: Obx(() {
            if (controller.isSearching.value) return Padding(padding: const EdgeInsets.all(12), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: isDark ? AppTheme.accentMustard : colorScheme.primary)));
            if (controller.searchController.text.isNotEmpty) return IconButton(icon: Icon(Icons.clear, color: isDark ? Colors.white54 : colorScheme.onSurface.withValues(alpha: 0.5)), onPressed: () { controller.searchController.clear(); controller.searchResults.clear(); });
            return const SizedBox.shrink();
          }),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildSearchResults(bool isDark, ColorScheme colorScheme) {
    return Obx(() {
      if (controller.searchResults.isEmpty) return const SizedBox.shrink();
      return Container(
        constraints: const BoxConstraints(maxHeight: 200),
        decoration: BoxDecoration(
          gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.95), AppTheme.deepPurpleDark.withValues(alpha: 0.95)]) : null,
          color: isDark ? null : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 12)],
        ),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: controller.searchResults.length,
          separatorBuilder: (_, __) => Divider(height: 1, color: isDark ? Colors.white12 : colorScheme.outline.withValues(alpha: 0.1)),
          itemBuilder: (context, index) {
            final result = controller.searchResults[index];
            return ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(gradient: LinearGradient(colors: isDark ? [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)] : [colorScheme.primary.withValues(alpha: 0.12), colorScheme.primary.withValues(alpha: 0.05)]), borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.location_on, color: isDark ? AppTheme.accentMustard : colorScheme.primary, size: 20),
              ),
              title: Text(result['display_name'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 13, color: isDark ? Colors.white : colorScheme.onSurface)),
              onTap: () => controller.selectSearchResult(result),
            );
          },
        ),
      );
    });
  }

  Widget _buildMapControls(bool isDark, ColorScheme colorScheme) {
    return Column(
      children: [
        _buildMapButton(Icons.my_location, controller.getCurrentLocation, isDark, colorScheme),
        const SizedBox(height: 8),
        Obx(() => _buildMapButton(controller.isLiveLocationActive ? Icons.gps_fixed : Icons.gps_not_fixed, () => controller.isLiveLocationActive ? controller.stopLiveLocation() : controller.startLiveLocation(), isDark, colorScheme, isActive: controller.isLiveLocationActive)),
        const SizedBox(height: 8),
        _buildMapButton(Icons.add, () => controller.mapController.move(controller.selectedLocation.value, controller.mapController.camera.zoom + 1), isDark, colorScheme),
        const SizedBox(height: 8),
        _buildMapButton(Icons.remove, () => controller.mapController.move(controller.selectedLocation.value, controller.mapController.camera.zoom - 1), isDark, colorScheme),
      ],
    );
  }

  Widget _buildMapButton(IconData icon, VoidCallback onPressed, bool isDark, ColorScheme colorScheme, {bool isActive = false}) {
    return Container(
      decoration: BoxDecoration(
        gradient: isActive ? LinearGradient(colors: isDark ? [AppTheme.accentMustard, AppTheme.accentRed] : [colorScheme.primary, colorScheme.secondary]) : (isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.95), AppTheme.deepPurpleDark.withValues(alpha: 0.95)]) : null),
        color: isActive ? null : (isDark ? null : Colors.white),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: (isActive ? (isDark ? AppTheme.accentMustard : colorScheme.primary) : Colors.black).withValues(alpha: isActive ? 0.4 : 0.15), blurRadius: 10)],
      ),
      child: IconButton(onPressed: onPressed, icon: Icon(icon, color: isActive ? Colors.white : (isDark ? AppTheme.accentMustard : colorScheme.primary))),
    );
  }

  Widget _buildBottomSheet(bool isDark, ColorScheme colorScheme) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: isDark ? const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppTheme.deepPurpleLight, AppTheme.deepPurpleDark]) : null,
          color: isDark ? null : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [BoxShadow(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, -5))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(gradient: LinearGradient(colors: isDark ? [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)] : [colorScheme.primary.withValues(alpha: 0.12), colorScheme.primary.withValues(alpha: 0.05)]), borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.location_on, color: isDark ? AppTheme.accentMustard : colorScheme.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Text('Alamat Terpilih', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16, color: isDark ? Colors.white : colorScheme.onSurface)),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: isDark ? LinearGradient(colors: [AppTheme.glowPurple.withValues(alpha: 0.15), AppTheme.deepPurpleLight.withValues(alpha: 0.1)]) : null,
                color: isDark ? null : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    if (controller.isFetchingAddress.value) {
                      return Row(children: [SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: isDark ? AppTheme.accentMustard : colorScheme.primary)), const SizedBox(width: 10), Text('Memuat alamat...', style: GoogleFonts.poppins(fontSize: 13, color: isDark ? Colors.white54 : colorScheme.onSurface.withValues(alpha: 0.5)))]);
                    }
                    return Text(controller.addressDetails['display_name'] ?? 'Pilih lokasi di peta', style: GoogleFonts.poppins(fontSize: 13, color: isDark ? Colors.white : colorScheme.onSurface), maxLines: 3, overflow: TextOverflow.ellipsis);
                  }),
                  const SizedBox(height: 8),
                  Obx(() => Text('Koordinat: ${controller.selectedLocation.value.latitude.toStringAsFixed(6)}, ${controller.selectedLocation.value.longitude.toStringAsFixed(6)}', style: GoogleFonts.poppins(fontSize: 11, color: isDark ? Colors.white38 : colorScheme.onSurface.withValues(alpha: 0.4)))),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.confirmLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? AppTheme.accentMustard : colorScheme.primary,
                  foregroundColor: isDark ? AppTheme.deepPurpleDark : colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: isDark ? 8 : 2,
                  shadowColor: isDark ? AppTheme.accentMustard.withValues(alpha: 0.5) : null,
                ),
                child: Text('KONFIRMASI LOKASI', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
