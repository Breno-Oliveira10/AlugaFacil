// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:AlugaFacil/models/Casa.dart';
import 'package:AlugaFacil/providers/CasasProvider.dart';
import 'package:AlugaFacil/tela_Locador/homepage_locador.dart';
import 'package:AlugaFacil/tela_Locador/tela_editarLocador.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: must_be_immutable, camel_case_types
class tela_DetalhesLocador extends homepage_locador {
  Casa casa;

  tela_DetalhesLocador({Key? key, required this.casa, initialIndex = 1})
      : super(key: key);

  @override
  _DetalhesCasaScreenState createState() => _DetalhesCasaScreenState();
}

class _DetalhesCasaScreenState extends State<tela_DetalhesLocador> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<String> imagePaths = widget.casa.imagens;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Casa'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              // editarNoFirestore
              Casa casaAtualizada = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => tela_editarLocador(casa: widget.casa),
                ),
              );
              // ignore: unnecessary_null_comparison
              if (casaAtualizada != null) {
                setState(() {
                  widget.casa = casaAtualizada;
                });
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Confirmação'),
                  content: Text('Deseja realmente excluir este anúncio?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Fechar o AlertDialog
                      },
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        final userId =
                            FirebaseAuth.instance.currentUser?.uid;
                        if (userId != null) {
                          final anuncioId = widget.casa.anuncioId;
                          final casasProvider =  Provider.of<CasasProvider>(context, listen: false); 
                          casasProvider.excluirCasa(anuncioId); // Chama a função para excluir
                          Navigator.pop(context); // Fecha o AlertDialog
                          Navigator.pop(context); // Fecha a tela de detalhes
                        } else {
                          print('Usuário não autenticado.');
                        }
                      },
                      child: Text('Excluir'),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Container(
              height: 310,
              child: imagePaths.isEmpty
                  ? Center(
                      child: Text('Nenhuma foto adicionada.'),
                    )
                  : PageView.builder(
                      itemCount: imagePaths.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        String imageUrl = imagePaths[index];
                        return InkWell(
                          onTap: () {
                            // Função para lidar com o clique na imagem
                            _mostrarImagemCompleta(imageUrl, imagePaths, _currentPageIndex);
                          },
                          child: LayoutBuilder(
                            builder:
                                (BuildContext context, BoxConstraints constraints) {
                              return SizedBox(
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.fitWidth,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),

            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < imagePaths.length; i++)
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i == _currentPageIndex
                            ? Color(0xFF000000)
                            : Color(0xFF977474),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 1.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Título:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.90,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    widget.casa.titulo,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 6.0), //espaçamento entre um campo e outro
                  Text(
                    'Descrição:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.90,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    widget.casa.descricao,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 6.0),
                  Text(
                    'Endereço:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.90,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    widget.casa.endereco,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 6.0),
                  Text(
                    'Preço:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.90,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'R\$ ${widget.casa.preco.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 6.0),
                  Text(
                    'Contato:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.90,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    widget.casa.contato,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 6.0),
                  Text(
                    'Número de quartos:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.90,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    widget.casa.numQuartos.toString(),
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 6.0),
                  Text(
                    'Número de banheiros:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.90,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    widget.casa.numBanheiros.toString(),
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 6.0),
                  Text(
                    'Comodidades:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.90,
                    ),
                  ),
                  SizedBox(height: 5.0), // espaçamento entre texto e titulo
                  Text(
                    widget.casa.comodidades.toString(),
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

void _mostrarImagemCompleta(String imageUrl, List<String> imagePaths, int currentIndex) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 350,
              child: PageView.builder(
                itemCount: imagePaths.length,
                controller: PageController(initialPage: currentIndex),
                onPageChanged: (index) {
                  setState(() {
                    _currentPageIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  String imageUrl = imagePaths[index];
                  return Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < imagePaths.length; i++)
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                  ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

}


