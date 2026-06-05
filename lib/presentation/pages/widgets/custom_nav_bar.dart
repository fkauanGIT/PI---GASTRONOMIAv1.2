import 'dart:ui';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const double navBarHeight = 70.0;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: navBarHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildBar(context),
          _buildCenterButton(context),
        ],
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final barColor = isDark
        ? const Color(0xFF1E1E1E).withValues(alpha: 0.92)
        : Colors.white.withValues(alpha: 0.88);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(28),
        topRight: Radius.circular(28),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: navBarHeight,
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black54 : Colors.black26,
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(icon: Icons.home_rounded, label: 'Início', index: 0, currentIndex: currentIndex, onTap: onTap, cs: cs),
                _NavItem(icon: Icons.favorite_rounded, label: 'Favoritos', index: 1, currentIndex: currentIndex, onTap: onTap, cs: cs),
                const SizedBox(width: 64),
                _NavItem(icon: Icons.person_rounded, label: 'Perfil', index: 3, currentIndex: currentIndex, onTap: onTap, cs: cs),
                _NavItem(icon: Icons.settings_rounded, label: 'Config.', index: 4, currentIndex: currentIndex, onTap: onTap, cs: cs),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCenterButton(BuildContext context) {
    return Positioned(
      top: 6,
      left: 0,
      right: 0,
      child: Center(
        child: _CenterFabButton(
          isSelected: currentIndex == 2,
          onTap: () => onTap(2),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final ColorScheme cs;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
    required this.cs,
  });

  bool get _isSelected => currentIndex == index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _isSelected ? cs.primary.withValues(alpha: 0.10) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: _isSelected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                size: 24,
                color: _isSelected ? cs.primary : cs.onSurface.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: _isSelected ? FontWeight.w700 : FontWeight.w500,
                color: _isSelected ? cs.primary : cs.onSurface.withValues(alpha: 0.4),
              ),
              child: Text(label),
            ),
            const SizedBox(height: 2),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              width: _isSelected ? 16 : 0,
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterFabButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const _CenterFabButton({required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSelected
                ? [primary.withValues(alpha: 0.8), primary]
                : [primary, primary.withValues(alpha: 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.45),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
    );
  }
}
