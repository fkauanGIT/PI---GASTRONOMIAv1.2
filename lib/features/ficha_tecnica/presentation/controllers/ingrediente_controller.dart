import 'package:flutter/material.dart';
import '../../domain/entities/ingrediente_entity.dart';

class IngredienteController extends ChangeNotifier {
  final nomeController = TextEditingController();
  final qtdController = TextEditingController();
  final precoController = TextEditingController();
  final perdaController = TextEditingController(); // Armazena a perda em %

  String unidadeSelecionada = "g";

  IngredienteController() {
    nomeController.addListener(_onChanged);
    qtdController.addListener(_onChanged);
    precoController.addListener(_onChanged);
    perdaController.addListener(_onChanged);
  }

  void _onChanged() {
    notifyListeners();
  }

  void setUnidade(String unidade) {
    unidadeSelecionada = unidade;
    notifyListeners();
  }

  double get quantidadeParsed {
    return double.tryParse(qtdController.text.replaceAll(',', '.')) ?? 0.0;
  }

  double get precoParsed {
    String precoStr = precoController.text.replaceAll(RegExp(r'[^0-9]'), '');
    return precoStr.isNotEmpty ? (double.parse(precoStr) / 100) : 0.0;
  }

  double get perdaParsed {
    return double.tryParse(perdaController.text.replaceAll(',', '.')) ?? 0.0;
  }

  double get fatorCorrecao {
    double perda = perdaParsed;
    if (perda >= 100) return 1.0; // Evita divisão por zero ou negativa
    if (perda <= 0) return 1.0;
    return 100 / (100 - perda);
  }

  double get custoBase {
    return quantidadeParsed * precoParsed;
  }

  double get custoTotal {
    return custoBase * fatorCorrecao;
  }

  bool get isValid {
    return nomeController.text.trim().isNotEmpty &&
        quantidadeParsed > 0 &&
        precoParsed > 0;
  }

  IngredienteEntity buildEntity() {
    return IngredienteEntity(
      nome: nomeController.text.trim(),
      quantidade: quantidadeParsed,
      unidade: unidadeSelecionada,
      precoUnitario: precoParsed,
      fatorCorrecao: fatorCorrecao,
    );
  }

  @override
  void dispose() {
    nomeController.dispose();
    qtdController.dispose();
    precoController.dispose();
    perdaController.dispose();
    super.dispose();
  }
}
