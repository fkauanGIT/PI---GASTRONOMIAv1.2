import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/routes/app_routes.dart';
import '../../../providers/auth_provider.dart';

class PerfilPage extends StatelessWidget {
  final VoidCallback? onBack;
  const PerfilPage({super.key, this.onBack});

  Future<void> _logout(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Perfil',
            style: TextStyle(color: cs.tertiary, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          if (onBack != null)
            IconButton(
              icon: Icon(Icons.close, color: cs.tertiary),
              onPressed: onBack,
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: cs.tertiary, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: cs.tertiary.withValues(alpha: 0.1),
                      child: Icon(Icons.person, size: 80, color: cs.tertiary),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: cs.tertiary, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user?.fullName ?? user?.username ?? 'Usuário',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: cs.onSurface),
            ),
            Text(user?.email ?? '',
                style: TextStyle(fontSize: 16, color: cs.onSurface.withValues(alpha: 0.5))),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: user?.isSuperuser == true ? Colors.orange : cs.tertiary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                user?.isSuperuser == true ? 'Administrador' : 'Usuário',
                style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildProfileOption(
                    icon: Icons.assignment,
                    title: 'Minhas Receitas',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Funcionalidade em desenvolvimento')),
                      );
                    },
                    cs: cs,
                  ),
                  _buildProfileOption(
                    icon: Icons.edit,
                    title: 'Editar Perfil',
                    onTap: () => _showEditProfileDialog(context, authProvider, cs),
                    cs: cs,
                  ),
                  _buildProfileOption(
                    icon: Icons.payment,
                    title: 'Assinatura Premium',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Funcionalidade em desenvolvimento')),
                      );
                    },
                    cs: cs,
                  ),
                  _buildProfileOption(
                    icon: Icons.help_outline,
                    title: 'Ajuda & Suporte',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Funcionalidade em desenvolvimento')),
                      );
                    },
                    cs: cs,
                  ),
                  const SizedBox(height: 16),
                  _buildProfileOption(
                    icon: Icons.logout,
                    title: 'Sair',
                    onTap: () => _logout(context),
                    textColor: Colors.red,
                    iconColor: Colors.red,
                    cs: cs,
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, AuthProvider authProvider, ColorScheme cs) {
    final nameController = TextEditingController(text: authProvider.user?.fullName ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Perfil'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Nome Completo',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await authProvider.updateProfile({
                'full_name': nameController.text.trim(),
              });
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Perfil atualizado!' : 'Erro ao atualizar perfil'),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: cs.tertiary),
            child: const Text('Salvar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required ColorScheme cs,
    Color? textColor,
    Color? iconColor,
  }) {
    final resolvedTextColor = textColor ?? cs.onSurface;
    final resolvedIconColor = iconColor ?? cs.tertiary;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: cs.surfaceContainerLow,
      elevation: 0,
      shadowColor: Colors.black.withValues(alpha: 0.04),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cs.outline.withValues(alpha: 0.3)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: resolvedIconColor),
        title: Text(title,
            style: TextStyle(color: resolvedTextColor, fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.chevron_right, color: cs.onSurface.withValues(alpha: 0.3)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
