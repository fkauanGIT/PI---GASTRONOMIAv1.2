import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../config/theme/app_colors.dart';
import '../../domain/entities/ingrediente_entity.dart';
import '../controllers/ficha_tecnica_controller.dart';
import 'dialogs/ingrediente/ingrediente_dialog.dart';

class IngredientesSection extends StatefulWidget {
  const IngredientesSection({super.key});

  @override
  State<IngredientesSection> createState() => _IngredientesSectionState();
}

class _IngredientesSectionState extends State<IngredientesSection> {
  final _listKey = GlobalKey<AnimatedListState>();

  void _addIngrediente(BuildContext context) {
    final controller = context.read<FichaTecnicaController>();
    showDialog(
      context: context,
      builder: (_) => IngredienteDialog(
        onAdd: (IngredienteEntity ingrediente) {
          final index = controller.ingredientes.length;
          controller.addIngrediente(ingrediente);
          _listKey.currentState?.insertItem(index, duration: const Duration(milliseconds: 350));
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                    const SizedBox(width: 10),
                    Text(
                      '${ingrediente.nome} adicionado!',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                backgroundColor: const Color(0xFF15803D),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                duration: const Duration(seconds: 2),
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        },
      ),
    );
  }

  void _removeIngrediente(BuildContext context, IngredienteEntity item, int index) {
    final controller = context.read<FichaTecnicaController>();
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildIngredienteItem(item, index, animation),
      duration: const Duration(milliseconds: 300),
    );
    controller.removeIngrediente(item);
  }

  Widget _buildIngredienteItem(IngredienteEntity item, int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: _IngredienteCard(
          item: item,
          onRemove: () => _removeIngrediente(context, item, index),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FichaTecnicaController>();
    final ingredientes = controller.ingredientes;

    return Column(
      children: [
        // Botão Adicionar
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () => _addIngrediente(context),
            icon: const Icon(Icons.add_rounded, size: 22),
            label: const Text(
              "Adicionar Ingrediente",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.3),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Cabeçalho da lista quando há ingredientes
        if (ingredientes.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Text(
                  '${ingredientes.length} ${ingredientes.length == 1 ? "ingrediente" : "ingredientes"}',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280), fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Text(
                  'Total: R\$ ${controller.custoTotal.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

        // Lista animada
        if (ingredientes.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Icon(Icons.restaurant_menu_rounded, size: 36, color: Colors.grey.shade300),
                const SizedBox(height: 8),
                const Text(
                  "Nenhum ingrediente adicionado",
                  style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          )
        else
          AnimatedList(
            key: _listKey,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            initialItemCount: ingredientes.length,
            itemBuilder: (context, index, animation) {
              if (index >= ingredientes.length) return const SizedBox.shrink();
              return _buildIngredienteItem(ingredientes[index], index, animation);
            },
          ),
      ],
    );
  }
}

// ─────────────────────────────────────
// Card de ingrediente individual
// ─────────────────────────────────────
class _IngredienteCard extends StatelessWidget {
  final IngredienteEntity item;
  final VoidCallback onRemove;

  const _IngredienteCard({required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ícone
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.restaurant_menu_rounded, color: Color(0xFF6B7280), size: 18),
          ),
          const SizedBox(width: 12),

          // Nome + detalhes
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nome,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1F2937)),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    _Tag('${_formatQtd(item.quantidade)} ${item.unidade}', const Color(0xFF6B7280)),
                    if (item.fatorCorrecao != 1.0) ...[
                      const SizedBox(width: 6),
                      _Tag('FC ${item.fatorCorrecao.toStringAsFixed(2)}', const Color(0xFF9CA3AF)),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Custo
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'R\$ ${item.custoTotal.toStringAsFixed(2).replaceAll('.', ',')}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 14),
              ),
              Text(
                'R\$ ${item.precoUnitario.toStringAsFixed(2).replaceAll('.', ',')} / un',
                style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
          const SizedBox(width: 10),

          // Botão remover
          Container(
            decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(10)),
            child: IconButton(
              icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.redAccent),
              splashRadius: 18,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              padding: EdgeInsets.zero,
              onPressed: onRemove,
              tooltip: 'Remover',
            ),
          ),
        ],
      ),
    );
  }

  String _formatQtd(double qtd) {
    return qtd == qtd.truncateToDouble()
        ? qtd.toInt().toString()
        : qtd.toStringAsFixed(2).replaceAll('.', ',');
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  const _Tag(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }
}