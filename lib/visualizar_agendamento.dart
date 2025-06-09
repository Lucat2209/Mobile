import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'materialeducativo.dart';
import 'quemsomos.dart';
import 'perfil.dart';
import 'login.dart';

class VisualizarAgendamento extends StatefulWidget {
  final String coletorEmail;

  const VisualizarAgendamento({Key? key, required this.coletorEmail}) : super(key: key);

  @override
  State<VisualizarAgendamento> createState() => _VisualizarAgendamentoState();
}

class _VisualizarAgendamentoState extends State<VisualizarAgendamento> {
  List<Map<String, dynamic>> _agendamentos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarAgendamentos();
  }

  Future<void> _carregarAgendamentos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? agendamentosJson = prefs.getString('agendamentos');

    if (agendamentosJson != null) {
      final List<dynamic> decoded = jsonDecode(agendamentosJson);
      final List<Map<String, dynamic>> todosAgendamentos = decoded.cast<Map<String, dynamic>>();

      setState(() {
        _agendamentos = todosAgendamentos
            .where((a) => a['coletorEmail'] == widget.coletorEmail)
            .toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _agendamentos = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Agendamentos'),
        backgroundColor: const Color(0xFF388E3C),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Colors.white),
            onSelected: (value) {
              if (value == 'material_educativo') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MaterialEducativoScreen()),
                );
              } else if (value == 'quem_somos') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuemSomosPage()),
                );
              } else if (value == 'perfil') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Perfil()),
                );
              } else if (value == 'sair') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Login()),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'material_educativo',
                child: ListTile(
                  leading: Icon(Icons.book),
                  title: Text('Material Educativo'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'quem_somos',
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Quem Somos'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'perfil',
                child: ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Perfil'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'sair',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Sair'),
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _agendamentos.isEmpty
              ? const Center(child: Text('Nenhum agendamento encontrado.'))
              : ListView.builder(
                  itemCount: _agendamentos.length,
                  itemBuilder: (context, index) {
                    final agendamento = _agendamentos[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.event, color: Color(0xFF388E3C)),
                        title: Text(agendamento['nomePessoa'] ?? ''),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Data: ${agendamento['data']}'),
                            Text('Hora: ${agendamento['hora']}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

/*// visualizar_agendamento.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class VisualizarAgendamento extends StatefulWidget {
  final String coletorEmail;

  const VisualizarAgendamento({Key? key, required this.coletorEmail})
      : super(key: key);

  @override
  State<VisualizarAgendamento> createState() => _VisualizarAgendamentoState();
}

class _VisualizarAgendamentoState extends State<VisualizarAgendamento> {
  List<Map<String, dynamic>> _agendamentos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarAgendamentos();
  }

  Future<void> _carregarAgendamentos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? agendamentosJson = prefs.getString('agendamentos');

    if (agendamentosJson != null) {
      final List<dynamic> decoded = jsonDecode(agendamentosJson);
      final List<Map<String, dynamic>> todosAgendamentos =
          decoded.cast<Map<String, dynamic>>();

      setState(() {
        _agendamentos = todosAgendamentos
            .where((a) => a['coletorEmail'] == widget.coletorEmail)
            .toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _agendamentos = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Agendamentos'),
        
        backgroundColor: const Color(0xFF388E3C),
      ),
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _agendamentos.isEmpty
              ? const Center(child: Text('Nenhum agendamento encontrado.'))
              : ListView.builder(
                  itemCount: _agendamentos.length,
                  itemBuilder: (context, index) {
                    final agendamento = _agendamentos[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.event, color: Color(0xFF388E3C)),
                        title: Text(agendamento['nomePessoa'] ?? ''),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Data: ${agendamento['data']}'),
                            Text('Hora: ${agendamento['hora']}'),
                            
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}*/


/*// visualizar_agendamento.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class VisualizarAgendamento extends StatefulWidget {
  final String coletorEmail;

  const VisualizarAgendamento({Key? key, required this.coletorEmail})
      : super(key: key);

  @override
  State<VisualizarAgendamento> createState() => _VisualizarAgendamentoState();
}

class _VisualizarAgendamentoState extends State<VisualizarAgendamento> {
  List<Map<String, dynamic>> _agendamentos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarAgendamentos();
  }

  Future<void> _carregarAgendamentos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? agendamentosJson = prefs.getString('agendamentos');

    if (agendamentosJson != null) {
      final List<dynamic> decoded = jsonDecode(agendamentosJson);
      final List<Map<String, dynamic>> todosAgendamentos =
          decoded.cast<Map<String, dynamic>>();

      setState(() {
        _agendamentos = todosAgendamentos
            .where((a) => a['coletorEmail'] == widget.coletorEmail)
            .toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _agendamentos = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Agendamentos'),
        
        backgroundColor: const Color(0xFF388E3C),
      ),
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _agendamentos.isEmpty
              ? const Center(child: Text('Nenhum agendamento encontrado.'))
              : ListView.builder(
                  itemCount: _agendamentos.length,
                  itemBuilder: (context, index) {
                    final agendamento = _agendamentos[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.event, color: Color(0xFF388E3C)),
                        title: Text(agendamento['nomePessoa'] ?? ''),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Data: ${agendamento['data']}'),
                            Text('Hora: ${agendamento['hora']}'),
                            
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}*/
