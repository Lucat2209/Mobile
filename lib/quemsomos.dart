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
  title: const Text(
    'Quem Somos',
    style: TextStyle(color: Colors.white),
  ),
  backgroundColor: const Color(0xFF388E3C),
  centerTitle: true,
  iconTheme: const IconThemeData(color: Colors.white), // ícones brancos também
),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem com fundo escurecido (opcional)
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'images/logoB.png',
                    height: 150,
                    fit: BoxFit.cover,
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'A Green Code Solutions nasceu com o propósito de transformar o descarte em oportunidade. Somos uma empresa comprometida com a sustentabilidade, conectando doadores e coletores de resíduos recicláveis para promover uma sociedade mais consciente, justa e colaborativa.',
              style: TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 30),

            _buildSectionTitle('Missão, Visão e Valores'),

            _buildCard(
              Icons.flag,
              'Missão',
              'Desenvolver soluções tecnológicas que facilitam a doação responsável de resíduos e recicláveis, incentivando práticas sustentáveis e impacto social positivo.',
            ),

            _buildCard(
              Icons.visibility,
              'Visão',
              'Ser referência nacional em inovação sustentável, promovendo a economia circular e conectando pessoas através da tecnologia e do compromisso ambiental.',
            ),

            _buildCard(
              Icons.favorite,
              'Valores',
              'Sustentabilidade, responsabilidade social, inovação, transparência, colaboração e educação ambiental.',
            ),

            const SizedBox(height: 30),

            _buildSectionTitle('O que fazemos'),

            _buildCard(
              Icons.recycling,
              'Coleta colaborativa',
              'Criamos pontes entre doadores e coletores para facilitar a coleta e o reaproveitamento de materiais recicláveis.',
            ),

            _buildCard(
              Icons.card_giftcard,
              'Doações conscientes',
              'Incentivamos a doação de resíduos reutilizáveis, reduzindo o impacto ambiental e dando um novo destino ao que seria descartado.',
            ),

            _buildCard(
              Icons.group,
              'Parcerias sustentáveis',
              'Colaboramos com cooperativas, ONGs e instituições para fortalecer uma rede de impacto e inclusão socioambiental.',
            ),

            _buildCard(
              Icons.school,
              'Educação ambiental',
              'Promovemos ações educativas que despertam a consciência ecológica e a responsabilidade com o futuro do planeta.',
            ),

            const SizedBox(height: 40),

            Center(
              child: Column(
                children: [
                  const Text(
                    'Faça parte dessa transformação!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF388E3C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Com a Green Code Solutions, cada atitude conta.\nDoe, colete, compartilhe.\nJuntos reciclamos o futuro!',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Pode ser alterado para outra tela
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
