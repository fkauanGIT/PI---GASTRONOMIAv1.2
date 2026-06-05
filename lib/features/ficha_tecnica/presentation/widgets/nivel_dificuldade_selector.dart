import 'package:flutter/material.dart';

class NivelDificuldadeSelector extends StatelessWidget {
  final String nivelSelecionado;
  final ValueChanged<String> onChanged;

  const NivelDificuldadeSelector({
    super.key,
    required this.nivelSelecionado,
    required this.onChanged,
  });

  static const _descricoes = {
    'Fácil': 'Receita simples, poucos ingredientes e etapas rápidas.',
    'Médio': 'Requer atenção ao preparo e algumas técnicas básicas.',
    'Difícil': 'Receita com várias etapas e maior complexidade técnica.',
  };

  @override
  Widget build(BuildContext context) {
    final niveis = [
      {'label': 'Fácil', 'color': Colors.green.shade600, 'icon': Icons.sentiment_satisfied_rounded},
      {'label': 'Médio', 'color': Colors.orange.shade600, 'icon': Icons.sentiment_neutral_rounded},
      {'label': 'Difícil', 'color': Colors.red.shade600, 'icon': Icons.local_fire_department_rounded},
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              "Nível de dificuldade",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF4B5563)),
            ),
          ),
          Row(
            children: niveis.map((nivelItem) {
              final nivel = nivelItem['label'] as String;
              final color = nivelItem['color'] as Color;
              final icon = nivelItem['icon'] as IconData;
              final selected = nivelSelecionado == nivel;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(nivel),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: EdgeInsets.symmetric(vertical: selected ? 14 : 12),
                    decoration: BoxDecoration(
                      color: selected ? color : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selected ? color : const Color(0xFFE5E7EB),
                        width: 1.5,
                      ),
                      boxShadow: selected
                          ? [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))]
                          : [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            icon,
                            key: ValueKey('${nivel}_$selected'),
                            size: 20,
                            color: selected ? Colors.white : color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                            fontSize: selected ? 14 : 13,
                            color: selected ? Colors.white : const Color(0xFF6B7280),
                          ),
                          child: Text(nivel),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          // Descrição animada do nível selecionado
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero).animate(anim),
                child: child,
              ),
            ),
            child: nivelSelecionado.isNotEmpty
                ? Padding(
                    key: ValueKey(nivelSelecionado),
                    padding: const EdgeInsets.only(top: 10, left: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline_rounded, size: 13, color: Color(0xFF6B7280)),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            _descricoes[nivelSelecionado] ?? '',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280), fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    key: const ValueKey('empty'),
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: const Text(
                      "Selecione um nível para continuar",
                      style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}