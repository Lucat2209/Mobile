import 'package:flutter/material.dart';

class MaterialEducativoScreen extends StatelessWidget {
  const MaterialEducativoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material Educativo'),
        backgroundColor: const Color(0xFF388E3C),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ItemReciclavel(
            titulo: '1. Óleo de cozinha usado',
            oQueFazer: 'Biodiesel, sabão, velas.',
            beneficios:
                'Evita poluição, protege a água, gera energia renovável.',
            dinheiro:
                'Entre R\$ 1,00 a R\$ 3,00 por litro (depende da região e quantidade).',
          ),
          ItemReciclavel(
            titulo: '2. Tampa de plástico',
            oQueFazer: 'Brinquedos, cadeiras de rodas, móveis.',
            beneficios:
                'Diminui o lixo, promove economia circular, ações sociais.',
            dinheiro: 'Entre R\$ 2,00 a R\$ 5,00 por kg.',
          ),
          ItemReciclavel(
            titulo: '3. Garrafa PET',
            oQueFazer: 'Fibras para roupas, novos recipientes, artesanato.',
            beneficios:
                'Economiza recursos, reduz poluição, gera renda.',
            dinheiro: 'Entre R\$ 1,20 a R\$ 2,50 por kg.',
          ),
          ItemReciclavel(
            titulo: '4. Garrafa plástica (HDPE e outros)',
            oQueFazer:
                'Utensílios plásticos, peças para construção, artesanato.',
            beneficios:
                'Reduz emissão de gases, reutiliza materiais, consciência ambiental.',
            dinheiro: 'Entre R\$ 1,00 a R\$ 3,00 por kg.',
          ),
        ],
      ),
    );
  }
}

class ItemReciclavel extends StatelessWidget {
  final String titulo;
  final String oQueFazer;
  final String beneficios;
  final String dinheiro;

  const ItemReciclavel({
    super.key,
    required this.titulo,
    required this.oQueFazer,
    required this.beneficios,
    required this.dinheiro,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('🛠 O que dá para fazer:\n$oQueFazer'),
            const SizedBox(height: 4),
            Text('🌿 Benefícios:\n$beneficios'),
            const SizedBox(height: 4),
            Text('💸 Dinheiro que pode ganhar:\n$dinheiro'),
          ],
        ),
      ),
    );
  }
}
