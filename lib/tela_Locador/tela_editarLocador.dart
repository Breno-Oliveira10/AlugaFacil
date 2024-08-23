// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:AlugaFacil/models/Casa.dart';
import 'package:AlugaFacil/providers/CasasProvider.dart';
import 'package:provider/provider.dart';

class tela_editarLocador extends StatefulWidget {
  final Casa casa;

  const tela_editarLocador({Key? key, required this.casa}) : super(key: key);

  @override
  _EditarLocadorScreenState createState() => _EditarLocadorScreenState();
}

class _EditarLocadorScreenState extends State<tela_editarLocador> {
  late TextEditingController _tituloController;
  late TextEditingController _descricaoController;
  late TextEditingController _enderecoController;
  late TextEditingController _precoController;
  late TextEditingController _contatoController;
  late TextEditingController _numQuartosController;
  late TextEditingController _numBanheirosController;
  late TextEditingController _comodidadesController;

  late CasasProvider _casasProvider;
  List<String> _imagePaths = [];
  final ImagePicker _imagePicker = ImagePicker();

  late String
      anuncioIdSelecionado; // Armazene o "anuncioId" do anúncio escolhido pelo usuário

  @override
  void initState() {
    super.initState();
    _inicializarControladores();
    _casasProvider = Provider.of<CasasProvider>(context, listen: false);
  }

  void _inicializarControladores() {
    _tituloController = TextEditingController(text: widget.casa.titulo);
    _descricaoController = TextEditingController(text: widget.casa.descricao);
    _enderecoController = TextEditingController(text: widget.casa.endereco);
    _precoController =
        TextEditingController(text: widget.casa.preco.toString());
    _contatoController = TextEditingController(text: widget.casa.contato);
    _numQuartosController =
        TextEditingController(text: widget.casa.numQuartos.toString());
    _numBanheirosController =
        TextEditingController(text: widget.casa.numBanheiros.toString());
    _comodidadesController =
        TextEditingController(text: widget.casa.comodidades);
    _imagePaths = List.from(widget.casa.imagens);
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _enderecoController.dispose();
    _precoController.dispose();
    _contatoController.dispose();
    _numQuartosController.dispose();
    _numBanheirosController.dispose();
    _comodidadesController.dispose();
    super.dispose();
  }

