import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/ficha_tecnica_controller.dart';
import '../widgets/criar_ficha_appbar.dart';
import '../widgets/criar_ficha_layout.dart';
import '../widgets/cards/ficha_form_card.dart';

class CriarFichaTecnica extends StatelessWidget {
  final VoidCallback? onReceitaSalva;

  const CriarFichaTecnica({super.key, this.onReceitaSalva});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FichaTecnicaController(),
      builder: (context, child) {
        return CriarFichaLayout(
          appBar: const CriarFichaAppBar(),
          child: FichaFormCard(onSuccess: onReceitaSalva),
        );
      },
    );
  }
}
