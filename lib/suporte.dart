import 'package:flutter/material.dart';

class SuportePage extends StatelessWidget {
  const SuportePage({Key? key}) : super(key: key);

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF388E3C),
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String subtitle) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, size: 30, color: const Color(0xFF388E3C)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      ),
    );
  }

  Widget _buildFAQ(String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: const TextStyle(fontWeight: FontWeight.w600)),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Text(answer),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suporte', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF388E3C),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Entre em contato'),
            _buildInfoCard(Icons.email, 'E-mail', 'suporte@greencode.com'),
            _buildInfoCard(Icons.phone, 'Telefone', '(11) 4198-3246'),
            _buildInfoCard(Icons.chat, 'WhatsApp 1', '(11) 97491-0916'),
            _buildInfoCard(Icons.chat, 'WhatsApp 2', '(11) 94797-9043'),
            _buildInfoCard(Icons.chat, 'WhatsApp 3', '(11) 96171-4957'),

            const SizedBox(height: 20),
            _buildSectionTitle('Perguntas Frequentes'),

            _buildFAQ(
              'Como posso doar meus materiais recicláveis?',
              'Você pode cadastrar sua doação na aba de doações, escolher o tipo de material e aguardar um coletor próximo entrar em contato.',
            ),
            _buildFAQ(
              'Recebo algum valor pela doação?',
              'Em alguns casos, sim! Cooperativas parceiras podem oferecer bonificações dependendo do material.',
            ),
            _buildFAQ(
              'Como me cadastro como coletor?',
              'Basta acessar a aba de cadastro, preencher suas informações básicas como nome, e-mail, cpf, telefone selecionar "coletor" e endereço. Após análise, você será aprovado como coletor ativo na plataforma.',
            ),
            _buildFAQ(
              'Como me cadastro como doador?',
              'Basta acessar a aba de cadastro, preencher suas informações básicas como nome, e-mail, cpf, telefone selecionar "doador" e endereço. Após o cadastro, você poderá registrar doações e acompanhar os recolhimentos.',
            ),

            const SizedBox(height: 30),

            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mensagem enviada com sucesso!')),
                  );
                },
                icon: const Icon(Icons.send),
                label: const Text('Enviar mensagem'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF388E3C),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
