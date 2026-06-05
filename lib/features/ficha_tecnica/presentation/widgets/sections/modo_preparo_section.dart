import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../section_title.dart';
import '../../controllers/ficha_tecnica_controller.dart';

class ModoPreparoSection extends StatelessWidget {
  const ModoPreparoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<FichaTecnicaController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: "Modo de preparo"),
        _ModoPreparoInput(controller: controller.modoPreparoController),
      ],
    );
  }
}

class _ModoPreparoInput extends StatefulWidget {
  final TextEditingController controller;
  const _ModoPreparoInput({required this.controller});

  @override
  State<_ModoPreparoInput> createState() => _ModoPreparoInputState();
}

class _ModoPreparoInputState extends State<_ModoPreparoInput> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  void _onChanged() => setState(() {});

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final charCount = widget.controller.text.length;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Stack(
        children: [
          TextFormField(
            controller: widget.controller,
            maxLines: null,
            minLines: 5,
            style: const TextStyle(fontSize: 15, color: Color(0xFF1F2937), fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: "Descreva os passos de preparo da receita...",
              hintStyle: const TextStyle(color: Color(0xFFD1D5DB), fontSize: 14),
              alignLabelWithHint: true,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
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
            ),
          ),
          Positioned(
            bottom: 10,
            right: 14,
            child: Text(
              '$charCount caracteres',
              style: TextStyle(
                fontSize: 11,
                color: charCount > 800 ? Colors.orange.shade600 : const Color(0xFF9CA3AF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}