import 'package:flutter/material.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'login.dart';
import 'perfil.dart';
import 'visualizar_agendamento.dart';
import 'materialeducativo.dart';  // Import da página Material Educativo
import 'quemsomos.dart';          // Import da página Quem Somos
import 'suporte.dart';            // Import da página Suporte

class AgendamentoColeta extends StatefulWidget {
  final String nomePessoa;

  const AgendamentoColeta({Key? key, required this.nomePessoa, required String coletorEmail}) : super(key: key);

  @override
  State<AgendamentoColeta> createState() => _AgendamentoColetaState();
}

class _AgendamentoColetaState extends State<AgendamentoColeta> {
  DateTime? _dataSelecionada;
  TimeOfDay? _horaSelecionada;
  String? _coletorEmail;

  @override
  void initState() {
    super.initState();
    _carregarEmail();
  }

  Future<void> _carregarEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _coletorEmail = prefs.getString('logged_user_email');
    });
  }

  String get _dataFormatada {
    if (_dataSelecionada == null) return 'Selecione a data';
    return '${_dataSelecionada!.day}/${_dataSelecionada!.month}/${_dataSelecionada!.year}';
  }

  String get _horaFormatada {
    if (_horaSelecionada == null) return 'Selecione a hora';
    final hora = _horaSelecionada!.hour.toString().padLeft(2, '0');
    final minuto = _horaSelecionada!.minute.toString().padLeft(2, '0');
    return '$hora:$minuto';
  }

  Future<void> _selecionarData() async {
    final hoje = DateTime.now();
    final data = await showDatePicker(
      context: context,
      initialDate: hoje,
      firstDate: hoje,
      lastDate: DateTime(hoje.year + 1),
    );
    if (data != null) {
      setState(() {
        _dataSelecionada = data;
      });
    }
  }

  Future<void> _selecionarHora() async {
    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (hora != null) {
      setState(() {
        _horaSelecionada = hora;
      });
    }
  }

  /// Salva o agendamento no SharedPreferences
  Future<void> saveAgendamento(Map<String, dynamic> agendamento) async {
    final prefs = await SharedPreferences.getInstance();
    final String? agendamentosJson = prefs.getString('agendamentos');

    List<dynamic> agendamentos = [];

    if (agendamentosJson != null && agendamentosJson.isNotEmpty) {
      try {
        agendamentos = jsonDecode(agendamentosJson);
      } catch (_) {
        agendamentos = [];
      }
    }

    agendamentos.add(agendamento);

    await prefs.setString('agendamentos', jsonEncode(agendamentos));
  }

  void _confirmarAgendamento() async {
    if (_dataSelecionada == null || _horaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione a data e a hora')),
      );
      return;
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              VisualizarAgendamento(coletorEmail: _coletorEmail!),
        ),
      );
    }

    final agendamento = {
      'coletorEmail': _coletorEmail,
      'pessoa': widget.nomePessoa,
      'data': _dataFormatada,
      'hora': _horaFormatada,
      'timestamp': DateTime.now().toIso8601String(),
    };

    await saveAgendamento(agendamento);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Agendamento realizado com sucesso!')),
    );

    setState(() {
      _dataSelecionada = null;
      _horaSelecionada = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int horaAtual = DateTime.now().hour;
    String saudacao;
    if (horaAtual >= 5 && horaAtual < 12) {
      saudacao = "Bom dia";
    } else if (horaAtual >= 12 && horaAtual < 18) {
      saudacao = "Boa tarde";
    } else {
      saudacao = "Boa noite";
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Agendamento de Coleta',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF81C784),
                Color(0xFF388E3C),
                Color.fromARGB(255, 74, 110, 76),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'perfil') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Perfil()),
                );
              } else if (value == 'visualizar') {
                if (_coletorEmail != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          VisualizarAgendamento(coletorEmail: _coletorEmail!),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Erro ao carregar o email do coletor. Faça login novamente.')),
                  );
                }
              } else if (value == 'material_educativo') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MaterialEducativoScreen()),
                );
              } else if (value == 'quem_somos') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuemSomosPage()),
                );
              } else if (value == 'suporte') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SuportePage()),
                );
              } else if (value == 'sair') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Login()),
                );
              }
            },
            icon: const Icon(Icons.dehaze, size: 28, color: Colors.white),
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'perfil',
                child: ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Perfil'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'visualizar',
                child: ListTile(
                  leading: Icon(Icons.event_note),
                  title: Text('Visualizar Agendamentos'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'material_educativo',
                child: ListTile(
                  leading: Icon(Icons.school),
                  title: Text('Material educativo'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'quem_somos',
                child: ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Quem somos'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'suporte',
                child: ListTile(
                  leading: Icon(Icons.support_agent),
                  title: Text('Suporte'),
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
      backgroundColor: const Color(0xFFE8F5E9),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              '$saudacao, ${widget.nomePessoa}',
              style: const TextStyle(
                fontSize: 28,
                color: Color.fromARGB(255, 74, 110, 76),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Agende a coleta para esta pessoa:',
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 74, 110, 76),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ListTile(
              title: Text(
                'Data: $_dataFormatada',
                style: const TextStyle(fontSize: 18),
              ),
              trailing: ElevatedButton(
                onPressed: _selecionarData,
                child: const Text('Selecionar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Hora: $_horaFormatada',
                style: const TextStyle(fontSize: 18),
              ),
              trailing: ElevatedButton(
                onPressed: _selecionarHora,
                child: const Text('Selecionar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _confirmarAgendamento,
                icon: const Icon(Icons.check, color: Colors.white),
                label: const Text(
                  'Confirmar Agendamento',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'login.dart';
import 'perfil.dart';
import 'visualizar_agendamento.dart';

class AgendamentoColeta extends StatefulWidget {
  final String nomePessoa;

  const AgendamentoColeta({Key? key, required this.nomePessoa, required String coletorEmail}) : super(key: key);

  @override
  State<AgendamentoColeta> createState() => _AgendamentoColetaState();
}

class _AgendamentoColetaState extends State<AgendamentoColeta> {
  DateTime? _dataSelecionada;
  TimeOfDay? _horaSelecionada;
  String? _coletorEmail;

  @override
  void initState() {
    super.initState();
    _carregarEmail();
  }

  Future<void> _carregarEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _coletorEmail = prefs.getString('logged_user_email');
    });
  }

  String get _dataFormatada {
    if (_dataSelecionada == null) return 'Selecione a data';
    return '${_dataSelecionada!.day}/${_dataSelecionada!.month}/${_dataSelecionada!.year}';
  }

  String get _horaFormatada {
    if (_horaSelecionada == null) return 'Selecione a hora';
    final hora = _horaSelecionada!.hour.toString().padLeft(2, '0');
    final minuto = _horaSelecionada!.minute.toString().padLeft(2, '0');
    return '$hora:$minuto';
  }

  Future<void> _selecionarData() async {
    final hoje = DateTime.now();
    final data = await showDatePicker(
      context: context,
      initialDate: hoje,
      firstDate: hoje,
      lastDate: DateTime(hoje.year + 1),
    );
    if (data != null) {
      setState(() {
        _dataSelecionada = data;
      });
    }
  }

  Future<void> _selecionarHora() async {
    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (hora != null) {
      setState(() {
        _horaSelecionada = hora;
      });
    }
  }

  /// 🔒 Salva o agendamento no SharedPreferences
  Future<void> saveAgendamento(Map<String, dynamic> agendamento) async {
    final prefs = await SharedPreferences.getInstance();
    final String? agendamentosJson = prefs.getString('agendamentos');

    List<dynamic> agendamentos = [];

    if (agendamentosJson != null && agendamentosJson.isNotEmpty) {
      try {
        agendamentos = jsonDecode(agendamentosJson);
      } catch (_) {
        agendamentos = [];
      }
    }

    agendamentos.add(agendamento);

    await prefs.setString('agendamentos', jsonEncode(agendamentos));
  }

  void _confirmarAgendamento() async {
    if (_dataSelecionada == null || _horaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione a data e a hora')),
      );
          return;
    } else{Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          VisualizarAgendamento(coletorEmail: _coletorEmail!),
                    ),
                  );
      /*ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lucas Alterou')),);*/

    }
    

    final agendamento = {
      'coletorEmail': _coletorEmail,
      'pessoa': widget.nomePessoa,
      'data': _dataFormatada,
      'hora': _horaFormatada,
      'timestamp': DateTime.now().toIso8601String(), // útil para ordenação
    };

    await saveAgendamento(agendamento);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Agendamento realizado com sucesso!')),
    );

    setState(() {
      _dataSelecionada = null;
      _horaSelecionada = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int horaAtual = DateTime.now().hour;
    String saudacao;
    if (horaAtual >= 5 && horaAtual < 12) {
      saudacao = "Bom dia";
    } else if (horaAtual >= 12 && horaAtual < 18) {
      saudacao = "Boa tarde";
    } else {
      saudacao = "Boa noite";
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Agendamento de Coleta',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF81C784),
                Color(0xFF388E3C),
                Color.fromARGB(255, 74, 110, 76),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'perfil') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Perfil()),
                );
              } else if (value == 'visualizar') {
                if (_coletorEmail != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          VisualizarAgendamento(coletorEmail: _coletorEmail!),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Erro ao carregar o email do coletor. Faça login novamente.')),
                  );
                }
              } else if (value == 'sair') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Login()),
                );
              }
            },
            icon: const Icon(Icons.dehaze, size: 28, color: Colors.white),
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'perfil',
                child: ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Perfil'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'visualizar',
                child: ListTile(
                  leading: Icon(Icons.event_note),
                  title: Text('Visualizar Agendamentos'),
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
      backgroundColor: const Color(0xFFE8F5E9),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              '$saudacao, ${widget.nomePessoa}',
              style: const TextStyle(
                fontSize: 28,
                color: Color.fromARGB(255, 74, 110, 76),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Agende a coleta para esta pessoa:',
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 74, 110, 76),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ListTile(
              title: Text(
                'Data: $_dataFormatada',
                style: const TextStyle(fontSize: 18),
              ),
              trailing: ElevatedButton(
                onPressed: _selecionarData,
                child: const Text('Selecionar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Hora: $_horaFormatada',
                style: const TextStyle(fontSize: 18),
              ),
              trailing: ElevatedButton(
                onPressed: _selecionarHora,
                child: const Text('Selecionar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _confirmarAgendamento,
                icon: const Icon(Icons.check, color: Colors.white),
                label: const Text(
                  'Confirmar Agendamento',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/


/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'perfil.dart';
import 'visualizar_agendamento.dart';

class AgendamentoColeta extends StatefulWidget {
  final String nomePessoa;

  const AgendamentoColeta({Key? key, required this.nomePessoa})
      : super(key: key);

  @override
  State<AgendamentoColeta> createState() => _AgendamentoColetaState();
}

class _AgendamentoColetaState extends State<AgendamentoColeta> {
  DateTime? _dataSelecionada;
  TimeOfDay? _horaSelecionada;
  String? _coletorEmail;

  @override
  void initState() {
    super.initState();
    _carregarEmail();
  }

  Future<void> _carregarEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _coletorEmail = prefs.getString('logged_user_email');
    });
  }

  String get _dataFormatada {
    if (_dataSelecionada == null) return 'Selecione a data';
    return '${_dataSelecionada!.day}/${_dataSelecionada!.month}/${_dataSelecionada!.year}';
  }

  String get _horaFormatada {
    if (_horaSelecionada == null) return 'Selecione a hora';
    final hora = _horaSelecionada!.hour.toString().padLeft(2, '0');
    final minuto = _horaSelecionada!.minute.toString().padLeft(2, '0');
    return '$hora:$minuto';
  }

  Future<void> _selecionarData() async {
    final hoje = DateTime.now();
    final data = await showDatePicker(
      context: context,
      initialDate: hoje,
      firstDate: hoje,
      lastDate: DateTime(hoje.year + 1),
    );
    if (data != null) {
      setState(() {
        _dataSelecionada = data;
      });
    }
  }

  Future<void> _selecionarHora() async {
    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (hora != null) {
      setState(() {
        _horaSelecionada = hora;
      });
    }
  }

  void _confirmarAgendamento() {
    if (_dataSelecionada == null || _horaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione a data e a hora')),
      );
      return;
    }

    print('Agendamento confirmado para ${widget.nomePessoa}:');
    print('Data: $_dataFormatada');
    print('Hora: $_horaFormatada');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Agendamento realizado com sucesso!')),
    );

    setState(() {
      _dataSelecionada = null;
      _horaSelecionada = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int horaAtual = DateTime.now().hour;
    String saudacao =
        (horaAtual >= 5 && horaAtual < 12) ? "Bom dia" : "Boa noite";

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Agendamento de Coleta',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF81C784),
                Color(0xFF388E3C),
                Color.fromARGB(255, 74, 110, 76),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'perfil') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Perfil()),
                );
              } else if (value == 'visualizar') {
                if (_coletorEmail != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          VisualizarAgendamento(coletorEmail: _coletorEmail!),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Erro ao carregar o email do coletor. Faça login novamente.')),
                  );
                }
              } else if (value == 'sair') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Login()),
                );
              }
            },
            icon: const Icon(Icons.dehaze, size: 28, color: Colors.white),
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'perfil',
                child: ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Perfil'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'visualizar',
                child: ListTile(
                  leading: Icon(Icons.event_note),
                  title: Text('Visualizar Agendamentos'),
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
      backgroundColor: const Color(0xFFE8F5E9),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              '$saudacao, ${widget.nomePessoa}',
              style: const TextStyle(
                fontSize: 28,
                color: Color.fromARGB(255, 74, 110, 76),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Agende a coleta para esta pessoa:',
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 74, 110, 76),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ListTile(
              title: Text(
                'Data: $_dataFormatada',
                style: const TextStyle(fontSize: 18),
              ),
              trailing: ElevatedButton(
                onPressed: _selecionarData,
                child: const Text('Selecionar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Hora: $_horaFormatada',
                style: const TextStyle(fontSize: 18),
              ),
              trailing: ElevatedButton(
                onPressed: _selecionarHora,
                child: const Text('Selecionar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _confirmarAgendamento,
                icon: const Icon(Icons.check, color: Colors.white),
                label: const Text(
                  'Confirmar Agendamento',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/

/*import 'package:flutter/material.dart';

// Supondo que você tenha essas telas já criadas
import 'perfil.dart';
import 'login.dart';

class AgendamentoColeta extends StatefulWidget {
  final String nomePessoa;

  const AgendamentoColeta({Key? key, required this.nomePessoa})
      : super(key: key);

  @override
  State<AgendamentoColeta> createState() => _AgendamentoColetaState();
}

class _AgendamentoColetaState extends State<AgendamentoColeta> {
  DateTime? _dataSelecionada;
  TimeOfDay? _horaSelecionada;
  final TextEditingController _enderecoController = TextEditingController();

  String get _dataFormatada {
    if (_dataSelecionada == null) return 'Selecione a data';
    return '${_dataSelecionada!.day}/${_dataSelecionada!.month}/${_dataSelecionada!.year}';
  }

  String get _horaFormatada {
    if (_horaSelecionada == null) return 'Selecione a hora';
    final hora = _horaSelecionada!.hour.toString().padLeft(2, '0');
    final minuto = _horaSelecionada!.minute.toString().padLeft(2, '0');
    return '$hora:$minuto';
  }

  Future<void> _selecionarData() async {
    final hoje = DateTime.now();
    final data = await showDatePicker(
      context: context,
      initialDate: hoje,
      firstDate: hoje,
      lastDate: DateTime(hoje.year + 1),
    );
    if (data != null) {
      setState(() {
        _dataSelecionada = data;
      });
    }
  }

  Future<void> _selecionarHora() async {
    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (hora != null) {
      setState(() {
        _horaSelecionada = hora;
      });
    }
  }

  void _confirmarAgendamento() {
    if (_dataSelecionada == null ||
        _horaSelecionada == null ||
        _enderecoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return;
    }

    print('Agendamento confirmado para ${widget.nomePessoa}:');
    print('Data: $_dataFormatada');
    print('Hora: $_horaFormatada');
    print('Endereço: ${_enderecoController.text}');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Agendamento realizado com sucesso!')),
    );

    // Opcional: limpar campos após confirmação
    setState(() {
      _dataSelecionada = null;
      _horaSelecionada = null;
      _enderecoController.clear();
    });
  }

  @override
  void dispose() {
    _enderecoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int horaAtual = DateTime.now().hour;
    String saudacao =
        (horaAtual >= 5 && horaAtual < 12) ? "Bom dia" : "Boa noite";

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Agendamento de Coleta',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF81C784),
                Color(0xFF388E3C),
                Color.fromARGB(255, 74, 110, 76),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'perfil') {
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
            icon: const Icon(Icons.dehaze, size: 28, color: Colors.white),
            itemBuilder: (context) => [
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
      backgroundColor: const Color(0xFFE8F5E9),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              '$saudacao, ${widget.nomePessoa}',
              style: const TextStyle(
                fontSize: 28,
                color: Color.fromARGB(255, 74, 110, 76),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Agende a coleta para esta pessoa:',
              style: const TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 74, 110, 76),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ListTile(
              title: Text(
                'Data: $_dataFormatada',
                style: const TextStyle(fontSize: 18),
              ),
              trailing: ElevatedButton(
                onPressed: _selecionarData,
                child: const Text('Selecionar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Hora: $_horaFormatada',
                style: const TextStyle(fontSize: 18),
              ),
              trailing: ElevatedButton(
                onPressed: _selecionarHora,
                child: const Text('Selecionar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                ),
              ),
            ),
            TextField(
              controller: _enderecoController,
              decoration: InputDecoration(
                labelText: 'Endereço para coleta',
                labelStyle: const TextStyle(color: Color(0xFF4CAF50)),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF4CAF50)),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF388E3C)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _confirmarAgendamento,
                icon: const Icon(Icons.check, color: Colors.white),
                label: const Text(
                  'Confirmar Agendamento',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
