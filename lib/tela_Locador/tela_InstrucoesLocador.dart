// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:AlugaFacil/tela_Locador/tela_CadastrarCasa.dart';
import 'package:AlugaFacil/widgets/drawerLocador.dart';



// ignore: camel_case_types
class tela_InstrucoesLocador extends StatelessWidget {
  tela_InstrucoesLocador({super.key});

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
          style: TextStyle(color: Color(0xFFFFFFFF)),
        
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: (){
              _scaffoldKey.currentState?.openDrawer();
            //  _openDrawer(context);
          },
        ),
      ),
        drawer: drawerLocador(scaffoldKey: _scaffoldKey),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Instruções de como anunciar uma casa no app',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                '1- Como inserir um anúncio?',
              ),
              const Text(
                'R= Para inserir um anúncio, clique no botão azul com um "+" no canto inferior direito. Em seguida, preencha as informações da casa que deseja anunciar.',
              ),
              const SizedBox(height: 10.0),
              const Text(
                '2- Como editar um anúncio?',
              ),
              const Text(
                'R= Para editar um anúncio, vá para a página "Lista" no menu inferior, escolha e toque no anúncio desejado. '
                'Na tela de detalhes, clique no ícone de lápis no canto superior direito para acessar a tela de edição e faça as alterações necessárias. ',
              ),
              const SizedBox(height: 10.0),
              const Text(
                '3- Como excluir um anúncio?',
              ),
              const Text(
                'R= Para excluir um anúncio, siga os mesmos passos da pergunta 2, porém, em vez de usar o ícone de lápis, clique no ícone de lixeira ao lado dele. Ao fazer isso, o anúncio selecionado será apagado.',
              ),
              const SizedBox(height: 10.0),
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  backgroundColor: const Color(0xFF4743FF),
                  onPressed: () {
                   
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => tela_CadastrarCasa(),
          
                        ),
                    );
                  },
                  child: const Icon(
                    Icons.add,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
