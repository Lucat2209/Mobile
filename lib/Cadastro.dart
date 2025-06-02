import 'package:flutter/material.dart';
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
}



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
