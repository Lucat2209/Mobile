import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';  // <-- Import adicionado

import 'cadastroendereco.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();
  final TextEditingController _controllerConfirmarSenha = TextEditingController();
  final TextEditingController _controllerTelefone = TextEditingController();

  bool isButtonEnabled = false;
  String? _selectedRole;
  String? _senhaErro;

  bool _obscureSenha = true;
  bool _obscureConfirmarSenha = true;

  @override
  void initState() {
    super.initState();
    _controllerNome.addListener(_checkFields);
    _controllerEmail.addListener(_checkFields);
    _controllerSenha.addListener(_checkFields);
    _controllerConfirmarSenha.addListener(_checkFields);
    _controllerTelefone.addListener(_checkFields);
    _checkFields();
  }

  void _checkFields() {
    setState(() {
      bool senhasIguais = _controllerSenha.text == _controllerConfirmarSenha.text;
      _senhaErro = senhasIguais ? null : 'As senhas não estão correspondentes uma à outra';

      isButtonEnabled = _controllerNome.text.isNotEmpty &&
          _controllerEmail.text.isNotEmpty &&
          _controllerSenha.text.isNotEmpty &&
          _controllerConfirmarSenha.text.isNotEmpty &&
          senhasIguais &&
          _controllerTelefone.text.isNotEmpty &&
          _selectedRole != null;
    });
  }

  @override
  void dispose() {
    _controllerNome.dispose();
    _controllerEmail.dispose();
    _controllerSenha.dispose();
    _controllerConfirmarSenha.dispose();
    _controllerTelefone.dispose();
    super.dispose();
  }

  Future<void> _enviarCadastro() async {
    // Aqui faz a verificação se é Web ou Android emulador
    final baseUrl = kIsWeb ? 'http://localhost:8080' : 'http://10.0.2.2:8080';
    final url = Uri.parse('$baseUrl/api/v1/admin');

    final Map<String, dynamic> dados = {
      'nome': _controllerNome.text,
      'email': _controllerEmail.text,
      'senha': _controllerSenha.text,
      'telefone': _controllerTelefone.text,
      'role': _selectedRole,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dados),
      );

      print('STATUS CODE: ${response.statusCode}');
      print('RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CadastroEndereco(
              nome: _controllerNome.text,
              email: _controllerEmail.text,
              senha: _controllerSenha.text,
              telefone: _controllerTelefone.text,
              role: _selectedRole!,
            ),
          ),
        );
      } else {
        _mostrarErro('Erro no cadastro: ${response.body}');
      }
    } catch (e) {
      print('EXCEÇÃO AO ENVIAR CADASTRO: $e');
      _mostrarErro('Erro ao conectar com o servidor.');
    }
  }

  void _mostrarErro(String mensagem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: Text(mensagem),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Cadastro',
          style: TextStyle(fontSize: 35, color: Colors.white),
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Icon(Icons.recycling, size: 200, color: Color(0xFF388E3C)),
              const SizedBox(height: 20),
              _buildTextField(controller: _controllerNome, label: 'Nome', icon: Icons.person),
              const SizedBox(height: 20),
              _buildTextField(controller: _controllerEmail, label: 'E-mail', icon: Icons.email),
              const SizedBox(height: 20),
              _buildPasswordField(
                controller: _controllerSenha,
                label: 'Senha',
                obscureText: _obscureSenha,
                toggleVisibility: () => setState(() => _obscureSenha = !_obscureSenha),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPasswordField(
                    controller: _controllerConfirmarSenha,
                    label: 'Confirmar Senha',
                    obscureText: _obscureConfirmarSenha,
                    toggleVisibility: () => setState(() => _obscureConfirmarSenha = !_obscureConfirmarSenha),
                  ),
                  if (_senhaErro != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 5),
                      child: Text(
                        _senhaErro!,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              _buildTextField(controller: _controllerTelefone, label: 'Telefone', icon: Icons.phone),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Coletor',
                        groupValue: _selectedRole,
                        onChanged: (value) {
                          setState(() => _selectedRole = value);
                          _checkFields();
                        },
                      ),
                      const Text('Coletor'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Doador',
                        groupValue: _selectedRole,
                        onChanged: (value) {
                          setState(() => _selectedRole = value);
                          _checkFields();
                        },
                      ),
                      const Text('Doador'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isButtonEnabled ? _enviarCadastro : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 4, 167, 59),
                  ),
                  child: const Text(
                    'Próximo',
                    style: TextStyle(
                      letterSpacing: 10,
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
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
        child: Center(
          child: Image.asset('images/logo.png', fit: BoxFit.contain, height: 30),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: (_) => _checkFields(),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        suffixIcon: Icon(icon),
        label: Text(label),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 4, color: Color.fromARGB(255, 67, 96, 107)),
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(35), right: Radius.circular(35)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 4, color: Color.fromARGB(255, 67, 96, 107)),
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(35), right: Radius.circular(35)),
        ),
      ),
      style: const TextStyle(fontSize: 25),
      keyboardType: label == 'Telefone'
          ? TextInputType.phone
          : (label == 'E-mail' ? TextInputType.emailAddress : TextInputType.text),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback toggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: (_) => _checkFields(),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: toggleVisibility,
        ),
        label: Text(label),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 4, color: Color.fromARGB(255, 67, 96, 107)),
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(35), right: Radius.circular(35)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 4, color: Color.fromARGB(255, 67, 96, 107)),
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(35), right: Radius.circular(35)),
        ),
      ),
      style: const TextStyle(fontSize: 25),
    );
  }
}