  Future<void> _abrirCamera() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      String? imageUrl = await uploadImageToFirebase(File(pickedFile.path));
      if (imageUrl != null) {
        _casasProvider
            .adicionarImagens([..._casasProvider.imagePaths, imageUrl]);
        _imagePaths.add(imageUrl);
        setState(() {});
      }
    }
  }

  Future<void> _abrirGaleria() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String? imageUrl = await uploadImageToFirebase(File(pickedFile.path));
      if (imageUrl != null) {
        _casasProvider
            .adicionarImagens([..._casasProvider.imagePaths, imageUrl]);
        _imagePaths.add(imageUrl);
        setState(() {});
      }
    }
  }

  Future<String?> uploadImageToFirebase(File imageFile) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference = storage.ref().child('images/$imageName.png');
      await storageReference.putFile(imageFile);

      // Obtenha a URL da imagem após o upload
      String imageUrl = await storageReference.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Erro ao fazer upload da imagem para o Firebase Storage: $e');
      return null;
    }
  }

  Future<void> atualizarCasaNoFirestore(
      String userId, String anuncioId, Casa casaAtualizada) async {
    try {
      final anunciosCollection =
          FirebaseFirestore.instance.collection('anuncios');

      final QuerySnapshot querySnapshot = await anunciosCollection
          .where('userId', isEqualTo: userId)
          .where('anuncioId', isEqualTo: anuncioId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        await anunciosCollection
            .doc(documentSnapshot.id)
            .update(casaAtualizada.toMap());

        print('Anúncio atualizado com sucesso no Firestore');

        // Atualiza o estado local imediatamente após a alteração no Firestore
        final casasProvider =
            Provider.of<CasasProvider>(context, listen: false);
        casasProvider.atualizarCasa(casaAtualizada);

        // Notifica os ouvintes do Provider sobre a atualização
        //notifyListeners();
      } else {
        print('Aviso: Nenhum documento encontrado para atualização');
      }
    } catch (e) {
      print('Erro ao atualizar o anúncio no Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    CasasProvider casasProvider =
        Provider.of<CasasProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Casa'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Título:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _tituloController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Imagens:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Escolha uma opção:'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _abrirCamera();
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Color(0xFFFFFFFF),
                              backgroundColor: Color(0xA14743FF),
                            ),
                            icon: Icon(Icons.camera_alt),
                            label: Text('Tirar nova foto'),
                          ),
                          SizedBox(height: 10.0),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _abrirGaleria();
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Color(0xFFFFFFFF),
                              backgroundColor: Color(0xA14743FF),
                            ),
                            icon: Icon(Icons.photo_library),
                            label: Text('Escolher foto da galeria'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xF25F5FFF),
                  foregroundColor: Color(0xFFFFFFFF),
                ),
                child: Text('Adicionar Imagens'),
              ),
              Container(
                height: 100.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _imagePaths.length,
                  itemBuilder: (context, index) {
                    final imagePath = _imagePaths[index];
                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Image.network(
                            imagePath, // URL da imagem
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: -16,
                          right: -14,
                          child: IconButton(
                            icon: Icon(Icons.close, color: Color(0xFFFFFFFF)),
                            onPressed: () {
                              setState(() {
                                _imagePaths.removeAt(index);
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Descrição:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _descricaoController,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Endereço:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _enderecoController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Preço:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _precoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Contato:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _contatoController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Números de quartos:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _numQuartosController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Números de banheiros:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _numBanheirosController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Comodidades:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _comodidadesController,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  Casa? casaAtualizada = await _salvarAlteracoes(context);

                  // Adicione o código para obter userId e anuncioId
                  String userId = FirebaseAuth.instance.currentUser!.uid;
                  String anuncioId = casaAtualizada!.anuncioId;

                  await atualizarCasaNoFirestore(
                      userId, anuncioId, casaAtualizada);

                  Navigator.pop(context, casaAtualizada);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xF25F5FFF),
                  foregroundColor: Color(0xFFFFFFFF),
                ),
                child: Text('Salvar alterações'),
              ),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () {
                  casasProvider.atualizarCasa(widget.casa);
                  Navigator.pop(context); // Voltar para a tela anterior
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xF25F5FFF),
                  foregroundColor: Color(0xFFFFFFFF),
                ),
                child: Text('Cancelar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Casa?> _salvarAlteracoes(BuildContext context) async {
    final casasProvider = Provider.of<CasasProvider>(context, listen: false);

    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;
    String endereco = _enderecoController.text;
    double preco = double.tryParse(_precoController.text) ?? 0.0;
    String contato = _contatoController.text;

    int numQuartos = int.parse(_numQuartosController.text);
    int numBanheiros = int.parse(_numBanheirosController.text);
    String comodidades = _comodidadesController.text;

    Casa casaAtualizada = Casa(
      tipoConta: widget.casa.tipoConta,
      id: widget.casa.id,
      titulo: titulo,
      descricao: descricao,
      endereco: endereco,
      preco: preco,
      contato: contato,
      imagens: _imagePaths,
      userId: widget.casa.userId,
      user: widget.casa.user,
      casa: widget.casa.casa,
      anuncioId: widget.casa.anuncioId,
      isFavorito: widget.casa.isFavorito,
      comodidades: comodidades,
      numBanheiros: numBanheiros,
      numQuartos: numQuartos,
    );

    casasProvider.atualizarCasa(casaAtualizada);
    return casaAtualizada;
  }
}
