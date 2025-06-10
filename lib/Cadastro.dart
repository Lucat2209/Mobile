import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'cadastroendereco.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerCpf = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();
  final TextEditingController _controllerConfirmarSenha = TextEditingController();
  final TextEditingController _controllerTelefone = TextEditingController();

  final FocusNode _senhaFocusNode = FocusNode();
  final FocusNode _cpfFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();  // NOVO

  String? _selectedRole;
  String? _senhaErro;
  String? _emailErro;
  String? _nomeErro;
  String? _cpfErro;

  bool _obscureSenha = true;
  bool _obscureConfirmarSenha = true;
  bool _mostrarRequisitosSenha = false;

  bool _nomeDigitado = false;
  bool _emailDigitado = false;
  bool _senhaDigitada = false;
  bool _confirmarSenhaDigitada = false;
  bool _cpfDigitado = false;

  @override
  void initState() {
    super.initState();

    _controllerNome.addListener(() {
      setState(() {
        _nomeDigitado = true;
        _nomeErro = _controllerNome.text.isEmpty ? 'Campo obrigatório' : null;
      });
      _checkFields();
    });

    _controllerEmail.addListener(() {
      setState(() {
        _emailDigitado = true;
        // Limpa erro se texto não está vazio e formato parece válido
        if (_controllerEmail.text.isNotEmpty &&
            RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(_controllerEmail.text)) {
          _emailErro = null;
        } else if (_controllerEmail.text.isEmpty) {
          _emailErro = 'Campo obrigatório';
        }
      });
      _checkFields();
    });

    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        _validarEmailFormato(_controllerEmail.text);
      }
    });

    _controllerCpf.addListener(() {
      setState(() {
        _cpfDigitado = true;
        _cpfErro = _controllerCpf.text.isEmpty ? 'Campo obrigatório' : null;
      });
      _checkFields();
    });

    _cpfFocusNode.addListener(() {
      if (_cpfFocusNode.hasFocus && _controllerCpf.text.isEmpty) {
        setState(() {
          _cpfErro = 'Campo obrigatório';
        });
      }
    });

    _controllerSenha.addListener(() {
      setState(() {
        _senhaDigitada = _controllerSenha.text.isNotEmpty;
      });
      _checkFields();
    });

    _controllerConfirmarSenha.addListener(() {
      setState(() {
        _confirmarSenhaDigitada = _controllerConfirmarSenha.text.isNotEmpty;
      });
      _checkFields();
    });

    _controllerTelefone.addListener(_checkFields);

    _senhaFocusNode.addListener(() {
      setState(() {
        _mostrarRequisitosSenha = _senhaFocusNode.hasFocus || _controllerSenha.text.isNotEmpty;
      });
    });

    _checkFields();
  }

  @override
  void dispose() {
    _controllerNome.dispose();
    _controllerEmail.dispose();
    _controllerCpf.dispose();
    _controllerSenha.dispose();
    _controllerConfirmarSenha.dispose();
    _controllerTelefone.dispose();
    _senhaFocusNode.dispose();
    _cpfFocusNode.dispose();
    _emailFocusNode.dispose();  // NOVO
    super.dispose();
  }

  bool _validarSenha(String senha) {
    final hasAtSymbol = senha.contains('@');
    final hasUppercase = senha.contains(RegExp(r'[A-Z]'));
    final hasDigit = senha.contains(RegExp(r'[0-9]'));
    final hasMinLength = senha.length >= 6;
    return hasAtSymbol && hasUppercase && hasDigit && hasMinLength;
  }

  void _validarEmailFormato(String email) {
    if (email.isEmpty) {
      setState(() {
        _emailErro = 'Campo obrigatório';
      });
      return;
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
      setState(() {
        _emailErro = 'Formato de e-mail inválido';
      });
    } else {
      setState(() {
        _emailErro = null;
      });
    }
  }

  void _checkFields() {
    setState(() {
      bool senhasIguais = _controllerSenha.text == _controllerConfirmarSenha.text;
      _senhaErro = senhasIguais ? null : 'As senhas não são iguais';
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    String? errorText,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    FocusNode? focusNode,
  }) {
    bool showErrorBorder = errorText != null;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: (_) => _checkFields(),
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        suffixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide(
            width: 4,
            color: showErrorBorder ? Colors.red : const Color.fromARGB(255, 67, 96, 107),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide(
            width: 4,
            color: showErrorBorder ? Colors.red : const Color(0xFF388E3C),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      style: const TextStyle(fontSize: 25),
      keyboardType: keyboardType ?? TextInputType.text,
      inputFormatters: inputFormatters ?? (label == 'E-mail' ? [FilteringTextInputFormatter.deny(RegExp(r'\s'))] : []),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback toggleVisibility,
    String? errorText,
    FocusNode? focusNode,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      onChanged: (_) => _checkFields(),
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: toggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide(
            color: errorText != null ? Colors.red : const Color.fromARGB(255, 67, 96, 107),
            width: 4,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide(
            color: errorText != null ? Colors.red : const Color(0xFF388E3C),
            width: 4,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      style: const TextStyle(fontSize: 25),
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
    );
  }

  Widget _buildSenhaRequisito(String texto, bool atendido) {
    return Row(
      children: [
        Icon(atendido ? Icons.check_circle : Icons.cancel, color: atendido ? Colors.green : Colors.red, size: 20),
        const SizedBox(width: 8),
        Text(
          texto,
          style: TextStyle(fontSize: 16, color: atendido ? Colors.green : Colors.red),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool senhaValida = _validarSenha(_controllerSenha.text);
    bool senhasIguais = _controllerSenha.text == _controllerConfirmarSenha.text;

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        elevation: 0,
        title: const Text('Cadastro', style: TextStyle(fontSize: 35, color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF81C784), Color(0xFF388E3C), Color.fromARGB(255, 74, 110, 76)],
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
              const Icon(Icons.recycling, size: 200, color: Color(0xFF388E3C)),
              const SizedBox(height: 20),

              _buildTextField(_controllerNome, 'Nome', Icons.person, errorText: _nomeErro),
              const SizedBox(height: 20),

              _buildTextField(_controllerEmail, 'E-mail', Icons.email, errorText: _emailErro, focusNode: _emailFocusNode),
              const SizedBox(height: 20),

              _buildTextField(_controllerCpf, 'CPF', Icons.credit_card, errorText: _cpfErro, focusNode: _cpfFocusNode),
              const SizedBox(height: 20),

              _buildPasswordField(
                controller: _controllerSenha,
                label: 'Senha',
                obscureText: _obscureSenha,
                toggleVisibility: () => setState(() => _obscureSenha = !_obscureSenha),
                errorText: _senhaErro,
                focusNode: _senhaFocusNode,
              ),

              if (_mostrarRequisitosSenha) ...[
                const SizedBox(height: 10),
                _buildSenhaRequisito('Deve conter "@"', _controllerSenha.text.contains('@')),
                _buildSenhaRequisito('Pelo menos uma letra maiúscula', _controllerSenha.text.contains(RegExp(r'[A-Z]'))),
                _buildSenhaRequisito('Pelo menos um número', _controllerSenha.text.contains(RegExp(r'[0-9]'))),
                _buildSenhaRequisito('Mínimo 6 caracteres', _controllerSenha.text.length >= 6),
              ],

              const SizedBox(height: 20),

              _buildPasswordField(
                controller: _controllerConfirmarSenha,
                label: 'Confirmar Senha',
                obscureText: _obscureConfirmarSenha,
                toggleVisibility: () => setState(() => _obscureConfirmarSenha = !_obscureConfirmarSenha),
                errorText: !senhasIguais && _confirmarSenhaDigitada ? _senhaErro : null,
              ),

              const SizedBox(height: 20),

              _buildTextField(
                _controllerTelefone,
                'Telefone',
                Icons.phone,
                inputFormatters: [TelefoneInputFormatter()],
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Coletor'),
                      value: 'Coletor',
                      groupValue: _selectedRole,
                      onChanged: (value) => setState(() => _selectedRole = value),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Doador'),
                      value: 'Doador',
                      groupValue: _selectedRole,
                      onChanged: (value) => setState(() => _selectedRole = value),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _nomeErro = _controllerNome.text.isEmpty ? 'Campo obrigatório' : null;
                    _emailErro = _controllerEmail.text.isEmpty ? 'Campo obrigatório' : null;
                    _cpfErro = _controllerCpf.text.isEmpty ? 'Campo obrigatório' : null;
                    _senhaErro = _controllerSenha.text.isEmpty ? 'Campo obrigatório' : null;
                  });

                  if (_controllerNome.text.isEmpty ||
                      _controllerEmail.text.isEmpty ||
                      _controllerCpf.text.isEmpty ||
                      _controllerSenha.text.isEmpty) {
                    return;
                  }

                  _validarEmailFormato(_controllerEmail.text);

                  if (_emailErro != null || !_validarSenha(_controllerSenha.text) || _controllerSenha.text != _controllerConfirmarSenha.text || _selectedRole == null) {
                    _showErrorDialog('Verifique se todos os campos foram preenchidos corretamente.');
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CadastroEndereco(
                        nome: _controllerNome.text,
                        email: _controllerEmail.text,
                        cpf: _controllerCpf.text,
                        senha: _controllerSenha.text,
                        telefone: _controllerTelefone.text,
                        role: _selectedRole!,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                  backgroundColor: const Color(0xFF388E3C),
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                ),
                child: const Text(
                  'PRÓXIMO',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TelefoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    int index = 0;

    if (digits.length >= 2) {
      buffer.write('(${digits.substring(0, 2)}) ');
      index = 2;
    }
    if (digits.length >= 7) {
      buffer.write('${digits.substring(index, index + 5)}-');
      index += 5;
    }
    if (digits.length > index) {
      buffer.write(digits.substring(index));
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

/*
import 'package:flutter/material.dart'; 
import 'package:flutter/services.dart';
import 'cadastroendereco.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerCpf = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();
  final TextEditingController _controllerConfirmarSenha = TextEditingController();
  final TextEditingController _controllerTelefone = TextEditingController();

  final FocusNode _senhaFocusNode = FocusNode();
  final FocusNode _cpfFocusNode = FocusNode();

  String? _selectedRole;
  String? _senhaErro;
  String? _emailErro;
  String? _nomeErro;
  String? _cpfErro;

  bool _obscureSenha = true;
  bool _obscureConfirmarSenha = true;
  bool _mostrarRequisitosSenha = false;

  bool _nomeDigitado = false;
  bool _emailDigitado = false;
  bool _senhaDigitada = false;
  bool _confirmarSenhaDigitada = false;
  bool _cpfDigitado = false;

  @override
  void initState() {
    super.initState();

    _controllerNome.addListener(() {
      setState(() {
        _nomeDigitado = true;
        _nomeErro = _controllerNome.text.isEmpty ? 'Campo obrigatório' : null;
      });
      _checkFields();
    });

    _controllerEmail.addListener(() {
      setState(() {
        _emailDigitado = true;
        _emailErro = _controllerEmail.text.isEmpty ? 'Campo obrigatório' : null;
      });
      _checkFields();
      _validarEmailUnico(_controllerEmail.text);
    });

    _controllerCpf.addListener(() {
      setState(() {
        _cpfDigitado = true;
        _cpfErro = _controllerCpf.text.isEmpty ? 'Campo obrigatório' : null;
      });
      _checkFields();
    });

    _cpfFocusNode.addListener(() {
      if (_cpfFocusNode.hasFocus && _controllerCpf.text.isEmpty) {
        setState(() {
          _cpfErro = 'Campo obrigatório';
        });
      }
    });

    _controllerSenha.addListener(() {
      setState(() {
        _senhaDigitada = _controllerSenha.text.isNotEmpty;
      });
      _checkFields();
    });

    _controllerConfirmarSenha.addListener(() {
      setState(() {
        _confirmarSenhaDigitada = _controllerConfirmarSenha.text.isNotEmpty;
      });
      _checkFields();
    });

    _controllerTelefone.addListener(_checkFields);

    _senhaFocusNode.addListener(() {
      setState(() {
        _mostrarRequisitosSenha = _senhaFocusNode.hasFocus || _controllerSenha.text.isNotEmpty;
      });
    });

    _checkFields();
  }

  @override
  void dispose() {
    _controllerNome.dispose();
    _controllerEmail.dispose();
    _controllerCpf.dispose();
    _controllerSenha.dispose();
    _controllerConfirmarSenha.dispose();
    _controllerTelefone.dispose();
    _senhaFocusNode.dispose();
    _cpfFocusNode.dispose();
    super.dispose();
  }

  bool _validarSenha(String senha) {
    final hasAtSymbol = senha.contains('@');
    final hasUppercase = senha.contains(RegExp(r'[A-Z]'));
    final hasDigit = senha.contains(RegExp(r'[0-9]'));
    final hasMinLength = senha.length >= 6;
    return hasAtSymbol && hasUppercase && hasDigit && hasMinLength;
  }

  Future<void> _validarEmailUnico(String email) async {
    if (email.isEmpty) {
      return;
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
      setState(() {
        _emailErro = 'E-mail inválido';
      });
      return;
    }

    await Future.delayed(const Duration(seconds: 1));
    if (email.toLowerCase() == 'exemplo@dominio.com') {
      setState(() {
        _emailErro = 'E-mail já cadastrado';
      });
    } else {
      setState(() {
        _emailErro = null;
      });
    }
  }

  void _checkFields() {
    setState(() {
      bool senhasIguais = _controllerSenha.text == _controllerConfirmarSenha.text;
      _senhaErro = senhasIguais ? null : 'As senhas não são iguais';
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isRequired = false,
    bool hasUserTyped = false,
    String? errorText,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    FocusNode? focusNode,
  }) {
    bool showErrorBorder = errorText != null;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: (_) => _checkFields(),
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        suffixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide(
            width: 4,
            color: showErrorBorder ? Colors.red : const Color.fromARGB(255, 67, 96, 107),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide(
            width: 4,
            color: showErrorBorder ? Colors.red : const Color(0xFF388E3C),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      style: const TextStyle(fontSize: 25),
      keyboardType: keyboardType ?? TextInputType.text,
      inputFormatters: inputFormatters ?? (label == 'E-mail' ? [FilteringTextInputFormatter.deny(RegExp(r'\s'))] : []),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback toggleVisibility,
    String? errorText,
    FocusNode? focusNode,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      onChanged: (_) => _checkFields(),
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: toggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide(
            color: errorText != null ? Colors.red : const Color.fromARGB(255, 67, 96, 107),
            width: 4,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide(
            color: errorText != null ? Colors.red : const Color(0xFF388E3C),
            width: 4,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      style: const TextStyle(fontSize: 25),
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
    );
  }

  Widget _buildSenhaRequisito(String texto, bool atendido) {
    return Row(
      children: [
        Icon(atendido ? Icons.check_circle : Icons.cancel, color: atendido ? Colors.green : Colors.red, size: 20),
        const SizedBox(width: 8),
        Text(
          texto,
          style: TextStyle(fontSize: 16, color: atendido ? Colors.green : Colors.red),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool senhaValida = _validarSenha(_controllerSenha.text);
    bool senhasIguais = _controllerSenha.text == _controllerConfirmarSenha.text;

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        elevation: 0,
        title: const Text('Cadastro', style: TextStyle(fontSize: 35, color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF81C784), Color(0xFF388E3C), Color.fromARGB(255, 74, 110, 76)],
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
              const Icon(Icons.recycling, size: 200, color: Color(0xFF388E3C)),
              const SizedBox(height: 20),

              _buildTextField(_controllerNome, 'Nome', Icons.person, isRequired: true, hasUserTyped: _nomeDigitado, errorText: _nomeErro),
              const SizedBox(height: 20),

              _buildTextField(_controllerEmail, 'E-mail', Icons.email, isRequired: true, hasUserTyped: _emailDigitado, errorText: _emailErro),
              const SizedBox(height: 20),

              _buildTextField(_controllerCpf, 'CPF', Icons.credit_card, isRequired: true, hasUserTyped: _cpfDigitado, errorText: _cpfErro, focusNode: _cpfFocusNode),
              const SizedBox(height: 20),

              _buildPasswordField(
                controller: _controllerSenha,
                label: 'Senha',
                obscureText: _obscureSenha,
                toggleVisibility: () => setState(() => _obscureSenha = !_obscureSenha),
                errorText: _senhaDigitada
                    ? (_controllerSenha.text.isEmpty
                        ? 'A senha é obrigatória'
                        : (!senhaValida ? 'A senha deve conter "@", letra maiúscula, número e no mínimo 6 caracteres' : null))
                    : null,
                focusNode: _senhaFocusNode,
              ),

              if (_mostrarRequisitosSenha) ...[
                const SizedBox(height: 10),
                _buildSenhaRequisito('Deve conter "@"', _controllerSenha.text.contains('@')),
                _buildSenhaRequisito('Pelo menos uma letra maiúscula', _controllerSenha.text.contains(RegExp(r'[A-Z]'))),
                _buildSenhaRequisito('Pelo menos um número', _controllerSenha.text.contains(RegExp(r'[0-9]'))),
                _buildSenhaRequisito('Mínimo 6 caracteres', _controllerSenha.text.length >= 6),
              ],

              const SizedBox(height: 20),

              _buildPasswordField(
                controller: _controllerConfirmarSenha,
                label: 'Confirmar Senha',
                obscureText: _obscureConfirmarSenha,
                toggleVisibility: () => setState(() => _obscureConfirmarSenha = !_obscureConfirmarSenha),
                errorText: !senhasIguais && _confirmarSenhaDigitada ? _senhaErro : null,
              ),

              const SizedBox(height: 20),

              _buildTextField(
                _controllerTelefone,
                'Telefone',
                Icons.phone,
                inputFormatters: [TelefoneInputFormatter()],
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Coletor'),
                      value: 'Coletor',
                      groupValue: _selectedRole,
                      onChanged: (value) {
                        setState(() => _selectedRole = value);
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Doador'),
                      value: 'Doador',
                      groupValue: _selectedRole,
                      onChanged: (value) {
                        setState(() => _selectedRole = value);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  List<String> camposFaltando = [];

                  if (_controllerNome.text.isEmpty) camposFaltando.add('Nome');
                  if (_controllerEmail.text.isEmpty) camposFaltando.add('E-mail');
                  if (_controllerCpf.text.isEmpty) camposFaltando.add('CPF');
                  if (_controllerSenha.text.isEmpty) camposFaltando.add('Senha');

                  if (camposFaltando.isNotEmpty) {
                    _showErrorDialog('Os seguintes campos são obrigatórios:\n${camposFaltando.join(', ')}');
                    return;
                  }

                  if (_emailErro != null) {
                    _showErrorDialog(_emailErro!);
                    return;
                  }
                  if (_nomeErro != null) {
                    _showErrorDialog(_nomeErro!);
                    return;
                  }
                  if (!_validarSenha(_controllerSenha.text)) {
                    _showErrorDialog(
                        'A senha deve conter "@", uma letra maiúscula, um número e no mínimo 6 caracteres.');
                    return;
                  }
                  if (_controllerSenha.text != _controllerConfirmarSenha.text) {
                    _showErrorDialog('As senhas não coincidem.');
                    return;
                  }
                  if (_selectedRole == null) {
                    _showErrorDialog('Selecione um tipo de usuário.');
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CadastroEndereco(
                        nome: _controllerNome.text,
                        email: _controllerEmail.text,
                        cpf: _controllerCpf.text,
                        senha: _controllerSenha.text,
                        telefone: _controllerTelefone.text,
                        role: _selectedRole!,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                  backgroundColor: const Color(0xFF388E3C),
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                ),
                child: const Text(
                  'PRÓXIMO',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TelefoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    final buffer = StringBuffer();
    int index = 0;

    if (digits.length >= 2) {
      buffer.write('(${digits.substring(0, 2)}) ');
      index = 2;
    }
    if (digits.length >= 7) {
      buffer.write('${digits.substring(index, index + 5)}-');
      index += 5;
    }
    if (digits.length > index) {
      buffer.write(digits.substring(index));
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}*/


/*import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'cadastroendereco.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerCpf = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();
  final TextEditingController _controllerConfirmarSenha = TextEditingController();
  final TextEditingController _controllerTelefone = TextEditingController();

  final FocusNode _senhaFocusNode = FocusNode();

  String? _selectedRole;
  String? _senhaErro;
  String? _emailErro;
  String? _nomeErro;

  bool _obscureSenha = true;
  bool _obscureConfirmarSenha = true;
  bool _mostrarRequisitosSenha = false;

  bool isButtonEnabled = true;

  bool _nomeDigitado = false;
  bool _emailDigitado = false;
  bool _senhaDigitada = false;
  bool _confirmarSenhaDigitada = false;

  @override
  void initState() {
    super.initState();

    _controllerNome.addListener(() {
      setState(() {
        _nomeDigitado = _controllerNome.text.isNotEmpty;
        _nomeErro = _controllerNome.text.isEmpty ? 'O nome é obrigatório' : null;
      });
      _checkFields();
    });

    _controllerEmail.addListener(() {
      setState(() {
        _emailDigitado = _controllerEmail.text.isNotEmpty;
      });
      _checkFields();
      _validarEmailUnico(_controllerEmail.text);
    });

    _controllerSenha.addListener(() {
      setState(() {
        _senhaDigitada = _controllerSenha.text.isNotEmpty;
      });
      _checkFields();
    });

    _controllerConfirmarSenha.addListener(() {
      setState(() {
        _confirmarSenhaDigitada = _controllerConfirmarSenha.text.isNotEmpty;
      });
      _checkFields();
    });

    _controllerTelefone.addListener(_checkFields);
    _senhaFocusNode.addListener(() {
      setState(() {
        _mostrarRequisitosSenha = _senhaFocusNode.hasFocus || _controllerSenha.text.isNotEmpty;
      });
    });

    _checkFields();
  }

  @override
  void dispose() {
    _controllerNome.dispose();
    _controllerEmail.dispose();
    _controllerCpf.dispose();
    _controllerSenha.dispose();
    _controllerConfirmarSenha.dispose();
    _controllerTelefone.dispose();
    _senhaFocusNode.dispose();
    super.dispose();
  }

  bool _validarSenha(String senha) {
    final hasAtSymbol = senha.contains('@');
    final hasUppercase = senha.contains(RegExp(r'[A-Z]'));
    final hasDigit = senha.contains(RegExp(r'[0-9]'));
    return hasAtSymbol && hasUppercase && hasDigit;
  }

  Future<void> _validarEmailUnico(String email) async {
    if (email.isEmpty) {
      setState(() {
        _emailErro = 'O e-mail é obrigatório';
      });
      return;
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\$').hasMatch(email)) {
      setState(() {
        _emailErro = 'E-mail inválido';
      });
      return;
    }

    await Future.delayed(const Duration(seconds: 1));
    if (email.toLowerCase() == 'exemplo@dominio.com') {
      setState(() {
        _emailErro = 'E-mail já cadastrado';
      });
    } else {
      setState(() {
        _emailErro = null;
      });
    }
  }

  void _checkFields() {
    setState(() {
      bool senhasIguais = _controllerSenha.text == _controllerConfirmarSenha.text;
      _senhaErro = senhasIguais ? null : 'As senhas não são iguais';
      isButtonEnabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool senhaValida = _validarSenha(_controllerSenha.text);
    bool senhasIguais = _controllerSenha.text == _controllerConfirmarSenha.text;

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        elevation: 0,
        title: const Text('Cadastro', style: TextStyle(fontSize: 35, color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF81C784), Color(0xFF388E3C), Color.fromARGB(255, 74, 110, 76)],
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
              const Icon(Icons.recycling, size: 200, color: Color(0xFF388E3C)),
              const SizedBox(height: 20),

              _buildTextField(_controllerNome, 'Nome', Icons.person, isRequired: true, hasUserTyped: _nomeDigitado, errorText: _nomeErro),
              const SizedBox(height: 20),
              _buildTextField(_controllerEmail, 'E-mail', Icons.email, isRequired: true, hasUserTyped: _emailDigitado, errorText: _emailErro),
              const SizedBox(height: 20),
              _buildTextField(_controllerCpf, 'CPF', Icons.badge, inputFormatters: [CpfInputFormatter()], keyboardType: TextInputType.number),
              const SizedBox(height: 20),

              _buildPasswordField(
                controller: _controllerSenha,
                label: 'Senha',
                obscureText: _obscureSenha,
                toggleVisibility: () => setState(() => _obscureSenha = !_obscureSenha),
                errorText: _senhaDigitada ? (_controllerSenha.text.isEmpty ? 'A senha é obrigatória' : (!senhaValida ? 'A senha deve conter "@", letra maiúscula e número' : null)) : null,
                focusNode: _senhaFocusNode,
              ),

              if (_mostrarRequisitosSenha) ...[
                const SizedBox(height: 10),
                _buildSenhaRequisito('Deve conter "@"', _controllerSenha.text.contains('@')),
                _buildSenhaRequisito('Pelo menos uma letra maiúscula', _controllerSenha.text.contains(RegExp(r'[A-Z]'))),
                _buildSenhaRequisito('Pelo menos um número', _controllerSenha.text.contains(RegExp(r'[0-9]'))),
              ],

              const SizedBox(height: 20),

              _buildPasswordField(
                controller: _controllerConfirmarSenha,
                label: 'Confirmar Senha',
                obscureText: _obscureConfirmarSenha,
                toggleVisibility: () => setState(() => _obscureConfirmarSenha = !_obscureConfirmarSenha),
                errorText: !senhasIguais && _confirmarSenhaDigitada ? _senhaErro : null,
              ),

              const SizedBox(height: 20),
              _buildTextField(_controllerTelefone, 'Telefone', Icons.phone, inputFormatters: [TelefoneInputFormatter()], keyboardType: TextInputType.phone),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Coletor'),
                      value: 'Coletor',
                      groupValue: _selectedRole,
                      onChanged: (value) => setState(() => _selectedRole = value),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Doador'),
                      value: 'Doador',
                      groupValue: _selectedRole,
                      onChanged: (value) => setState(() => _selectedRole = value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    if (_controllerNome.text.isEmpty) {
                      _showErrorDialog('Por favor, preencha o nome.');
                      return;
                    }
                    if (_controllerEmail.text.isEmpty || _emailErro != null) {
                      _showErrorDialog('Por favor, insira um e-mail válido e único.');
                      return;
                    }
                    if (_controllerSenha.text.isEmpty || !_validarSenha(_controllerSenha.text)) {
                      _showErrorDialog('A senha deve conter "@", letra maiúscula e número.');
                      return;
                    }
                    if (_controllerSenha.text != _controllerConfirmarSenha.text) {
                      _showErrorDialog('As senhas não coincidem.');
                      return;
                    }
                    if (_selectedRole == null) {
                      _showErrorDialog('Por favor, selecione um perfil.');
                      return;
                    }

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
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 4, 167, 59),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                  ),
                  child: const Text('Próximo', style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 4)),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF81C784), Color(0xFF388E3C), Color.fromARGB(255, 74, 110, 76)],
          ),
        ),
        child: Center(child: Image.asset('images/logo.png', height: 30)),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: Text(message),
        actions: [TextButton(child: const Text('OK'), onPressed: () => Navigator.of(context).pop())],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isRequired = false,
    bool hasUserTyped = false,
    String? errorText,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
  }) {
    bool showErrorBorder = errorText != null;

    return TextField(
      controller: controller,
      onChanged: (_) => _checkFields(),
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        suffixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide(
            width: 4,
            color: showErrorBorder ? Colors.red : const Color.fromARGB(255, 67, 96, 107),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide(
            width: 4,
            color: showErrorBorder ? Colors.red : const Color(0xFF388E3C),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      style: const TextStyle(fontSize: 25),
      keyboardType: keyboardType ?? TextInputType.text,
      inputFormatters: inputFormatters ?? (label == 'E-mail' ? [FilteringTextInputFormatter.deny(RegExp(r'\s'))] : []),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback toggleVisibility,
    String? errorText,
    FocusNode? focusNode,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      onChanged: (_) => _checkFields(),
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: toggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide(color: errorText != null ? Colors.red : const Color.fromARGB(255, 67, 96, 107), width: 4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide(color: errorText != null ? Colors.red : const Color(0xFF388E3C), width: 4),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      style: const TextStyle(fontSize: 25),
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
    );
  }

  Widget _buildSenhaRequisito(String texto, bool atendido) {
    return Row(
      children: [
        Icon(atendido ? Icons.check_circle : Icons.cancel, color: atendido ? Colors.green : Colors.red, size: 20),
        const SizedBox(width: 8),
        Text(texto, style: TextStyle(fontSize: 16, color: atendido ? Colors.green : Colors.red)),
      ],
    );
  }
}

class CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 11) digits = digits.substring(0, 11);

    String formatted = '';
    for (int i = 0; i < digits.length; i++) {
      if (i == 3 || i == 6) formatted += '.';
      if (i == 9) formatted += '-';
      formatted += digits[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class TelefoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 11) digits = digits.substring(0, 11);

    String formatted = '';
    if (digits.length >= 1) formatted += '(';
    if (digits.length >= 2) {
      formatted += digits.substring(0, 2) + ') ';
    } else if (digits.length == 1) {
      formatted += digits.substring(0, 1);
    }

    if (digits.length > 2 && digits.length <= 6) {
      formatted += digits.substring(2);
    } else if (digits.length >= 7) {
      formatted += digits.substring(2, 7) + '-';
      formatted += digits.substring(7);
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}*/



/*import 'package:flutter/material.dart';
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
              Icon(
                Icons.recycling,
                size: 200,
                color: const Color(0xFF388E3C),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _controllerNome,
                label: 'Nome',
                icon: Icons.person,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _controllerEmail,
                label: 'E-mail',
                icon: Icons.email,
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                controller: _controllerSenha,
                label: 'Senha',
                obscureText: _obscureSenha,
                toggleVisibility: () {
                  setState(() {
                    _obscureSenha = !_obscureSenha;
                  });
                },
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPasswordField(
                    controller: _controllerConfirmarSenha,
                    label: 'Confirmar Senha',
                    obscureText: _obscureConfirmarSenha,
                    toggleVisibility: () {
                      setState(() {
                        _obscureConfirmarSenha = !_obscureConfirmarSenha;
                      });
                    },
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
              _buildTextField(
                controller: _controllerTelefone,
                label: 'Telefone',
                icon: Icons.phone,
              ),
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
                          setState(() {
                            _selectedRole = value;
                          });
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
                          setState(() {
                            _selectedRole = value;
                          });
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
                  onPressed: isButtonEnabled
                      ? () async {
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
                        }
                      : null,
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
          child: Image.asset(
            'images/logo.png',
            fit: BoxFit.contain,
            height: 30,
          ),
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
      onChanged: (value) => _checkFields(),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        suffixIcon: Icon(icon),
        label: Text(label),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 4, color: Color.fromARGB(255, 67, 96, 107)),
          borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(35),
            right: Radius.circular(35),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 4, color: Color.fromARGB(255, 67, 96, 107)),
          borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(35),
            right: Radius.circular(35),
          ),
        ),
      ),
      style: const TextStyle(fontSize: 25),
      keyboardType: label == 'Telefone'
          ? TextInputType.phone
          : (label == 'E-mail'
              ? TextInputType.emailAddress
              : TextInputType.text),
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
      onChanged: (value) => _checkFields(),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: toggleVisibility,
        ),
        label: Text(label),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 4, color: Color.fromARGB(255, 67, 96, 107)),
          borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(35),
            right: Radius.circular(35),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 4, color: Color.fromARGB(255, 67, 96, 107)),
          borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(35),
            right: Radius.circular(35),
          ),
        ),
      ),
      style: const TextStyle(fontSize: 25),
    );
  }
}*/



/*import 'package:flutter/material.dart';
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
      isButtonEnabled = _controllerNome.text.isNotEmpty &&
          _controllerEmail.text.isNotEmpty &&
          _controllerSenha.text.isNotEmpty &&
          _controllerConfirmarSenha.text.isNotEmpty &&
          _controllerSenha.text == _controllerConfirmarSenha.text &&
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
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Green Code',
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
              Icon(
                Icons.recycling,
                size: 200,
                color: const Color(0xFF388E3C),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _controllerNome,
                label: 'Nome',
                icon: Icons.person,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _controllerEmail,
                label: 'E-mail',
                icon: Icons.email,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _controllerSenha,
                label: 'Senha',
                icon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _controllerConfirmarSenha,
                label: 'Confirmar Senha',
                icon: Icons.lock_outline,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _controllerTelefone,
                label: 'Telefone',
                icon: Icons.phone,
              ),
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
                          setState(() {
                            _selectedRole = value;
                          });
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
                          setState(() {
                            _selectedRole = value;
                          });
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
                  onPressed: isButtonEnabled
                      ? () async {
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
                        }
                      : null,
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
          child: Image.asset(
            'images/logo.png',
            fit: BoxFit.contain,
            height: 30,
          ),
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
      onChanged: (value) => _checkFields(),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        suffixIcon: Icon(icon),
        label: Text(label),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 4, color: Color.fromARGB(255, 67, 96, 107)),
          borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(35),
            right: Radius.circular(35),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 4, color: Color.fromARGB(255, 67, 96, 107)),
          borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(35),
            right: Radius.circular(35),
          ),
        ),
      ),
      style: const TextStyle(fontSize: 25),
      keyboardType: label == 'Telefone'
          ? TextInputType.phone
          : (label == 'E-mail'
              ? TextInputType.emailAddress
              : TextInputType.text),
    );
  }
}*/


/*import 'package:flutter/material.dart';
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
  final TextEditingController _controllerTelefone = TextEditingController();

  bool isButtonEnabled = false;

  // Variável para controlar a seleção entre Coletor e Doador
  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    _controllerNome.addListener(_checkFields);
    _controllerEmail.addListener(_checkFields);
    _controllerSenha.addListener(_checkFields);
    _controllerTelefone.addListener(_checkFields);
    _checkFields();
  }

  void _checkFields() {
    setState(() {
      // Botão habilitado se todos os campos obrigatórios e um botão de papel (Coletor ou Doador) estiverem preenchidos
      isButtonEnabled = _controllerNome.text.isNotEmpty &&
          _controllerEmail.text.isNotEmpty &&
          _controllerSenha.text.isNotEmpty &&
          _controllerTelefone.text.isNotEmpty &&
          _selectedRole != null;
    });
  }

  @override
  void dispose() {
    _controllerNome.dispose();
    _controllerEmail.dispose();
    _controllerSenha.dispose();
    _controllerTelefone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Green Code',
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
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Ícone de reciclagem centralizado e maior
                  Padding(
                    padding: const EdgeInsets.only(top: 40, bottom: 20),
                    child: Icon(
                      Icons.recycling,
                      size: 200, // Tamanho ajustado do ícone de reciclagem
                      color: const Color(0xFF388E3C), // Cor verde
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _controllerNome,
                    label: 'Nome',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _controllerEmail,
                    label: 'E-mail',
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _controllerSenha,
                    label: 'Senha',
                    icon: Icons.lock,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _controllerTelefone,
                    label: 'Telefone',
                    icon: Icons.phone,
                  ),
                  const SizedBox(height: 30),
                  // Adicionando os botões Coletor e Doador
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Coletor',
                            groupValue: _selectedRole,
                            onChanged: (value) {
                              setState(() {
                                _selectedRole = value;
                              });
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
                              setState(() {
                                _selectedRole = value;
                              });
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
                      onPressed: isButtonEnabled
                          ? () async {
                              // Em vez de salvar aqui, vamos passar pro próximo passo
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CadastroEndereco(
                                    nome: _controllerNome.text,
                                    email: _controllerEmail.text,
                                    senha: _controllerSenha.text,
                                    telefone: _controllerTelefone.text,
                                    role:
                                        _selectedRole!, // Passando o papel (Coletor ou Doador)
                                  ),
                                ),
                              );
                            }
                          : null,
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
                ],
              ),
            ),
          ),
          // Rodapé com a logo da imagem
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: (value) => _checkFields(),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        suffixIcon: Icon(icon),
        label: Text(label),
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
      keyboardType: label == 'Telefone'
          ? TextInputType.phone
          : (label == 'E-mail'
              ? TextInputType.emailAddress
              : TextInputType.text),
    );
  }
}*/
