import 'dart:async';
import 'package:flutter/material.dart';

class HeroCarousel extends StatefulWidget {
  final List<Map<String, dynamic>> receitas;
  final void Function(Map<String, dynamic>) onTap;

  const HeroCarousel({
    super.key,
    required this.receitas,
    required this.onTap,
  });

  @override
  State<HeroCarousel> createState() =>
      _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  late final PageController _controller;
  late final List<Map<String, dynamic>> _destaques;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Pega até 5 receitas para o carrossel
    _destaques = widget.receitas.take(5).toList();

    _controller = PageController(
      viewportFraction: 0.88,
      initialPage: 0,
    );

    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_currentPage + 1) % _destaques.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_destaques.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _controller,
            itemCount: _destaques.length,
            onPageChanged: (i) =>
                setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              final receita = _destaques[index];
              return _HeroCard(
                receita: receita,
                onTap: () => widget.onTap(receita),
              );
            },
          ),
        ),

        const SizedBox(height: 14),

        // ── Indicadores animados ────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _destaques.length,
            (i) => _DotIndicator(
              isActive: i == _currentPage,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Card individual do carrossel ─────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  final Map<String, dynamic> receita;
  final VoidCallback onTap;

  const _HeroCard({
    required this.receita,
    required this.onTap,
  });

  String _extrairCategoria(String subtitulo) =>
      subtitulo.split('•').first.trim();

  String _extrairTempo(String subtitulo) {
    final partes = subtitulo.split('•');
    return partes.length > 1
        ? partes.last.replaceAll('Tempo', '').trim()
        : '';
  }

  @override
  Widget build(BuildContext context) {
    final titulo = (receita['titulo'] ?? '').toString();
    final subtitulo = (receita['subtitulo'] ?? '').toString();
    final imagem = (receita['imagem'] ?? '').toString();
    final rating =
        ((receita['rating'] ?? 5) as num).toDouble();
    final categoria = _extrairCategoria(subtitulo);
    final tempo = _extrairTempo(subtitulo);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [

              // ── Imagem de fundo ─────────────────
              Image.asset(
                imagem,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFEAF2FB),
                  child: const Icon(
                    Icons.restaurant_rounded,
                    size: 64,
                    color: Color(0xFF004C94),
                  ),
                ),
              ),

              // ── Gradiente sobre a imagem ────────
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.25),
                      Colors.black.withValues(alpha: 0.72),
                    ],
                    stops: const [0.35, 0.6, 1.0],
                  ),
                ),
              ),

              // ── Conteúdo sobre o gradiente ──────
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    // Badge categoria (topo)
                    _CategoriaBadge(categoria: categoria),

                    const Spacer(),

                    // Título
                    Text(
                      titulo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                        shadows: [
                          Shadow(
                            color: Colors.black38,
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Tempo + Rating
                    Row(
                      children: [
                        if (tempo.isNotEmpty) ...[
                          const Icon(
                            Icons.access_time_rounded,
                            color: Colors.white70,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            tempo,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFFBE13),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Badge de categoria ───────────────────────────────────────────────────────

class _CategoriaBadge extends StatelessWidget {
  final String categoria;
  const _CategoriaBadge({required this.categoria});

  Color _cor() {
    switch (categoria.toLowerCase()) {
      case 'fitness':
        return Colors.green;
      case 'jantar':
        return Colors.purple;
      case 'almoço':
        return Colors.blue;
      case 'forno':
        return Colors.orange;
      case 'cozinha':
        return Colors.deepPurple;
      case 'sobremesa':
        return Colors.pink;
      case 'bebida':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cor = _cor();
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
          ),
        ],
      ),
      child: Text(
        categoria,
        style: TextStyle(
          color: cor,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

// ── Dot indicator animado ────────────────────────────────────────────────────

class _DotIndicator extends StatelessWidget {
  final bool isActive;
  const _DotIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF004C94)
            : const Color(0xFF004C94).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}