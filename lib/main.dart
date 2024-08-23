// ignore_for_file: prefer_const_constructors, equal_keys_in_map, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:AlugaFacil/models/Casa.dart';
import 'package:AlugaFacil/providers/CasasProvider.dart';
import 'package:AlugaFacil/providers/UserProvider.dart';
import 'package:AlugaFacil/tela_Locador/homepage_locador.dart';
import 'package:AlugaFacil/tela_Locador/tela_CadastrarCasa.dart';
import 'package:AlugaFacil/tela_Locador/tela_DetalhesLocador.dart';
import 'package:AlugaFacil/tela_Locador/tela_DicasFotografia.dart';
import 'package:AlugaFacil/tela_Locador/tela_InstrucoesLocador.dart';
import 'package:AlugaFacil/tela_Locador/tela_ListaLocador.dart';
import 'package:AlugaFacil/tela_Usuario/homepage_locatario.dart';
import 'package:AlugaFacil/tela_Usuario/tela_InstrucoesLocatario.dart';
import 'package:AlugaFacil/tela_Usuario/tela_ListaLocatario.dart';
import 'package:AlugaFacil/tela_Usuario/tela_detalhesLocatario.dart';
import 'package:AlugaFacil/tela_Usuario/tela_favoritosLocatario.dart';
import 'package:AlugaFacil/tela_Usuario/tela_filtrosLocatario.dart';
import 'package:AlugaFacil/tela_iniciais/esqueceu_senha.dart';
import 'package:AlugaFacil/tela_iniciais/tela_SplashScreen.dart';
import 'package:AlugaFacil/tela_iniciais/tela_bemvindo.dart';
import 'package:AlugaFacil/tela_iniciais/tela_cadastro.dart';
import 'package:AlugaFacil/tela_iniciais/tela_login.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final casasProvider = CasasProvider();
  final userProvider = UserProvider();
 
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: userProvider),
        ChangeNotifierProvider.value(value: casasProvider),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Casa? casa;

  @override
  Widget build(BuildContext context) {
        
    return MaterialApp(
      title: 'Aluga Fácil',
      theme: ThemeData(
        primarySwatch: Colors.blue, // cor azul bem clarinho 0xFF2196F3
      ),
      home: tela_SplashScreen(),
    
      routes: {
        '/tela_bemvindo': (context) => tela_bemvindo(),
        '/tela_login': (context) => tela_login(),
        '/tela_cadastro': (context) => tela_cadastro(),
        'esqueceu_senha':(context) => esqueceu_senha(),
        '/homepage_locador': (context) => homepage_locador(),
        '/tela_Instrucoes': (context) => tela_InstrucoesLocador(),
        '/tela_ListaLocador': (context) => tela_ListaLocador(),
        'tela_DicasFotografia':(context) => tela_DicasFotografia(),
        '/tela_CadastrarCasa': (context) => tela_CadastrarCasa(),
        '/tela_DetalhesLocador': (context) => tela_DetalhesLocador(casa: casa!),
        '/homepage_locatario':(context) => homepage_locatario(),
        'tela_InstrucoesLocatario':(context) => tela_InstrucoesLocatario(),
        'tela_listaLocatario':(context) =>  tela_listaLocatario(),
        'tela_detalhesLocatario':(context) => tela_detalhesLocatario(casa: casa!),
        'tela_filtrosLocatario':(context) => tela_filtrosLocatario(),
        'tela_favoritosLocatario':(context) => tela_favoritosLocatario(),
      },
    );
  }
}
