import 'package:flutter/material.dart';
import 'ingrediente_dialog.dart' show NomeIngredienteFormatter;

class IngredientAutocomplete extends StatelessWidget {
  final TextEditingController controller;

  const IngredientAutocomplete({
    super.key,
    required this.controller,
  });

  static const List<String> _kOptions = <String>[
    'Açúcar',
    'Alho',
    'Arroz',
    'Azeite',
    'Batata',
    'Cebola',
    'Farinha de Trigo',
    'Feijão',
    'Leite',
    'Manteiga',
    'Óleo',
    'Ovo',
    'Sal',
    'Tomate',
  ];

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return _kOptions.where((String option) {
          return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        controller.text = selection;
      },
      fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
        // Sincroniza o controller externo com o interno do Autocomplete
        // Necessário apenas se o externo for preenchido por outros meios, mas aqui 
        // usaremos um listener simples
        if (controller.text != fieldTextEditingController.text && !fieldFocusNode.hasFocus) {
             fieldTextEditingController.text = controller.text;
        }
        
        fieldTextEditingController.addListener(() {
          if (controller.text != fieldTextEditingController.text) {
             controller.text = fieldTextEditingController.text;
          }
        });

        return TextFormField(
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
          decoration: InputDecoration(
            label: RichText(
              text: const TextSpan(
                text: 'Nome do ingrediente',
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
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Digite ou selecione o nome do ingrediente';
            }
            return null;
          },
          inputFormatters: [NomeIngredienteFormatter()],
          autovalidateMode: AutovalidateMode.onUserInteraction,
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200, maxWidth: 300),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return InkWell(
                    onTap: () {
                      onSelected(option);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(option),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
