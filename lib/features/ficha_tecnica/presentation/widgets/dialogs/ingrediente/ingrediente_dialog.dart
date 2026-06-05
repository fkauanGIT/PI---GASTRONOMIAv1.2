import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../domain/entities/ingrediente_entity.dart';
import '../../../controllers/ingrediente_controller.dart';
import '../../inputs/ficha_input.dart';
import 'ingredient_autocomplete.dart';
import 'ingredient_chip_selector.dart';
import 'ingredient_cost_card.dart';
import 'ingredient_preview.dart';

class IngredienteDialog extends StatefulWidget {
  final Function(IngredienteEntity) onAdd;

  const IngredienteDialog({super.key, required this.onAdd});

  @override
  State<IngredienteDialog> createState() => _IngredienteDialogState();
}

class _IngredienteDialogState extends State<IngredienteDialog> {
  final _controller = IngredienteController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Força a atualização da tela quando o controller muda para reatividade em tempo real
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleAdd() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_controller.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos obrigatórios corretamente")),
      );
      return;
    }

    widget.onAdd(_controller.buildEntity());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 500;
          return Container(
            padding: EdgeInsets.fromLTRB(
              24,
              24,
              24,
              MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            constraints: BoxConstraints(
              maxWidth: isMobile ? double.infinity : 440,
            ),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.restaurant_menu_rounded, color: Color(0xFFF59E0B), size: 24),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "Adicionar Ingrediente",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, color: Color(0xFF9CA3AF)),
                          onPressed: () => Navigator.pop(context),
                          splashRadius: 24,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Campo de Nome (Autocomplete)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: IngredientAutocomplete(
                        controller: _controller.nomeController,
                      ),
                    ),

                    // Preço Unitário
                    FichaInput(
                      label: "Preço Unitário (R\$)",
                      isRequired: true,
                      controller: _controller.precoController,
                      isNumber: true,
                      inputFormatters: [CurrencyInputFormatter()],
                      validator: (value) {
                        if (value == null || value.isEmpty || _controller.precoParsed <= 0) {
                          return 'Digite um preço para calcular o custo';
                        }
                        return null;
                      },
                    ),

                    // Quantidade e Unidade (Chips)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: FichaInput(
                            label: "Quantidade",
                            isRequired: true,
                            controller: _controller.qtdController,
                            isNumber: true,
                            inputFormatters: [QuantidadeFormatter()],
                            validator: (value) {
                              if (value == null || value.isEmpty || _controller.quantidadeParsed <= 0) {
                                return 'Quantidade necessária';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: IngredientChipSelector(
                            selectedUnit: _controller.unidadeSelecionada,
                            onUnitSelected: _controller.setUnidade,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Perda no preparo
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: FichaInput(
                            label: "Perda no preparo (%)",
                            controller: _controller.perdaController,
                            isNumber: true,
                            hint: "Ex.: 20% (casca, gordura, cozimento)",
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2),
                            ],
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final p = double.tryParse(value.replaceAll(',', '.'));
                                if (p != null && (p < 0 || p >= 100)) {
                                  return 'Deve ser entre 0 e 99';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12, top: 12),
                          child: Tooltip(
                            message: "Ex.: cascas, limpeza ou ossos.\nAfeta o rendimento final e o custo real.\nCalculado automaticamente como Fator de Correção (FC).",
                            triggerMode: TooltipTriggerMode.tap,
                            child: Icon(Icons.help_outline, color: Colors.blueGrey.shade300),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Pré-visualização Dinâmica
                    IngredientPreview(
                      nome: _controller.nomeController.text,
                      quantidade: _controller.quantidadeParsed,
                      unidade: _controller.unidadeSelecionada,
                      custoTotal: _controller.custoTotal,
                    ),

                    const SizedBox(height: 16),

                    // Card de Custo Financeiro Dinâmico
                    if (_controller.custoBase > 0) ...[
                      IngredientCostCard(
                        custoBase: _controller.custoBase,
                        fatorCorrecao: _controller.fatorCorrecao,
                        custoTotal: _controller.custoTotal,
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Botões de Ação
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFD1D5DB)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                foregroundColor: const Color(0xFF4B5563),
                              ),
                              child: const Text(
                                "Cancelar",
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: _controller.isValid ? _handleAdd : null,
                              icon: const Icon(Icons.check_rounded, size: 20),
                              label: Text(
                                isMobile ? "Adicionar" : "Adicionar Ingrediente",
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                                overflow: TextOverflow.ellipsis,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF007BFF),
                                disabledBackgroundColor: const Color(0xFF007BFF).withValues(alpha: 0.4),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }
    String numbers = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (numbers.isEmpty) return newValue.copyWith(text: '');
    double value = double.parse(numbers) / 100;
    String newText = value.toStringAsFixed(2).replaceAll('.', ',');
    
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

// Nome do ingrediente: letras, números, espaço, hífen — sem caracteres especiais
class NomeIngredienteFormatter extends TextInputFormatter {
  static const int _maxLength = 50;
  static final _allowed = RegExp(r"[\p{L}\p{N} '\-]", unicode: true);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > _maxLength) return oldValue;
    final filtered = newValue.text.split('').where((ch) => _allowed.hasMatch(ch)).join();
    final noDouble = filtered.replaceAll(RegExp(r' {2,}'), ' ');
    final result = noDouble.startsWith(' ') ? noDouble.trimLeft() : noDouble;
    if (result == newValue.text) return newValue;
    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}

// Quantidade: aceita dígitos e no máximo uma vírgula ou ponto decimal
class QuantidadeFormatter extends TextInputFormatter {
  static const int _maxLength = 8;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.length > _maxLength) return oldValue;
    // Permite apenas dígitos, vírgula ou ponto
    if (!RegExp(r'^[\d]*[,.]?[\d]*$').hasMatch(text)) return oldValue;
    // Impede múltiplos separadores
    final separatorCount = text.split('').where((c) => c == ',' || c == '.').length;
    if (separatorCount > 1) return oldValue;
    return newValue;
  }
}
