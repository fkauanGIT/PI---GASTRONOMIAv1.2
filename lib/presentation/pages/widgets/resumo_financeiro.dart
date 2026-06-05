import 'package:flutter/material.dart';
import 'package:projeto_gastronomia_ficha/config/theme/app_colors.dart';

Widget resumoFinanceiro({
  required double custoTotal,
  required double custoPorPorcao,
  required double precoSugerido,
  required double foodCost,
  required int totalIngredientes,
  required String nivelSelecionado,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 24),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      gradient: LinearGradient(
        colors: [
          AppColors.primary.withValues(alpha: 0.08),
          Colors.white,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(
        color: AppColors.primary.withValues(alpha: 0.12),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Resumo Financeiro",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _financeCard(
                "Custo Total",
                "R\$ ${custoTotal.toStringAsFixed(2)}",
                Icons.attach_money,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _financeCard(
                "Por Porção",
                "R\$ ${custoPorPorcao.toStringAsFixed(2)}",
                Icons.pie_chart,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _financeCard(
                "Preço Sugerido",
                "R\$ ${precoSugerido.toStringAsFixed(2)}",
                Icons.sell_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _financeCard(
                "Food Cost",
                "${foodCost.toStringAsFixed(1)}%",
                Icons.bar_chart,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _financeCard(
                "Ingredientes",
                "$totalIngredientes",
                Icons.inventory_2_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _financeCard(
                "Nível",
                nivelSelecionado.isEmpty ? "--" : nivelSelecionado,
                Icons.local_fire_department_outlined,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _financeCard(
  String label,
  String value,
  IconData icon,
) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      border: Border.all(
        color: AppColors.primary.withValues(alpha: 0.1),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: AppColors.primary,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}
