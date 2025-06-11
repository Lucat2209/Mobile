import 'package:flutter/material.dart';
import 'package:greencode/inicio.dart';
import 'package:greencode/redefinirpasswordfinale.dart'; // RedefinirNovaSenha
import 'package:greencode/inserttoken.dart';
import 'package:greencode/materialeducativo.dart';
import 'package:greencode/quemsomos.dart'; // <-- Certifique-se de que essas classes existem e estão corretas

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
        '/material': (context) => const MaterialEducativoScreen(), // ✅ Adicionada rota
        '/quem_somos': (context) => const QuemSomosPage(),       // ✅ Adicionada rota
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
