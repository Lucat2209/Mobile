import 'package:flutter/material.dart';

// Modelo simples de Doacao
class Doacao {
  final String nomeDoador;
  final String material;
  final int quantidade;
  final DateTime data;

  Doacao({
    required this.nomeDoador,
    required this.material,
    required this.quantidade,
    required this.data,
  });
}

class ListDoador extends StatelessWidget {
  final List<Doacao> doacoes;

  const ListDoador({super.key, required this.doacoes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Doações',
          style: TextStyle(fontSize: 35, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        centerTitle: true,
      ),
      body: doacoes.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma doação registrada.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: doacoes.length,
              itemBuilder: (context, index) {
                final doacao = doacoes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF81C784),
                      child: Text(
                        doacao.nomeDoador[0].toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text('${doacao.nomeDoador}'),
                    subtitle: Text(
                        '${doacao.material} — Quantidade: ${doacao.quantidade}\nData: ${_formatarData(doacao.data)}'),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }

  String _formatarData(DateTime data) {
    // Exemplo de formatação simples: dd/mm/yyyy
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }
}

/*import 'package:flutter/material.dart';

// Modelo simples de Doacao
class Doacao {
  final String nomeDoador;
  final String material;
  final int quantidade;
  final DateTime data;

  Doacao({
    required this.nomeDoador,
    required this.material,
    required this.quantidade,
    required this.data,
  });
}

class ListDoador extends StatelessWidget {
  final List<Doacao> doacoes;

  const ListDoador({super.key, required this.doacoes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Doações',
          style: TextStyle(fontSize: 35, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        centerTitle: true,
      ),
      body: doacoes.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma doação registrada.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: doacoes.length,
              itemBuilder: (context, index) {
                final doacao = doacoes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF81C784),
                      child: Text(
                        doacao.nomeDoador[0].toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text('${doacao.nomeDoador}'),
                    subtitle: Text(
                        '${doacao.material} — Quantidade: ${doacao.quantidade}\nData: ${_formatarData(doacao.data)}'),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }

  String _formatarData(DateTime data) {
    // Exemplo de formatação simples: dd/mm/yyyy
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }
}*/
