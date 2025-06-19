import 'package:flutter/material.dart';
import 'package:greencode/inicio.dart';
import 'package:greencode/redefinirpasswordfinale.dart';
import 'package:greencode/inserttoken.dart';
import 'package:greencode/materialeducativo.dart';
import 'package:greencode/quemsomos.dart';
import 'package:greencode/suporte.dart'; // ✅ Import da nova tela

void main() {
  runApp(
    MaterialApp(
      title: 'Greencode',
      home: const Inicio(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/inserirToken': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return InserirToken(email: args['email'], token: args['token']);
        },
        '/redefinirNovaSenha': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return RedefinirNovaSenha(email: args['email']);
        },
        '/material': (context) => const MaterialEducativoScreen(),
        '/quem_somos': (context) => const QuemSomosPage(),
        '/suporte': (context) => const SuportePage(), // ✅ Rota do suporte adicionada
      },
    ),
  );
}


/*import 'package:flutter/material.dart';
import 'package:greencode/inicio.dart';
import 'package:greencode/redefinirpasswordfinale.dart'; // contém RedefinirNovaSenha
import 'package:greencode/inserttoken.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Greencode',
      home: const Inicio(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/inserirToken': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return InserirToken(email: args['email'], token: args['token']);
        },
        '/redefinirNovaSenha': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return RedefinirNovaSenha(email: args['email']);
        },
      },
    ),
  );
}*/
