import 'package:flutter/material.dart';

class QuemSomosPage extends StatelessWidget {
  const QuemSomosPage({Key? key}) : super(key: key);

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Color(0xFF388E3C),
        ),
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, String description) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: const Color(0xFF388E3C)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(description, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        title: const Text('Quem Somos'),
        backgroundColor: const Color(0xFF388E3C),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem de destaque
            Center(
              child: Image.asset(
                'images/recycling.png', // Troque para uma imagem adequada no seu projeto
                height: 150,
              ),
            ),

            const SizedBox(height: 20),

            // Apresentação
            const Text(
              'Somos uma organização comprometida com o meio ambiente e com a transformação de resíduos em oportunidades. Promovemos a doação de materiais recicláveis e resíduos reaproveitáveis, conectando doadores a coletores, reduzindo o desperdício e incentivando a economia circular.',
              style: TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 30),

            _buildSectionTitle('Missão, Visão e Valores'),

            _buildCard(
              Icons.flag,
              'Missão',
              'Facilitar a doação consciente de resíduos e recicláveis, promovendo a sustentabilidade e o impacto social positivo.',
            ),

            _buildCard(
              Icons.visibility,
              'Visão',
              'Ser referência nacional na conexão entre quem doa e quem reutiliza, transformando o descarte em responsabilidade compartilhada.',
            ),

            _buildCard(
              Icons.favorite,
              'Valores',
              'Sustentabilidade, responsabilidade social, transparência, colaboração e educação ambiental.',
            ),

            const SizedBox(height: 30),

            _buildSectionTitle('O que fazemos'),

            _buildCard(
              Icons.recycling,
              'Coleta colaborativa',
              'Facilitamos a coleta de materiais recicláveis junto à comunidade.',
            ),

            _buildCard(
              Icons.card_giftcard,
              'Doações de resíduos',
              'Conectamos doadores a quem reutiliza, evitando o desperdício.',
            ),

            _buildCard(
              Icons.group,
              'Parcerias',
              'Trabalhamos com cooperativas e ONGs para ampliar o impacto.',
            ),

            _buildCard(
              Icons.school,
              'Educação ambiental',
              'Promovemos ações educativas para incentivar a consciência sustentável.',
            ),

            const SizedBox(height: 40),

            Center(
              child: Column(
                children: [
                  const Text(
                    'Quer fazer parte dessa mudança?',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF388E3C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Doe, colete, compartilhe. Juntos, reciclamos o futuro!',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navegar para a tela de cadastro ou doação
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF388E3C),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text(
                      'Comece Agora',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
