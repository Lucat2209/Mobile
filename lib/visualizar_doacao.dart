import 'package:flutter/material.dart';
import 'perfil.dart';
import 'materialeducativo.dart';
import 'quemsomos.dart';
import 'login.dart';
import 'suporte.dart';

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
        title: const Text('Doações', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Colors.white),
            onSelected: (value) {
              if (value == 'perfil') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const Perfil()));
              } else if (value == 'material_educativo') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const MaterialEducativoScreen()));
              } else if (value == 'quem_somos') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const QuemSomosPage()));
              } else if (value == 'suporte') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SuportePage()));
              } else if (value == 'sair') {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Login()));
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'perfil', child: ListTile(leading: Icon(Icons.account_circle), title: Text('Perfil'))),
              const PopupMenuItem(value: 'material_educativo', child: ListTile(leading: Icon(Icons.book), title: Text('Material Educativo'))),
              const PopupMenuItem(value: 'quem_somos', child: ListTile(leading: Icon(Icons.info), title: Text('Quem Somos'))),
              const PopupMenuItem(value: 'suporte', child: ListTile(leading: Icon(Icons.support_agent), title: Text('Suporte'))),
              const PopupMenuItem(value: 'sair', child: ListTile(leading: Icon(Icons.logout), title: Text('Sair'))),
            ],
          )
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF81C784), Color(0xFF388E3C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: doacoes.isEmpty
          ? const Center(child: Text('Nenhuma doação registrada.', style: TextStyle(fontSize: 18)))
          : ListView.builder(
              itemCount: doacoes.length,
              itemBuilder: (context, index) {
                final doacao = doacoes[index];
                return Card(
                  margin: const EdgeInsets.all(12),
                  child: ListTile(
                    title: Text(doacao.nomeDoador),
                    subtitle: Text('${doacao.material} - Quantidade: ${doacao.quantidade}'),
                    trailing: Text('${doacao.data.day}/${doacao.data.month}/${doacao.data.year}'),
                  ),
                );
              },
            ),
    );
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
