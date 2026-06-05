import 'package:flutter/material.dart';

class IngredientPreview extends StatelessWidget {
  final String nome;
  final double quantidade;
  final String unidade;
  final double custoTotal;

  const IngredientPreview({
    super.key,
    required this.nome,
    required this.quantidade,
    required this.unidade,
    required this.custoTotal,
  });

  @override
  Widget build(BuildContext context) {
    if (nome.isEmpty && quantidade <= 0) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Pré-visualização",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 8),
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 300),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.95 + (0.05 * value),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: Card(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.restaurant_menu, color: Color(0xFF4B5563), size: 20),
              ),
              title: Text(
                nome.isEmpty ? "Novo ingrediente" : nome,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              subtitle: Text(
                "${quantidade.toStringAsFixed(quantidade.truncateToDouble() == quantidade ? 0 : 2).replaceAll('.', ',')} $unidade",
                style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13),
              ),
              trailing: Text(
                "R\$ ${custoTotal.toStringAsFixed(2).replaceAll('.', ',')}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
