import 'package:AlugaFacil/widgets/drawerLocatario.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AlugaFacil/models/Casa.dart';
import 'package:AlugaFacil/providers/CasasProvider.dart';
import 'package:AlugaFacil/providers/UserProvider.dart';
import 'package:AlugaFacil/tela_Usuario/tela_detalhesLocatario.dart';
import 'package:provider/provider.dart';

class tela_filtrosLocatario extends StatefulWidget {
  //Construtor
  // final Casa casa;
  // tela_filtrosLocatario({required this.casa});

  @override
  _TelaFiltrosLocatarioState createState() => _TelaFiltrosLocatarioState();
}

class _TelaFiltrosLocatarioState extends State<tela_filtrosLocatario> {
  Casa? _casaAtualizada;
  List<Map<String, dynamic>> todasCasas = [];
  List<Casa> casasFiltradas = [];

  String mensagemResultado = '';
  TextEditingController pesquisaController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void fetchCasas() async {
    try {
      final result = await FirebaseFirestore.instance.collection('anuncios').get();

      setState(() {
        todasCasas = result.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      print('Erro ao carregar casas: $e');
    }
  }

  void searchCasas(String query) {
    setState(() {
      casasFiltradas = todasCasas
          .where((casa) =>
              casa['imagens'].toString().contains(query) ||
              casa['titulo'].toString().contains(query) ||
              casa['descricao'].toString().contains(query) ||
              casa['endereco'].toString().contains(query) ||
              casa['preco'].toString().contains(query) ||
              casa['contato'].toString().contains(query) ||
              casa['numQuartos'].toString().contains(query) ||
              casa['numBanheiros'].toString().contains(query) ||
              casa['comodidades'].toString().contains(query))
          .map((casa) => Casa.fromMap(casa)) // Mapeia para instâncias de Casa
          .toList();

      mensagemResultado = casasFiltradas.isEmpty ? 'Nenhum resultado encontrado.' : '';
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCasas();
  }

  @override
  Widget build(BuildContext context) {
    final casasProvider = Provider.of<CasasProvider>(context, listen: false);
   // final userprovider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      key: _scaffoldKey,
      
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF4743FF),
        title: const Text("Pesquisa de casas"),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      drawer: drawerLocatario(scaffoldKey: _scaffoldKey),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: pesquisaController,
                    decoration: const InputDecoration(
                      hintText: "Pesquise por preço, endereço...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    if (pesquisaController.text.isNotEmpty) {
                      searchCasas(pesquisaController.text);
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Resultados: ${casasFiltradas.length}"),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: casasFiltradas.length,
                    itemBuilder: (context, index) {
                      Casa casa = casasFiltradas[index];
                      //Casa casa = casasFiltradas[index] as Casa;
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 8, bottom: 0, right: 8, top: 6),
                        child: Card(
                          color: const Color(0xDFFFE7EB),
                          child: InkWell(
                            onTap: () async {
                              _casaAtualizada = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  //builder: (context) => tela_detalhesLocatario(casa: Casa.fromMap(casasFiltradas[index])),
                                  builder: (context) =>
                                      tela_detalhesLocatario(casa: casa),
                                ),
                              );
                              // Inicialize 'query' com o valor atual do pesquisaController
                             // String query = pesquisaController.text;
                              if (_casaAtualizada != null) {
                                _atualizarLista(casasProvider);
                              }
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 310,
                                  height: 165,
                                  child: Padding(
                                    padding: const EdgeInsets.all(9.0),
                                    child: casasFiltradas[index]
                                            .imagens
                                            .isNotEmpty
                                        ? Image.network(
                                            casasFiltradas[index].imagens.first,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          )
                                        : const Center(
                                            child: Text(
                                                'Nenhuma foto adicionada.'),
                                          ),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "Título: ${casasFiltradas[index].titulo}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    "Descrição: ${casasFiltradas[index].descricao}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: Container(
                                    width: 50,
                                    height: 50,
                                    child: Center(
                                      child: IconButton(
                                        icon: casa.isFavorito
                                            ? const Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                              )
                                            : const Icon(Icons.favorite_border),
                                        onPressed: () async {
                                          final userprovider = 
                                              Provider.of<UserProvider>(context,
                                                  listen: false);
                                          casasProvider.favoritarCasa(
                                              casa.anuncioId,
                                              casa,
                                              userprovider);
                                          setState(() {
                                            casa.isFavorito = true;
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
                  ),
                ),
                Visibility(
                  visible: mensagemResultado.isNotEmpty,
                  child: Center(
                  child: Text(
                          mensagemResultado,
                          style: const TextStyle(fontSize: 16.0),
                   ),
                ),
               ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  void _atualizarLista(CasasProvider casasProvider) async {
    if (_casaAtualizada != null) {
      casasProvider.atualizarCasa(_casaAtualizada!);
      _casaAtualizada = null;
    }
  }

}
