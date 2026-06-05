import 'package:flutter/material.dart';

class CriarFichaLayout extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;

  const CriarFichaLayout({
    super.key,
    required this.child,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1024;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: appBar,
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: -20,
            child: Opacity(
              opacity: 0.08,
              child: Image.asset(
                'assets/imagens/senac_fundo.png',
                width: 450,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? width * 0.1 : 24,
                vertical: 40,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isDesktop ? 1200 : 800,
                  ),
                  child: Column(
                    children: [
                      child,
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}