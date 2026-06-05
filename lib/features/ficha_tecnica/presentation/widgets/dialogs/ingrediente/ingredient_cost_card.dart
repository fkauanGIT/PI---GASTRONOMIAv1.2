import 'package:flutter/material.dart';

class IngredientCostCard extends StatelessWidget {
  final double custoBase;
  final double fatorCorrecao;
  final double custoTotal;

  const IngredientCostCard({
    super.key,
    required this.custoBase,
    required this.fatorCorrecao,
    required this.custoTotal,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey("cost_${custoTotal.toStringAsFixed(2)}"),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4), // Verde claro
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFBBF7D0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.monetization_on_rounded, color: Color(0xFF16A34A), size: 18),
                SizedBox(width: 8),
                Text(
                  "Resumo do Custo",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF166534),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildRow("Custo Base:", custoBase),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("FC Aplicado:", style: TextStyle(color: Color(0xFF166534), fontSize: 13)),
                Text("${fatorCorrecao.toStringAsFixed(2)}x", style: const TextStyle(color: Color(0xFF166534), fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(color: Color(0xFFBBF7D0)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Custo Final:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF14532D),
                    fontSize: 15,
                  ),
                ),
                Text(
                  "R\$ ${custoTotal.toStringAsFixed(2).replaceAll('.', ',')}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF15803D),
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF166534), fontSize: 13)),
        Text(
          "R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}",
          style: const TextStyle(color: Color(0xFF166534), fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
