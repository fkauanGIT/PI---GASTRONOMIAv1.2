import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/favoritos_service.dart';
import '../../../services/fichas_service.dart';
import '../../../data/receitas_data.dart';
import '../widgets/receita_card.dart';
import '../widgets/custom_nav_bar.dart';
import '../widgets/receita_filtro_modal.dart';
import '../widgets/saudacao_header.dart';
import '../widgets/hero_carrossel.dart';
import '../widgets/categoria_chips.dart';
import '../widgets/em_alta_row.dart';
import 'detalheFicha.dart';

class InicialPage extends StatefulWidget {
  const InicialPage({super.key});

  @override
  State<InicialPage> createState() => _InicialPageState();
}

class _InicialPageState extends State<InicialPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _categoriaSelecionada = 'Todos';

  final List<String> categorias = [
    'Todos', 'Fitness', 'Jantar', 'Forno', 'Cozinha', 'Almoço', 'Sobremesa', 'Bebida',
  ];

  final List<String> _emAlta = [
    'Arroz Integral', 'Strogonoff', 'Pão Caseiro', 'Bowl Fitness', 'Risoto',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _isFiltrando =>
      _searchQuery.isNotEmpty || _categoriaSelecionada != 'Todos';

  List<Map<String, dynamic>> _receitasFiltradas(
      List<Map<String, dynamic>> fichasUsuario) {
    final todas = [...fichasUsuario, ...ReceitasData.receitas];
    return todas.where((r) {
      final titulo = (r['titulo'] as String? ?? '').toLowerCase();
      final subtitulo = (r['subtitulo'] as String? ?? '').toLowerCase();
      final combinaBusca = titulo.contains(_searchQuery.toLowerCase());
      final combinaCategoria = _categoriaSelecionada == 'Todos' ||
          subtitulo.contains(_categoriaSelecionada.toLowerCase());
      return combinaBusca && combinaCategoria;
    }).toList();
  }

  void _navegarParaReceita(Map<String, dynamic> receita) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => VisualizarFichaTecnica(receita: receita),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.04),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  void _abrirFiltros() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (modalContext) => ReceitaFiltroModal(
        categorias: categorias,
        categoriaSelecionada: _categoriaSelecionada,
        onCategoriaSelecionada: (categoria) {
          setState(() => _categoriaSelecionada = categoria);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SaudacaoHeader(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              onFilterTap: _abrirFiltros,
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Consumer2<FavoritosService, FichasService>(
                builder: (context, favoritos, fichasService, _) {
                  final receitas = _receitasFiltradas(fichasService.fichas);

                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      if (!_isFiltrando) ...[
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: HeroCarousel(
                              receitas: ReceitasData.receitas,
                              onTap: _navegarParaReceita,
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 14),
                            child: CategoriaChips(
                              categorias: categorias,
                              categoriaSelecionada: _categoriaSelecionada,
                              onSelecionada: (cat) =>
                                  setState(() => _categoriaSelecionada = cat),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: EmAltaRow(itens: _emAlta),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
                            child: Text(
                              'Populares hoje',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: cs.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ],

                      if (_isFiltrando)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: CategoriaChips(
                              categorias: categorias,
                              categoriaSelecionada: _categoriaSelecionada,
                              onSelecionada: (cat) =>
                                  setState(() => _categoriaSelecionada = cat),
                            ),
                          ),
                        ),

                      if (receitas.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: _EmptyState(mensagem: 'Nenhuma receita encontrada', cs: cs),
                        )
                      else
                        SliverPadding(
                          padding: EdgeInsets.only(
                            top: 8,
                            bottom: CustomBottomNavBar.navBarHeight + 16,
                          ),
                          sliver: SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final receita = receitas[index];
                                return _AnimatedCard(
                                  index: index,
                                  child: ReceitaCard(
                                    titulo: receita['titulo'] as String,
                                    subtitulo: receita['subtitulo'] as String,
                                    imagem: receita['imagem'] as String,
                                    rating: (receita['rating'] as int?) ?? 4,
                                    isGridMode: true,
                                    onTap: () => _navegarParaReceita(receita),
                                    onFavorite: () => favoritos.toggleFavorito(
                                      receita['titulo'] as String,
                                    ),
                                  ),
                                );
                              },
                              childCount: receitas.length,
                            ),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.72,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedCard extends StatefulWidget {
  final int index;
  final Widget child;

  const _AnimatedCard({required this.index, required this.child});

  @override
  State<_AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<_AnimatedCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    final delay = Duration(milliseconds: (widget.index % 6) * 60);
    Future.delayed(delay, () {
      if (mounted) _ctrl.forward();
    });

    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String mensagem;
  final ColorScheme cs;
  const _EmptyState({required this.mensagem, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: cs.onSurface.withValues(alpha: 0.2)),
          const SizedBox(height: 12),
          Text(
            mensagem,
            style: TextStyle(color: cs.onSurface.withValues(alpha: 0.4), fontSize: 15),
          ),
        ],
      ),
    );
  }
}
