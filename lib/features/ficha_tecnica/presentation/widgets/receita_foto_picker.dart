import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';

class ReceitaFotoPicker extends StatelessWidget {
  final File? imagemReceita;
  final VoidCallback onTap;

  const ReceitaFotoPicker({
    super.key,
    required this.imagemReceita,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        hoverColor: AppColors.primary.withValues(alpha: 0.05),
        splashColor: AppColors.primary.withValues(alpha: 0.1),
        highlightColor: AppColors.primary.withValues(alpha: 0.05),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 240,
          width: double.infinity,
          decoration: BoxDecoration(
            color: imagemReceita == null ? Colors.white : null,
            borderRadius: BorderRadius.circular(24),
            // Removemos a borda sólida quando não tem imagem para usar o CustomPaint
            border: imagemReceita != null
                ? Border.all(
                    color: Colors.transparent,
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  )
                : null,
            boxShadow: imagemReceita == null
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    )
                  ],
            image: imagemReceita != null
                ? DecorationImage(
                    image: FileImage(imagemReceita!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: imagemReceita == null
              ? CustomPaint(
                  painter: DashedBorderPainter(
                    color: const Color(0xFF9CA3AF),
                    radius: 24,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF), // Azul claro
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 32,
                            color: Color(0xFF007BFF), // Azul
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Adicionar foto da receita",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Toque para selecionar uma imagem",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.3),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.4),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 16,
                      top: 16,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.radius = 24,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
      
    var path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(radius)));
          
    var dashPath = Path();
    var distance = 0.0;
    
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
            pathMetric.extractPath(distance, distance + 8), Offset.zero);
        distance += 8 + 6; 
      }
      distance = 0.0;
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}