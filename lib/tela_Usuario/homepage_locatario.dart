
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:AlugaFacil/tela_Usuario/tela_ListaLocatario.dart';
import 'package:AlugaFacil/tela_Usuario/tela_favoritosLocatario.dart';
import 'package:AlugaFacil/tela_Usuario/tela_InstrucoesLocatario.dart';
import 'package:AlugaFacil/tela_Usuario/tela_filtrosLocatario.dart';

// ignore: camel_case_types
class homepage_locatario extends StatefulWidget {
  final int initialIndex;

  const homepage_locatario({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<homepage_locatario> createState() => _homepage_locatarioState();
}

// ignore: camel_case_types
class _homepage_locatarioState extends State<homepage_locatario> {
  int _paginaAtual = 0;

  @override
  void initState() {
    super.initState();
    _paginaAtual = widget.initialIndex;
  }

  void aoMudarDeAba(int indice) {
    setState(() {
      _paginaAtual = indice;
    });
  }

  final List<Widget> _telas = [
    tela_InstrucoesLocatario(), // Índice 0
    tela_listaLocatario(), // Índice 1
    tela_filtrosLocatario(), // Índice 2
    tela_favoritosLocatario(), // Índice 3
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _telas[_paginaAtual],
      bottomNavigationBar: Theme(
        data: ThemeData(
          canvasColor: Color(0xFF4743FF),
        ),
        child: BottomNavigationBar(
          currentIndex: _paginaAtual,
          onTap: aoMudarDeAba,
          selectedItemColor: Color(0xFFFFFFFF),
          unselectedItemColor: Color.fromARGB(255, 248, 241, 241).withAlpha(165),
          showUnselectedLabels: true,  // Adicione esta linha
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Instruções',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_rounded),
              label: 'Lista',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.filter_alt),
              label: 'Filtro',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favoritos',
            ),
          ],
        ),
      ),
    );
  }
}

