
// // ignore_for_file: prefer_const_constructors, unnecessary_null_comparison, avoid_print, use_rethrow_when_possible, camel_case_types, library_private_types_in_public_api, duplicate_ignore, use_build_context_synchronously

import 'package:AlugaFacil/widgets/drawerLocatario.dart';
import 'package:flutter/material.dart';
import 'package:AlugaFacil/models/Casa.dart';
import 'package:AlugaFacil/providers/CasasProvider.dart';
import 'package:AlugaFacil/providers/UserProvider.dart';
import 'package:AlugaFacil/tela_Usuario/tela_detalhesLocatario.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
class tela_listaLocatario extends StatefulWidget {
  const tela_listaLocatario({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _Tela_listaLocatarioState createState() => _Tela_listaLocatarioState();
}

// ignore: camel_case_types
class _Tela_listaLocatarioState extends State<tela_listaLocatario> {
  Casa? _casaAtualizada;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<void>? _carregamentoCasasFuture;

  @override
  void initState() {
    super.initState();
    _carregamentoCasasFuture = carregarCasas();
  }

  Future<void> carregarCasas() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final casasProvider = Provider.of<CasasProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await casasProvider.carregarCasas(userProvider, prefs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF4743FF),
        title: const Text('Lista de casas'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      drawer: drawerLocatario(scaffoldKey: _scaffoldKey),
     
      body: Consumer<CasasProvider>(
        builder: (context, casasProvider, _) {
          return FutureBuilder<void>(
            future: _carregamentoCasasFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // ignore: prefer_const_constructors
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Erro ao carregar casas: ${snapshot.error}');
              } else {
                final casas = casasProvider.casas;

                if (casas.isEmpty) {
                  return const Center(child: Text('Nenhuma casa cadastrada.'));
                }

                return ListView.builder(
                  itemCount: casas.length,
                  itemBuilder: (context, index) {
                    final casa = casas[index];
                    final titulo = encurtarTexto(casa.titulo, 30);
                    final descricao = encurtarTexto(casa.descricao, 42);        
                   return Padding(
                        // ignore: prefer_const_constructors
                        padding: EdgeInsets.only(left: 8, bottom: 0, right: 8, top: 6),// altera o espaçamento do card 
                          child: Card(
                      color: const Color(0xDFFFE7EB),
                      child: InkWell(
                        onTap: () async {
                          _casaAtualizada = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>tela_detalhesLocatario(casa: casa),
                            ),
                          );
                          if (_casaAtualizada != null) {
                            _atualizarLista(casasProvider);
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 310, // altera a largura das fotos dentro do card
                              height: 165,
                              child: Padding(
                                padding: const EdgeInsets.all(9.0),
                                child: casa.imagens.isNotEmpty
                                    ? Image.network(
                                        casa.imagens.first,
                                        width: 100,//altera a largura das fotos dentro do card
                                        height: 100,
                                        fit: BoxFit.cover, //altera a largura das fotos dentro do card
                                      )
                                    : const Center(
                                        child: Text('Nenhuma foto adicionada.'),
                                      ),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                titulo,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                descricao,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Container(
                                width: 50,
                                height: 50,
                                child: Center(
                                  child: IconButton(
                                      icon: casa.isFavorito
                                        ? const Icon(Icons.favorite, color: Colors.red)
                                        : const Icon(Icons.favorite_border),
                                    onPressed: () {// instancia do userprovider
                                    final userprovider = Provider.of<UserProvider>(context, listen: false);
                                        setState(() {
                                          casasProvider.favoritarCasa(casa.anuncioId, casa, userprovider);
                                           // Usando o anuncioId associado à casa
                                       });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                   );

                   
                  },
                );
              }
            },
          );
        },
      ),
    );
  }

  String encurtarTexto(String texto, int maxLength) {
    return texto.length > maxLength
        ? '${texto.substring(0, maxLength)}...'
        : texto;
  }

  void _atualizarLista(CasasProvider casasProvider) async {
    if (_casaAtualizada != null) {
      casasProvider.atualizarCasa(_casaAtualizada!);
      _casaAtualizada = null;
    }
  }
}
