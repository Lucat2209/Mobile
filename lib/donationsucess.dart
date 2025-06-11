import 'package:flutter/material.dart';
import 'login.dart';
import 'perfil.dart';
import 'visualizar_doacao.dart';
import 'materialeducativo.dart';
import 'quemsomos.dart';

class DonationSuccess extends StatefulWidget {
  const DonationSuccess({super.key});

  @override
  State<DonationSuccess> createState() => _DonationSuccessState();
}

class _DonationSuccessState extends State<DonationSuccess> {
  @override
  Widget build(BuildContext context) {
    // Exemplo de lista de doações fictícias
    final List<Doacao> doacoes = [
      Doacao(
        nomeDoador: 'João',
        material: 'Óleo',
        quantidade: 5,
        data: DateTime.now(),
      ),
      Doacao(
        nomeDoador: 'Maria',
        material: 'Óleo',
        quantidade: 10,
        data: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];

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
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Colors.white),
            onSelected: (value) {
              if (value == 'perfil') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Perfil()),
                );
              } else if (value == 'logoff') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              } else if (value == 'visualizar') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListDoador(doacoes: doacoes),
                  ),
                );
              } else if (value == 'material_educativo') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MaterialEducativoScreen()),
                );
              } else if (value == 'quem_somos') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuemSomosPage()),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'perfil', child: Text('Perfil')),
              PopupMenuItem(value: 'visualizar', child: Text('Visualizar Doações')),
              PopupMenuItem(value: 'material_educativo', child: Text('Material Educativo')),
              PopupMenuItem(value: 'quem_somos', child: Text('Quem Somos')),
              PopupMenuItem(value: 'logoff', child: Text('Logoff')),
            ],
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Doação Cadastrada com Sucesso!!!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF388E3C),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListDoador(doacoes: doacoes),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 4, 167, 59),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                  child: const Text(
                    'Acessar Lista de Coletores Interessados',
                    style: TextStyle(
                      letterSpacing: 1.5,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      
    );
  }
}



/*import 'package:flutter/material.dart';
import 'login.dart';
import 'perfil.dart';
import 'visualizar_doacao.dart';

class DonationSuccess extends StatefulWidget {
  const DonationSuccess({super.key});

  @override
  State<DonationSuccess> createState() => _DonationSuccessState();
}

class _DonationSuccessState extends State<DonationSuccess> {
  @override
  Widget build(BuildContext context) {
    // Exemplo de lista de doações fictícias
    final List<Doacao> doacoes = [
      Doacao(
        nomeDoador: 'João',
        material: 'Óleo',
        quantidade: 5,
        data: DateTime.now(),
      ),
      Doacao(
        nomeDoador: 'Maria',
        material: 'Óleo',
        quantidade: 10,
        data: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];

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
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Colors.white),
            onSelected: (value) {
              if (value == 'perfil') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Perfil()),
                );
              } else if (value == 'logoff') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              } else if (value == 'visualizar') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListDoador(doacoes: doacoes),
                  ),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'perfil', child: Text('Perfil')),
              PopupMenuItem(value: 'visualizar', child: Text('Visualizar Doações')),
              PopupMenuItem(value: 'logoff', child: Text('Logoff')),
            ],
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Doação Cadastrada com Sucesso!!!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF388E3C),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListDoador(doacoes: doacoes),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 4, 167, 59),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                  child: const Text(
                    'Acessar Lista de Coletores Interessados',
                    style: TextStyle(
                      letterSpacing: 1.5,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
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
            height: 40,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, color: Colors.white),
          ),
        ),
      ),
    );
  }
}*/



/*import 'package:flutter/material.dart';

class DonationSuccess extends StatefulWidget {
  const DonationSuccess({super.key});

  @override
  State<DonationSuccess> createState() => _DonationSuccessState();
}

class _DonationSuccessState extends State<DonationSuccess> {
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
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Colors.white),
            onSelected: (value) {
              if (value == 'perfil') {
                // Aqui você pode navegar para a tela de perfil
                // Exemplo:
                // Navigator.push(context, MaterialPageRoute(builder: (_) => PerfilScreen()));
              } else if (value == 'logoff') {
                // Aqui pode colocar a lógica de logoff
                // Exemplo:
                // Navigator.pushReplacementNamed(context, '/login');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'perfil',
                child: Text('Perfil'),
              ),
              const PopupMenuItem(
                value: 'logoff',
                child: Text('Logoff'),
              ),
            ],
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Doação Cadastrada com Sucesso!!!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF388E3C),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    // Aqui você coloca a navegação para a lista de coletores interessados
                    // Exemplo:
                    // Navigator.pushNamed(context, '/listaColetores');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 4, 167, 59),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                  child: const Text(
                    'Acessar Lista de Coletores Interessados',
                    style: TextStyle(
                      letterSpacing: 1.5,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
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
}*/
