import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../config/theme/app_colors.dart';
import '../../controllers/ficha_tecnica_controller.dart';

import '../receita_foto_picker.dart';
import 'resumo_financeiro.dart';
import '../ingredientes_section.dart';
import '../section_title.dart';
import '../sections/informacoes_basicas_section.dart';
import '../sections/modo_preparo_section.dart';

class FichaFormCard extends StatefulWidget {
  final VoidCallback? onSuccess;

  const FichaFormCard({super.key, this.onSuccess});

  @override
  State<FichaFormCard> createState() => _FichaFormCardState();
}

class _FichaFormCardState extends State<FichaFormCard> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _submit() async {
    final controller = context.read<FichaTecnicaController>();
    final recipeName = controller.nomeController.text.trim();

    if (!_formKey.currentState!.validate()) return;

    if (controller.nivelSelecionado.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecione o nível de dificuldade")),
      );
      return;
    }

    if (controller.ingredientes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Adicione ao menos um ingrediente")),
      );
      return;
    }

    try {
      await controller.submit();
      if (!mounted) return;
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => _ReceitaSalvaDialog(recipeName: recipeName),
      );
      if (!mounted) return;
      controller.resetForm();
      widget.onSuccess?.call();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao salvar")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FichaTecnicaController>();
    final isWide = MediaQuery.of(context).size.width > 900;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: isWide ? _buildWideLayout(controller) : _buildMobileLayout(controller),
      ),
    );
  }

  Widget _buildMobileLayout(FichaTecnicaController controller) {
    return Column(
      children: [
        ReceitaFotoPicker(
          imagemReceita: controller.imagemReceita,
          onTap: controller.selecionarImagem,
        ),
        const SizedBox(height: 20),
        const InformacoesBasicasSection(),
        ResumoFinanceiro(
          custoTotal: controller.custoTotal,
          custoPorPorcao: controller.custoPorPorcao,
          precoSugerido: controller.precoSugerido,
          foodCost: controller.foodCost,
          ingredientesCount: controller.ingredientes.length,
          nivelSelecionado: controller.nivelSelecionado,
        ),
        const SectionTitle(title: "Ingredientes"),
        const IngredientesSection(),
        const ModoPreparoSection(),
        const SizedBox(height: 32),
        _buildSubmitButton(controller),
      ],
    );
  }

  Widget _buildWideLayout(FichaTecnicaController controller) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  ReceitaFotoPicker(
                    imagemReceita: controller.imagemReceita,
                    onTap: controller.selecionarImagem,
                  ),
                  const SizedBox(height: 20),
                  const InformacoesBasicasSection(),
                ],
              ),
            ),
            const SizedBox(width: 40),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResumoFinanceiro(
                    custoTotal: controller.custoTotal,
                    custoPorPorcao: controller.custoPorPorcao,
                    precoSugerido: controller.precoSugerido,
                    foodCost: controller.foodCost,
                    ingredientesCount: controller.ingredientes.length,
                    nivelSelecionado: controller.nivelSelecionado,
                  ),
                  const SectionTitle(title: "Ingredientes"),
                  const IngredientesSection(),
                  const ModoPreparoSection(),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        _buildSubmitButton(controller),
      ],
    );
  }

  Widget _buildSubmitButton(FichaTecnicaController controller) {
    final canSave = controller.isPodeSalvar;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: canSave
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                )
              ]
            : [],
      ),
      child: ElevatedButton(
        onPressed: (controller.isLoading || !canSave) ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: const Color(0xFFD1D5DB),
          foregroundColor: Colors.white,
          disabledForegroundColor: const Color(0xFF9CA3AF),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: controller.isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
              )
            : const Text(
                "Salvar Receita",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, letterSpacing: 0.5),
              ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Dialog de sucesso personalizado
// ---------------------------------------------------------------------------

class _ReceitaSalvaDialog extends StatefulWidget {
  final String recipeName;

  const _ReceitaSalvaDialog({required this.recipeName});

  @override
  State<_ReceitaSalvaDialog> createState() => _ReceitaSalvaDialogState();
}

class _ReceitaSalvaDialogState extends State<_ReceitaSalvaDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _iconScale;
  late final Animation<double> _contentFade;
  late final Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _iconScale = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    );

    _contentFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
    );

    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _iconScale,
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF004C94), Color(0xFF6C2998)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF004C94).withValues(alpha: 0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.restaurant_menu_rounded,
                  color: Colors.white,
                  size: 46,
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeTransition(
              opacity: _contentFade,
              child: SlideTransition(
                position: _contentSlide,
                child: Column(
                  children: [
                    const Text(
                      'Receita cadastrada com sucesso!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004C94),
                      ),
                    ),
                    const SizedBox(height: 14),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.6,
                        ),
                        children: [
                          const TextSpan(text: 'Sua receita '),
                          TextSpan(
                            text: '"${widget.recipeName}"',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6C2998),
                            ),
                          ),
                          const TextSpan(
                            text:
                                ' foi registrada na sua ficha técnica gastronômica! '
                                'Agora você pode consultar todos os custos, '
                                'ingredientes e detalhes de preparo a qualquer momento.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF004C94),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Ótimo, obrigado!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
