import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart'; // sua tela de login

class CadastroEndereco extends StatefulWidget {
  final String nome;
  final String email;
  final String senha;
  final String telefone;

  const CadastroEndereco({
    super.key,
    required this.nome,
    required this.email,
    required this.senha,
    required this.telefone,
    required String role,
    required String cpf,
  });

  @override
  State<CadastroEndereco> createState() => _CadastroEnderecoState();
}

class _CadastroEnderecoState extends State<CadastroEndereco> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerRua = TextEditingController();
  final TextEditingController _controllerBairro =
      TextEditingController(); // NOVO
  final TextEditingController _controllerNumero = TextEditingController();
  final TextEditingController _controllerCidade = TextEditingController();
  final TextEditingController _controllerUf =
      TextEditingController(); // Alterado de Estado para Uf
  final TextEditingController _controllerCep = TextEditingController();

  bool isLoadingCep = false;

  @override
  void initState() {
    super.initState();
    _controllerCep.addListener(_onCepChanged);
  }

  void _onCepChanged() {
    final cep = _controllerCep.text.trim();
    if (cep.length == 8 && !isLoadingCep) {
      _fetchAddressFromCep(cep);
    }
  }

  Future<void> _fetchAddressFromCep(String cep) async {
    setState(() {
      isLoadingCep = true;
    });

    try {
      final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['erro'] == true) {
          _showError('CEP não encontrado.');
        } else {
          setState(() {
            _controllerRua.text = data['logradouro'] ?? '';
            _controllerCidade.text = data['localidade'] ?? '';
            _controllerUf.text = data['uf'] ?? ''; // Alterado de Estado para Uf
            _controllerBairro.text = data['bairro'] ?? '';
          });
        }
      } else {
        _showError('Erro ao consultar CEP.');
      }
    } catch (e) {
      _showError('Erro ao consultar CEP: $e');
    } finally {
      setState(() {
        isLoadingCep = false;
      });
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> saveUserComplete() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = {
      'nome': widget.nome,
      'email': widget.email,
      'senha': widget.senha,
      'telefone': widget.telefone,
      'rua': _controllerRua.text,
      'bairro': _controllerBairro.text,
      'numero': _controllerNumero.text,
      'cidade': _controllerCidade.text,
      'uf': _controllerUf.text, // Alterado de Estado para Uf
      'cep': _controllerCep.text,
    };

    final usersListString = prefs.getString('users_basic');
    List usersList = [];

    if (usersListString != null) {
      final decoded = jsonDecode(usersListString);
      if (decoded is List) usersList = decoded;
    }

    int index = usersList.indexWhere((u) => u['email'] == widget.email);

    if (index >= 0) {
      usersList[index] = userData;
    } else {
      usersList.add(userData);
    }

    await prefs.setString('users_basic', jsonEncode(usersList));
  }

  Future<bool> registrarEndereco() async {
   
    final url = Uri.parse('http://localhost:8080/api/v1/admin/endereco');

    final body = jsonEncode({
      "nome": widget.nome,
      "email": widget.email,
      "senha": widget.senha,
      "telefone": widget.telefone,
      "rua": _controllerRua.text,
      "bairro": _controllerBairro.text,
      "numero": _controllerNumero.text,
      "cidade": _controllerCidade.text,
      "uf": _controllerUf.text, // Alterado de Estado para Uf
      "cep": _controllerCep.text,
      "usuario_id": 1
    });
    print("+++");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        final data = jsonDecode(response.body);
        _showError(data['message'] ?? 'Erro ao cadastrar endereço');
        return false;
      }
    } catch (e) {
      _showError('Erro ao conectar com o servidor');
      return false;
    }
  }

  Future<void> _salvarEnderecoEExibirPopup() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final sucesso = await registrarEndereco();

      if (!sucesso) return;

      await saveUserComplete();

      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('Cadastro Realizado com Sucesso'),
          content: const Text('Seu cadastro foi concluído com sucesso!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      _showError('Erro ao salvar endereço: $e');
    }
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String campo,
    TextInputType tipo = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: tipo,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Este campo é obrigatório';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
        ),
        errorStyle: const TextStyle(fontSize: 14),
      ),
      style: const TextStyle(fontSize: 20),
    );
  }

  @override
  void dispose() {
    _controllerCep.dispose();
    _controllerRua.dispose();
    _controllerBairro.dispose();
    _controllerNumero.dispose();
    _controllerCidade.dispose();
    _controllerUf.dispose(); // Alterado de Estado para Uf
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Cadastro Endereço',
          style: TextStyle(fontSize: 28, color: Colors.white),
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextFormField(
                  controller: _controllerCep,
                  label: 'CEP',
                  campo: 'CEP',
                  tipo: TextInputType.number,
                ),
                const SizedBox(height: 20),
                _buildTextFormField(
                  controller: _controllerRua,
                  label: 'Rua',
                  campo: 'Rua',
                ),
                const SizedBox(height: 20),
                _buildTextFormField(
                  controller: _controllerBairro,
                  label: 'Bairro',
                  campo: 'Bairro',
                ),
                const SizedBox(height: 20),
                _buildTextFormField(
                  controller: _controllerNumero,
                  label: 'Número',
                  campo: 'Número',
                  tipo: TextInputType.number,
                ),
                const SizedBox(height: 20),
                _buildTextFormField(
                  controller: _controllerCidade,
                  label: 'Cidade',
                  campo: 'Cidade',
                ),
                const SizedBox(height: 20),
                _buildTextFormField(
                  controller: _controllerUf, // Alterado de Estado para Uf
                  label: 'UF',
                  campo: 'UF',
                ),
                const SizedBox(height: 40),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _salvarEnderecoEExibirPopup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 4, 167, 59),
                    ),
                    child: const Text(
                      'Finalizar Cadastro',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart'; // Sua tela de login

class CadastroEndereco extends StatefulWidget {
  final String nome;
  final String email;
  final String senha;
  final String telefone;

  const CadastroEndereco({
    super.key,
    required this.nome,
    required this.email,
    required this.senha,
    required this.telefone,
    required String role,
  });

  @override
  State<CadastroEndereco> createState() => _CadastroEnderecoState();
}

class _CadastroEnderecoState extends State<CadastroEndereco> {
  final TextEditingController _controllerRua = TextEditingController();
  final TextEditingController _controllerNumero = TextEditingController();
  final TextEditingController _controllerCidade = TextEditingController();
  final TextEditingController _controllerEstado = TextEditingController();
  final TextEditingController _controllerCep = TextEditingController();

  bool isButtonEnabled = false;
  bool isLoadingCep = false;

  @override
  void initState() {
    super.initState();
    _controllerCep.addListener(_onCepChanged);
    _controllerRua.addListener(_checkFields);
    _controllerNumero.addListener(_checkFields);
    _controllerCidade.addListener(_checkFields);
    _controllerEstado.addListener(_checkFields);
    _checkFields();
  }

  void _checkFields() {
    setState(() {
      isButtonEnabled = _controllerCep.text.isNotEmpty &&
          _controllerRua.text.isNotEmpty &&
          _controllerNumero.text.isNotEmpty &&
          _controllerCidade.text.isNotEmpty &&
          _controllerEstado.text.isNotEmpty;
    });
  }

  void _onCepChanged() {
    final cep = _controllerCep.text.trim();
    if (cep.length == 8 && !isLoadingCep) {
      _fetchAddressFromCep(cep);
    }
    _checkFields();
  }

  Future<void> _fetchAddressFromCep(String cep) async {
    setState(() {
      isLoadingCep = true;
    });

    try {
      final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['erro'] == true) {
          _showError('CEP não encontrado.');
          _clearAddressFields();
        } else {
          setState(() {
            _controllerRua.text = data['logradouro'] ?? '';
            _controllerCidade.text = data['localidade'] ?? '';
            _controllerEstado.text = data['uf'] ?? '';
          });
        }
      } else {
        _showError('Erro ao consultar CEP.');
        _clearAddressFields();
      }
    } catch (e) {
      _showError('Erro ao consultar CEP: $e');
      _clearAddressFields();
    } finally {
      setState(() {
        isLoadingCep = false;
      });
      _checkFields();
    }
  }

  void _clearAddressFields() {
    setState(() {
      _controllerRua.text = '';
      _controllerCidade.text = '';
      _controllerEstado.text = '';
    });
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // Salva o usuário completo na lista persistente no SharedPreferences
  Future<void> saveUserComplete() async {
    final prefs = await SharedPreferences.getInstance();

    final userData = {
      'nome': widget.nome,
      'email': widget.email,
      'senha': widget.senha,
      'telefone': widget.telefone,
      'rua': _controllerRua.text,
      'numero': _controllerNumero.text,
      'cidade': _controllerCidade.text,
      'estado': _controllerEstado.text,
      'cep': _controllerCep.text,
    };

    final usersListString = prefs.getString('users_basic');
    List usersList = [];

    if (usersListString != null) {
      final decoded = jsonDecode(usersListString);
      if (decoded is List) {
        usersList = decoded;
      }
    }

    int index = usersList.indexWhere((u) => u['email'] == widget.email);

    if (index >= 0) {
      usersList[index] = userData;
    } else {
      usersList.add(userData);
    }

    await prefs.setString('users_basic', jsonEncode(usersList));
  }

  Future<void> _salvarEnderecoEExibirPopup() async {
    try {
      await saveUserComplete();

      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Cadastro Realizado com Sucesso'),
            content: const Text('Seu cadastro foi concluído com sucesso!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar endereço: $e')),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: (_) => _checkFields(),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        labelText: label,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              width: 4, color: Color.fromARGB(255, 67, 96, 107)),
          borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(35), right: Radius.circular(35)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              width: 4, color: Color.fromARGB(255, 67, 96, 107)),
          borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(35), right: Radius.circular(35)),
        ),
      ),
      style: const TextStyle(fontSize: 25),
    );
  }

  @override
  void dispose() {
    _controllerCep.dispose();
    _controllerRua.dispose();
    _controllerNumero.dispose();
    _controllerCidade.dispose();
    _controllerEstado.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Cadastro Endereço',
          style: TextStyle(fontSize: 28, color: Colors.white),
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
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildTextField(
                    controller: _controllerCep,
                    label: 'CEP',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(controller: _controllerRua, label: 'Rua'),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _controllerNumero,
                    label: 'Número',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                      controller: _controllerCidade, label: 'Cidade'),
                  const SizedBox(height: 20),
                  _buildTextField(
                      controller: _controllerEstado, label: 'Estado'),
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          isButtonEnabled ? _salvarEnderecoEExibirPopup : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 4, 167, 59),
                      ),
                      child: const Text(
                        'Finalizar Cadastro',
                        style: TextStyle(
                          letterSpacing: 6,
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
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
                child: Image.asset(
                  'images/logo.png',
                  fit: BoxFit.contain,
                  height: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} */
