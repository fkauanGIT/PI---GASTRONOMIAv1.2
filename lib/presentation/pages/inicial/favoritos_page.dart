import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/favoritos_service.dart';
import '../../../data/receitas_data.dart';
import '../widgets/receita_card.dart';
import '../widgets/custom_nav_bar.dart';
import '../widgets/receita_filtro_modal.dart';
import 'detalheFicha.dart';

class FavoritosPage extends StatefulWidget {
  final VoidCallback? onBack;
  const FavoritosPage({super.key, this.onBack});

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  final _searchController = TextEditingController();
  String _search = '';
  String _categoriaSelecionada = 'Todos';

  static const _categorias = [
    'Todos', 'Fitness', 'Jantar', 'Forno', 'Cozinha', 'Almoço', 'Sobremesa', 'Bebida',
  ];

  void _abrirFiltro(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReceitaFiltroModal(
        categorias: _categorias,
        categoriaSelecionada: _categoriaSelecionada,
        onCategoriaSelecionada: (cat) => setState(() => _categoriaSelecionada = cat),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        bottom: false,
        child: Consumer<FavoritosService>(
          builder: (context, favoritos, _) {
            final receitasFavoritas = ReceitasData.receitas.where((r) {
              final titulo = (r['titulo'] ?? '').toString();
              if (titulo.isEmpty) return false;
              final isFavorito = favoritos.isFavorito(titulo);
              final combinaBusca = titulo.toLowerCase().contains(_search.toLowerCase());
              final subtitulo = (r['subtitulo'] ?? '').toString();
              final combinaCategoria = _categoriaSelecionada == 'Todos' ||
                  subtitulo.toLowerCase().contains(_categoriaSelecionada.toLowerCase());
              return isFavorito && combinaBusca && combinaCategoria;
            }).toList();

            final filtroAtivo = _categoriaSelecionada != 'Todos';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _FavoritosHeaderTitle(cs: cs),
                          _FavoritosCountBadge(count: receitasFavoritas.length, cs: cs),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _BuscaFiltroBar(
                        controller: _searchController,
                        onChanged: (v) => setState(() => _search = v),
                        filtroAtivo: filtroAtivo,
                        onFiltroTap: () => _abrirFiltro(context),
                        cs: cs,
                      ),
                    ],
                  ),
                ),

                if (filtroAtivo)
                  _CategoriaAtivaChip(
                    categoria: _categoriaSelecionada,
                    onRemover: () => setState(() => _categoriaSelecionada = 'Todos'),
                    cs: cs,
                  ),

                Expanded(
                  child: receitasFavoritas.isEmpty
                      ? _EmptyFavoritos(cs: cs)
                      : ListView.builder(
                          padding: EdgeInsets.only(
                            top: 8,
                            bottom: CustomBottomNavBar.navBarHeight + 16,
                          ),
                          itemCount: receitasFavoritas.length,
                          itemBuilder: (context, index) {
                            final receita = receitasFavoritas[index];
                            return ReceitaCard(
                              titulo: (receita['titulo'] ?? '').toString(),
                              subtitulo: (receita['subtitulo'] ?? '').toString(),
                              imagem: (receita['imagem'] ?? '').toString(),
                              rating: ((receita['rating'] ?? 5) as num).toInt(),
                              isGridMode: false,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => VisualizarFichaTecnica(receita: receita),
                                ),
                              ),
                              onFavorite: () => favoritos.toggleFavorito(
                                (receita['titulo'] ?? '').toString(),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FavoritosHeaderTitle extends StatelessWidget {
  final ColorScheme cs;
  const _FavoritosHeaderTitle({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Seus', style: TextStyle(fontSize: 16, color: cs.onSurface.withValues(alpha: 0.5))),
        const SizedBox(height: 2),
        Text('Favoritos',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: cs.primary)),
      ],
    );
  }
}

class _FavoritosCountBadge extends StatelessWidget {
  final int count;
  final ColorScheme cs;
  const _FavoritosCountBadge({required this.count, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text('$count',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}

class _BuscaFiltroBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool filtroAtivo;
  final VoidCallback onFiltroTap;
  final ColorScheme cs;

  const _BuscaFiltroBar({
    required this.controller,
    required this.onChanged,
    required this.filtroAtivo,
    required this.onFiltroTap,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 58,
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: TextStyle(color: cs.onSurface),
              decoration: InputDecoration(
                hintText: 'Buscar favorito...',
                hintStyle: TextStyle(color: cs.onSurface.withValues(alpha: 0.4)),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search_rounded, color: cs.primary),
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        _FiltroButton(ativo: filtroAtivo, onTap: onFiltroTap, cs: cs),
      ],
    );
  }
}

class _FiltroButton extends StatelessWidget {
  final bool ativo;
  final VoidCallback onTap;
  final ColorScheme cs;

  const _FiltroButton({required this.ativo, required this.onTap, required this.cs});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              color: ativo ? cs.primary.withValues(alpha: 0.8) : cs.primary,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: cs.primary.withValues(alpha: 0.18),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.tune_rounded, color: Colors.white),
          ),
          if (ativo)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: cs.secondary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoriaAtivaChip extends StatelessWidget {
  final String categoria;
  final VoidCallback onRemover;
  final ColorScheme cs;

  const _CategoriaAtivaChip({required this.categoria, required this.onRemover, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: cs.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.filter_list_rounded, size: 15, color: cs.primary),
            const SizedBox(width: 6),
            Text(categoria,
                style: TextStyle(color: cs.primary, fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onRemover,
              child: Icon(Icons.close_rounded, size: 15, color: cs.primary),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyFavoritos extends StatelessWidget {
  final ColorScheme cs;
  const _EmptyFavoritos({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Icon(Icons.favorite_border_rounded, size: 60, color: cs.primary),
            ),
            const SizedBox(height: 24),
            Text('Nenhum favorito ainda',
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: cs.onSurface)),
            const SizedBox(height: 10),
            Text(
              'Salve receitas tocando no coração para encontrá-las rapidamente depois.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, height: 1.5, color: cs.onSurface.withValues(alpha: 0.6)),
            ),
          ],
        ),
      ),
    );
  }
}
