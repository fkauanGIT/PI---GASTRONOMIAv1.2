import 'package:flutter/material.dart';
import 'package:projeto_gastronomia_ficha/presentation/pages/widgets/main_navigation.dart';
import '../../presentation/pages/home/homePage.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/cadastroPage.dart';
import '../../presentation/pages/inicial/inicialPage.dart';
import '../../presentation/pages/inicial/favoritos_page.dart';
import '../../features/ficha_tecnica/presentation/pages/criar_ficha_tecnica_page.dart';
import '../../presentation/pages/perfil/perfilPage.dart';
import '../../presentation/pages/configuracoes/configuracoesPage.dart';
import '../../presentation/pages/auth/forgotPasswordPage.dart';
import '../../presentation/pages/auth/forgotPasswordSucess.dart';

class AppRoutes {
  static const String main = '/main';
  static const String home = '/';
  static const String login = '/login';
  static const String cadastro = '/cadastro';
  static const String inicial = '/inicial';
  static const String favoritos = '/favoritos';
  static const String perfil = '/perfil';
  static const String configuracoes = '/configuracoes';
  static const String forgotPassword = '/forgot-password';
  static const String forgotPasswordSuccess = '/forgot-password-success';
  static const String criarFichaTecnica = '/criar-ficha';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      main: (context) => const MainNavigation(),
      home: (context) => const Homepage(),
      login: (context) => const LoginPage(),
      cadastro: (context) => const CadastroPage(),
      inicial: (context) => const InicialPage(),
      favoritos: (context) => FavoritosPage(onBack: () => Navigator.pop(context)),
      perfil: (context) => PerfilPage(onBack: () => Navigator.pop(context)),
      configuracoes: (context) => const ConfiguracoesPage(),
      forgotPassword: (context) => const ForgotPasswordPage(),
      forgotPasswordSuccess: (context) => const ForgotPasswordSuccessPage(),
      criarFichaTecnica: (context) => const CriarFichaTecnica(),
    };
  }
}
