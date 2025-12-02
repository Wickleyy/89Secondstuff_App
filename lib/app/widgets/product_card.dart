import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:_89_secondstufff/app/data/models/product_model.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: isDark 
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.deepPurpleLight.withValues(alpha: 0.6),
                    AppTheme.deepPurpleDark.withValues(alpha: 0.8),
                  ],
                )
              : null,
            color: isDark ? null : Colors.white,
            boxShadow: [
              BoxShadow(
                color: isDark 
                  ? AppTheme.glowPurple.withValues(alpha: 0.25)
                  : Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
                spreadRadius: isDark ? 1 : 0,
              ),
            ],
            border: Border.all(
              color: isDark 
                ? AppTheme.glowPurple.withValues(alpha: 0.2)
                : colorScheme.outline.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: isDark 
                            ? AppTheme.deepPurpleDark.withValues(alpha: 0.5)
                            : Colors.grey[50],
                        ),
                        child: CachedNetworkImage(
                          imageUrl: widget.product.image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: isDark ? AppTheme.accentMustard : colorScheme.primary,
                            ),
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.image_not_supported_rounded,
                            color: isDark ? AppTheme.glowPurple : Colors.grey[400],
                            size: 40,
                          ),
                        ),
                      ),
                      // Gradient overlay for dark mode
                      if (isDark)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 40,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  AppTheme.deepPurpleDark.withValues(alpha: 0.8),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Detail Section
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.product.title,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : colorScheme.onSurface,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDark 
                                ? [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)]
                                : [colorScheme.primary.withValues(alpha: 0.1), colorScheme.secondary.withValues(alpha: 0.05)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            NumberFormat.currency(
                              locale: 'id_ID',
                              symbol: 'Rp ',
                              decimalDigits: 0,
                            ).format(widget.product.price),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppTheme.accentMustard : colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
