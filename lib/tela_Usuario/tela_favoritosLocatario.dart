// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, camel_case_types, library_private_types_in_public_api

import 'package:AlugaFacil/widgets/drawerLocatario.dart';
import 'package:flutter/material.dart';
import 'package:AlugaFacil/models/Casa.dart';
import 'package:AlugaFacil/providers/CasasProvider.dart';
import 'package:AlugaFacil/providers/UserProvider.dart';
import 'package:provider/provider.dart';


class tela_favoritosLocatario extends StatefulWidget {
  const tela_favoritosLocatario({super.key});

  @override
  _Tela_favoritosLocatarioState createState() => _Tela_favoritosLocatarioState();
}

class _Tela_favoritosLocatarioState extends State<tela_favoritosLocatario> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF4743FF),
        title: const Text('Anúncios Favoritos'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _openDrawer();
          },
        ),
      ),
      drawer: drawerLocatario(scaffoldKey: _scaffoldKey),
      body: Consumer<CasasProvider>(
        builder: (context, casasProvider, _) {
          
          List<Casa> casasFavoritas = casasProvider.casasFavoritas;

          if (casasFavoritas.isEmpty) {
            return Center(
              child: Text('Nenhum anúncio favorito.'),
            );
          }

          return ListView.builder(
            itemCount: casasFavoritas.length,
            itemBuilder: (context, index) {
              Casa casa = casasFavoritas[index];
              String titulo = casa.titulo;
              if (titulo.length > 30){
                   titulo = '${titulo.substring(0, 30)}...';
              }
              String descricao = casa.descricao;
              if (descricao.length > 30) {
                descricao = '${descricao.substring(0, 30)}...';
              }

              return Container(
                width: 80,
                height: 90,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Card(
                    color: Color(0xFFEBEBF0),
                    child: ListTile(
                      leading: Container(
                        width: 100,
                        height: 100,
                        child: casa.imagens.isNotEmpty
                            ? Image.network(
                                casa.imagens.first,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : Center(
                                child: Text('Nenhuma foto adicionada.'),
                              ),
                      ),
                     // title: Text(casa.titulo),
                      title:  Wrap(
                            children: [
                              Text(
                                titulo,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ), 
                      subtitle: Wrap(
                        children: [
                          Text(
                            descricao,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                       trailing: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                           final userprovider = Provider.of<UserProvider>(context, listen: false);
                          setState(() {
                           //casasProvider.toggleFavorito(casa.id, false);
                            casasProvider.desfavoritarCasa(casa.anuncioId, casa, userprovider);
                            // Atualizar a tela após a remoção
                          });
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
