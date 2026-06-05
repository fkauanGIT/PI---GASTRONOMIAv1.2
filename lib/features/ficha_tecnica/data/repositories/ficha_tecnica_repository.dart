import 'package:projeto_gastronomia_ficha/services/fichas_service.dart';
import '../dto/criar_ficha_tecnica_dto.dart';

class FichaTecnicaRepository {
  Future<void> criarFicha(CriarFichaTecnicaDTO dto) async {
    await Future.delayed(const Duration(milliseconds: 800));
    await FichasService.instance.addFicha({
      'titulo': dto.nome,
      'subtitulo':
          '${dto.categoria.isNotEmpty ? dto.categoria : "Geral"} • Tempo ${dto.tempoPreparoMin} min',
      'imagem': 'assets/imagens/arroz_branco.jpg',
      'descricao': dto.modoPreparo.isNotEmpty
          ? dto.modoPreparo
          : 'Receita criada pelo usuário.',
      'rating': 5,
      'custo_total': dto.custoTotal,
      'custo_por_porcao': dto.custoPorPorcao,
      'preco_sugerido': dto.precoSugerido,
      'food_cost': dto.foodCost,
      'nivel_dificuldade': dto.nivelDificuldade,
      'porcoes': dto.porcoes,
    });
  }
}
