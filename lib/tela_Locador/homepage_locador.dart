// ignore_for_file: camel_case_types, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:AlugaFacil/tela_Locador/tela_InstrucoesLocador.dart';
import 'package:AlugaFacil/tela_Locador/tela_ListaLocador.dart';
import 'package:AlugaFacil/tela_Locador/tela_DicasFotografia.dart';


class homepage_locador extends StatefulWidget { 
  final int initialIndex;

  const homepage_locador({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<homepage_locador> createState() => _homepage_locadorState();
}

class _homepage_locadorState extends State<homepage_locador> {
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
    tela_InstrucoesLocador(),
    tela_ListaLocador(),
    tela_DicasFotografia(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _telas[_paginaAtual],
     
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaAtual,
        onTap: aoMudarDeAba,
        backgroundColor: Color(0xFF4743FF),
        selectedItemColor: Color(0xFFFFFFFF),
        unselectedItemColor: Colors.white.withAlpha(165),
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
            icon: Icon(Icons.lightbulb),
            label: 'Dicas',
          ),
        ],
      ),
    );
  }
}