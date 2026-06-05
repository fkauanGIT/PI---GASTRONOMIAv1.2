import 'package:flutter/material.dart';

class VisualizarFichaTecnica extends StatelessWidget {
  final Map<String, dynamic>? receita;
  const VisualizarFichaTecnica({super.key, this.receita});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final String titulo = receita?['titulo'] ?? 'Bolo de Chocolate Belga 70%';
    final String imagem = receita?['imagem'] ?? 'assets/imagens/arroz_branco.jpg';
    final String categoria = receita?['subtitulo'] ?? 'Confeitaria Fina';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Image.asset(
                      imagem,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 200,
                        color: cs.surfaceContainerLow,
                        child: Icon(Icons.image, size: 80, color: cs.onSurface.withValues(alpha: 0.3)),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(categoria,
                            style: TextStyle(fontSize: 15, color: cs.onSurface.withValues(alpha: 0.7))),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: cs.tertiary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Avançado',
                            style: TextStyle(
                                color: cs.tertiary, fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _InfoCard(icon: Icons.access_time, label: 'Tempo', value: '60 min', cs: cs),
                        _InfoCard(icon: Icons.people, label: 'Porções', value: '10', cs: cs),
                        _InfoCard(icon: Icons.attach_money, label: 'Custo Total', value: 'R\$ 80,00', cs: cs),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('Técnicas Aplicadas',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: cs.onSurface)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _TecnicaChip('Emulsificação', cs: cs),
                        _TecnicaChip('Roux', cs: cs),
                        _TecnicaChip('Bain-marie', cs: cs),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('Ficha Técnica - Ingredientes',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: cs.onSurface)),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: cs.outline),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _IngredienteItem(numero: '1', nome: 'Farinha de trigo T55', quantidade: '200 g', preco: 'R\$ 3,50', cs: cs),
                          Divider(height: 1, color: cs.outline),
                          _IngredienteItem(numero: '2', nome: 'Chocolate Callebaut 70%', quantidade: '150 g', preco: 'R\$ 18,00', cs: cs),
                          Divider(height: 1, color: cs.outline),
                          _IngredienteItem(numero: '3', nome: 'Ovos orgânicos', quantidade: '4 unidades', preco: 'R\$ 3,20', cs: cs),
                          Divider(height: 1, color: cs.outline),
                          _IngredienteItem(numero: '4', nome: 'Açúcar refinado', quantidade: '180 g', preco: 'R\$ 1,80', cs: cs),
                          Divider(height: 1, color: cs.outline),
                          _IngredienteItem(numero: '5', nome: 'Manteiga sem sal', quantidade: '150 g', preco: 'R\$ 7,20', cs: cs),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Custo Total:',
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: cs.onSurface)),
                              Text('R\$ 33,70',
                                  style: TextStyle(color: cs.tertiary, fontWeight: FontWeight.bold, fontSize: 15)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Custo por Porção:',
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: cs.onSurface)),
                              Text('R\$ 3,37',
                                  style: TextStyle(color: cs.tertiary, fontWeight: FontWeight.bold, fontSize: 15)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Modo de Preparo',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: cs.onSurface)),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerLow,
                        border: Border.all(color: cs.outline),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Bata o Roux. Incorpore o chocolate em três tempos. Asse em forno estático a 170°C por 45 minutos. Deixe esfriar antes de desenformar.',
                        style: TextStyle(fontSize: 14, height: 1.5, color: cs.onSurface.withValues(alpha: 0.8)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Armazenamento e Validade',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: cs.onSurface)),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerLow,
                        border: Border.all(color: cs.outline),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '3 dias refrigerado (3°C), 60 dias congelado.',
                        style: TextStyle(fontSize: 14, height: 1.5, color: cs.onSurface.withValues(alpha: 0.8)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Sugestões de Apresentação',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: cs.onSurface)),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerLow,
                        border: Border.all(color: cs.outline),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Finalizar com pó de ouro e flores comestíveis.',
                        style: TextStyle(fontSize: 14, height: 1.5, color: cs.onSurface.withValues(alpha: 0.8)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: cs.tertiary, width: 2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.edit, color: cs.tertiary),
                            label: Text('Editar',
                                style: TextStyle(color: cs.tertiary, fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF6B6B),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Excluir Receita'),
                                  content: const Text('Tem certeza que deseja excluir esta ficha técnica?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancelar'),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B6B)),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Ficha técnica excluída com sucesso!'),
                                            backgroundColor: Color(0xFFFF6B6B),
                                          ),
                                        );
                                      },
                                      child: const Text('Excluir', style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.delete, color: Colors.white),
                            label: const Text('Excluir',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
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

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme cs;

  const _InfoCard({required this.icon, required this.label, required this.value, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: cs.outline, width: 1.5),
        borderRadius: BorderRadius.circular(12),
        color: cs.surfaceContainerLow,
      ),
      child: Column(
        children: [
          Icon(icon, color: cs.tertiary, size: 28),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 13, color: cs.onSurface.withValues(alpha: 0.5))),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: cs.onSurface),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _TecnicaChip extends StatelessWidget {
  final String texto;
  final ColorScheme cs;

  const _TecnicaChip(this.texto, {required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        border: Border.all(color: cs.tertiary, width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(texto,
          style: TextStyle(color: cs.tertiary, fontWeight: FontWeight.w500, fontSize: 14)),
    );
  }
}

class _IngredienteItem extends StatelessWidget {
  final String numero;
  final String nome;
  final String quantidade;
  final String preco;
  final ColorScheme cs;

  const _IngredienteItem({
    required this.numero,
    required this.nome,
    required this.quantidade,
    required this.preco,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$numero. $nome',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: cs.onSurface)),
                const SizedBox(height: 4),
                Text(quantidade,
                    style: TextStyle(fontSize: 13, color: cs.onSurface.withValues(alpha: 0.5))),
              ],
            ),
          ),
          Text(preco,
              style: TextStyle(color: cs.tertiary, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}
