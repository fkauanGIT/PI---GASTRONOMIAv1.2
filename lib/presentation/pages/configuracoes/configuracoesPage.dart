import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';

class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({super.key});

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  bool _notificacoes = true;
  String _idioma = 'Português';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Configurações',
          style: TextStyle(color: cs.tertiary, fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.tertiary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Preferências', cs),
          _buildSwitchTile(
            title: 'Notificações',
            subtitle: 'Receber alertas de novas receitas',
            icon: Icons.notifications_none,
            value: _notificacoes,
            onChanged: (val) => setState(() => _notificacoes = val),
            cs: cs,
          ),
          _buildSwitchTile(
            title: 'Tema Escuro',
            subtitle: 'Alternar entre tema claro e escuro',
            icon: isDark ? Icons.dark_mode : Icons.light_mode_outlined,
            value: isDark,
            onChanged: (val) => themeProvider.setDark(val),
            cs: cs,
          ),
          _buildListTile(
            title: 'Idioma',
            subtitle: _idioma,
            icon: Icons.language,
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Idioma'),
                  content: RadioGroup<String>(
                    groupValue: _idioma,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _idioma = val);
                        Navigator.pop(context);
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: ['Português', 'English', 'Español'].map((lang) {
                        return ListTile(
                          title: Text(lang),
                          leading: Radio<String>(value: lang),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            },
            cs: cs,
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Aplicativo', cs),
          _buildListTile(
            title: 'Sobre o App',
            subtitle: 'Versão 1.0.0',
            icon: Icons.info_outline,
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Gastro SENAC',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2026 SENAC',
              );
            },
            cs: cs,
          ),
          _buildListTile(
            title: 'Termos de Uso',
            icon: Icons.description_outlined,
            onTap: () {},
            cs: cs,
          ),
          _buildListTile(
            title: 'Privacidade',
            icon: Icons.security,
            onTap: () {},
            cs: cs,
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Conta', cs),
          _buildListTile(
            title: 'Limpar Cache',
            icon: Icons.delete_outline,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache limpo com sucesso!')),
              );
            },
            cs: cs,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: cs.tertiary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
    required ColorScheme cs,
  }) {
    return Card(
      elevation: 0,
      color: cs.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cs.outline.withValues(alpha: 0.3)),
      ),
      child: SwitchListTile(
        title: Text(title,
            style: TextStyle(fontWeight: FontWeight.w500, color: cs.onSurface)),
        subtitle: Text(subtitle,
            style: TextStyle(fontSize: 12, color: cs.onSurface.withValues(alpha: 0.6))),
        secondary: Icon(icon, color: cs.tertiary),
        value: value,
        onChanged: onChanged,
        activeThumbColor: cs.tertiary,
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    String? subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required ColorScheme cs,
  }) {
    return Card(
      elevation: 0,
      color: cs.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cs.outline.withValues(alpha: 0.3)),
      ),
      child: ListTile(
        title: Text(title,
            style: TextStyle(fontWeight: FontWeight.w500, color: cs.onSurface)),
        subtitle: subtitle != null
            ? Text(subtitle,
                style: TextStyle(fontSize: 12, color: cs.onSurface.withValues(alpha: 0.6)))
            : null,
        leading: Icon(icon, color: cs.tertiary),
        trailing: Icon(Icons.chevron_right, color: cs.onSurface.withValues(alpha: 0.4), size: 20),
        onTap: onTap,
      ),
    );
  }
}
