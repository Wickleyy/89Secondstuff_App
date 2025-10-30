import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'shipping_address_controller.dart';

class ShippingAddressView extends GetView<ShippingAddressController> {
  const ShippingAddressView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Alamat Pengiriman',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 1,
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.addresses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off_outlined,
                      size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum Ada Alamat',
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: controller.addresses.length,
            itemBuilder: (context, index) {
              final address = controller.addresses[index];
              return _buildAddressCard(theme, colorScheme, address);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.snackbar('Info', 'Tambah Alamat belum tersedia',
              snackPosition: SnackPosition.BOTTOM);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAddressCard(
      ThemeData theme, ColorScheme colorScheme, Address address) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      address.name,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    if (address.isDefault)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Default',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text('Edit'),
                      onTap: () {
                        Get.snackbar('Info', 'Edit alamat belum tersedia',
                            snackPosition: SnackPosition.BOTTOM);
                      },
                    ),
                    if (!address.isDefault)
                      PopupMenuItem(
                        child: const Text('Jadikan Default'),
                        onTap: () {
                          controller.setAsDefault(address.id);
                          Get.snackbar('Success',
                              'Alamat default telah diubah',
                              snackPosition: SnackPosition.BOTTOM);
                        },
                      ),
                    PopupMenuItem(
                      child: const Text('Hapus',
                          style: TextStyle(color: Colors.red)),
                      onTap: () {
                        controller.deleteAddress(address.id);
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              address.address,
              style: theme.textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              '${address.city}, ${address.province} ${address.postalCode}',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              address.phone,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}