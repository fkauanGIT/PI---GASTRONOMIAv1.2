import 'package:flutter/material.dart';
import 'package:projeto_gastronomia_ficha/presentation/pages/configuracoes/configuracoesPage.dart';
import 'package:projeto_gastronomia_ficha/features/ficha_tecnica/presentation/pages/criar_ficha_tecnica_page.dart';
import 'package:projeto_gastronomia_ficha/presentation/pages/inicial/favoritos_page.dart';
import 'package:projeto_gastronomia_ficha/presentation/pages/perfil/perfilPage.dart';
import '../widgets/custom_nav_bar.dart';
import '../inicial/inicialPage.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  late final List<Widget> _pages = [
    const InicialPage(),
    FavoritosPage(onBack: () => _onTabTap(0)),
    CriarFichaTecnica(onReceitaSalva: () => _onTabTap(0)),
    PerfilPage(onBack: () => _onTabTap(0)),
    const ConfiguracoesPage(),
  ];

  void _onTabTap(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTap,
      ),
    );
  }
}
