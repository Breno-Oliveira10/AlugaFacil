import 'package:AlugaFacil/widgets/drawerLocatario.dart';
import 'package:flutter/material.dart';


// ignore: camel_case_types
class tela_InstrucoesLocatario extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  tela_InstrucoesLocatario({Key? key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF4743FF),
        title: const Text(
          'Instruções',
          style: TextStyle(color: Color.fromARGB(225, 255, 255, 255)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: drawerLocatario(scaffoldKey: _scaffoldKey),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Instruções de como usar o app',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                '1- Como filtrar os anúncios no app?',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                'R= Para tornar sua busca mais específica, acesse a página "Filtro" no menu inferior. ' 
                'Na tela de filtros, insira as informações desejadas e, em seguida, '
                'clique na lupa ao lado para visualizar os resultados.',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                '2- Como Favoritar um anúncio no app?',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                'Para favoritar um anúncio, vá para a página "Lista" no menu inferior. ' 
                'Escolha o anúncio desejado e toque no ícone de coração.'
                'Todos os anúncios favoritos podem ser visualizados na página "Favoritos".',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                '3- Como editar o meu perfil?',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                'R= Para editar o perfil, toque nas três barrinhas no canto superior esquerdo '
                'para abrir o menu lateral. Em seguida, clique no ícone de lápis com o nome "Editar Perfil" '
                ' e preencha todos os campos para atualizar suas informações.',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 10.0),
              Align(
                alignment: Alignment.bottomRight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
