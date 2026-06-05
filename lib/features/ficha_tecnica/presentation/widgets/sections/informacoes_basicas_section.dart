import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../domain/constants/ficha_categoria_constants.dart';
import '../../../domain/validators/ficha_tecnica_validator.dart';
import '../../controllers/ficha_tecnica_controller.dart';

import '../inputs/ficha_input.dart';
import '../nivel_dificuldade_selector.dart';

class InformacoesBasicasSection extends StatelessWidget {
  const InformacoesBasicasSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FichaTecnicaController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FichaInput(
          label: "Nome da receita",
          isRequired: true,
          controller: controller.nomeController,
          inputFormatters: [NomeReceitaFormatter()],
          validator: (v) => (v == null || v.trim().isEmpty)
              ? 'Digite o nome da receita'
              : FichaTecnicaValidator.validarNome(v),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            menuMaxHeight: 300,
            initialValue: controller.categoriaSelecionada,
            validator: (v) => (v == null || v.isEmpty)
                ? 'Selecione uma categoria'
                : FichaTecnicaValidator.validarCategoria(v),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              label: RichText(
                text: const TextSpan(
                  text: 'Categoria',
                  style: TextStyle(color: Color(0xFF6B7280), fontSize: 15),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF007BFF), width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.redAccent, width: 2),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
            items: FichaCategoriaConstants.categorias.map((categoria) {
              return DropdownMenuItem(value: categoria.value, child: Text(categoria.label));
            }).toList(),
            onChanged: controller.setCategoria,
          ),
        ),
        // Tempo e Porções com controles inteligentes
        Row(
          children: [
            Expanded(child: _TempoField(controller: controller.tempoController)),
            const SizedBox(width: 16),
            Expanded(child: _PorcoesField(controller: controller.porcoesController)),
          ],
        ),
        NivelDificuldadeSelector(
          nivelSelecionado: controller.nivelSelecionado,
          onChanged: controller.setNivel,
        ),
        _MargemLucroField(controller: controller.lucroController),
      ],
    );
  }
}

// ─────────────────────────────────────
// Campo de Tempo com sugestão inteligente
// ─────────────────────────────────────
class _TempoField extends StatelessWidget {
  final TextEditingController controller;
  const _TempoField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: FichaTecnicaValidator.validarTempo,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: const TextStyle(fontSize: 15, color: Color(0xFF1F2937), fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: 'Tempo (min)',
          labelStyle: const TextStyle(color: Color(0xFF6B7280), fontSize: 15),
          hintText: 'Ex: 30',
          hintStyle: const TextStyle(color: Color(0xFFD1D5DB), fontSize: 14),
          prefixIcon: const Icon(Icons.access_time_rounded, color: Color(0xFF007BFF), size: 20),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF007BFF), width: 2)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.redAccent, width: 2)),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────
// Campo de Porções com +/- visual
// ─────────────────────────────────────
class _PorcoesField extends StatelessWidget {
  final TextEditingController controller;
  const _PorcoesField({required this.controller});

  void _increment() {
    final val = int.tryParse(controller.text) ?? 0;
    controller.text = (val + 1).toString();
  }

  void _decrement() {
    final val = int.tryParse(controller.text) ?? 0;
    if (val > 1) controller.text = (val - 1).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(2),
        ],
        validator: FichaTecnicaValidator.validarPorcoes,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15, color: Color(0xFF1F2937), fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          labelText: 'Porções',
          labelStyle: const TextStyle(color: Color(0xFF6B7280), fontSize: 15),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          prefixIcon: GestureDetector(
            onTap: _decrement,
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.remove_rounded, size: 16, color: Color(0xFF6B7280)),
            ),
          ),
          suffixIcon: GestureDetector(
            onTap: _increment,
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.add_rounded, size: 16, color: Color(0xFF007BFF)),
            ),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF007BFF), width: 2)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.redAccent, width: 2)),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────
// Margem de lucro com feedback dinâmico
// ─────────────────────────────────────
class _MargemLucroField extends StatelessWidget {
  final TextEditingController controller;
  const _MargemLucroField({required this.controller});

  String _getDescricao(String text) {
    final val = double.tryParse(text.replaceAll(',', '.')) ?? 0;
    if (val <= 0) return '';
    if (val < 20) return 'Margem baixa';
    if (val < 40) return 'Lucro moderado';
    if (val < 70) return 'Boa margem';
    return 'Margem alta';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final descricao = _getDescricao(value.text);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: descricao.isNotEmpty ? 6 : 20),
              child: TextFormField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: FichaTecnicaValidator.validarLucro,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                style: const TextStyle(fontSize: 15, color: Color(0xFF1F2937), fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  label: RichText(
                    text: const TextSpan(
                      text: 'Margem de lucro (%)',
                      style: TextStyle(color: Color(0xFF6B7280), fontSize: 15),
                      children: [
                        TextSpan(text: ' *', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  hintText: 'Ex: 35',
                  hintStyle: const TextStyle(color: Color(0xFFD1D5DB), fontSize: 14),
                  suffixText: '%',
                  suffixStyle: const TextStyle(color: Color(0xFF6B7280), fontWeight: FontWeight.w600),
                  prefixIcon: const Icon(Icons.trending_up_rounded, color: Color(0xFF007BFF), size: 20),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF007BFF), width: 2)),
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.redAccent, width: 2)),
                ),
              ),
            ),
            if (descricao.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 4),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Row(
                    key: ValueKey(descricao),
                    children: [
                      const Icon(Icons.info_outline_rounded, size: 13, color: Color(0xFF007BFF)),
                      const SizedBox(width: 4),
                      Text(
                        descricao,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF007BFF), fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────
// Formatter para o Nome da Receita
// ─────────────────────────────────────
class NomeReceitaFormatter extends TextInputFormatter {
  static const int _maxLength = 60;
  // Permite letras (incluindo acentuadas), dígitos, espaço simples, hífen e apóstrofo
  static final _allowedPattern = RegExp(r"[\p{L}\p{N} '\-]", unicode: true);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Bloqueia se exceder o limite
    if (newValue.text.length > _maxLength) return oldValue;

    // Filtra caracteres não permitidos
    final filtered =
        newValue.text.split('').where((ch) => _allowedPattern.hasMatch(ch)).join();

    // Impede espaços consecutivos
    final noDoubleSpace = filtered.replaceAll(RegExp(r' {2,}'), ' ');

    // Impede iniciar com espaço
    final result =
        noDoubleSpace.startsWith(' ') ? noDoubleSpace.trimLeft() : noDoubleSpace;

    if (result == newValue.text) return newValue;

    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}