
// ignore_for_file: avoid_print
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:AlugaFacil/models/Casa.dart';
import 'package:provider/provider.dart';
import '../providers/CasasProvider.dart';
import 'homepage_locador.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CasasProvider()),
      ],
      child: const MaterialApp(
        home: tela_CadastrarCasa(),
      ),
    );
  } 
}

class tela_CadastrarCasa extends homepage_locador {
  const tela_CadastrarCasa({Key? key}) : super(key: key, initialIndex: 1);

  @override
  State<tela_CadastrarCasa> createState() => _tela_CadastrarCasaState();
}

class _tela_CadastrarCasaState extends State<tela_CadastrarCasa> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;
  
  final ImagePicker _imagePicker = ImagePicker();
  late CasasProvider _casasProvider;
  final List<String> _imagePaths = [];

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();
  final TextEditingController _contatoController = TextEditingController();
  final TextEditingController _numQuartosController = TextEditingController();
  final TextEditingController _numBanheirosController = TextEditingController();
  final TextEditingController _comodidadesController = TextEditingController();
  
  
  bool _isTituloValid = true;
  bool _isDescricaoValid = true;
  bool _isEnderecoValid = true;
  bool _isPrecoValid = true;
  bool _isContatoValid = true;
   bool _isnumQuartos = true;
   bool _isnumBanheiros = true;
  bool _iscomodidades = true;

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

  Future<void> saveDataToFirestore(BuildContext context, String userId) async {
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;
    String endereco = _enderecoController.text;
    double preco = double.parse(_precoController.text);
    String contato = _contatoController.text;
    int numQuartos = int.parse(_numQuartosController.text);
    int numBanheiros = int.parse(_numBanheirosController.text); 
    String comodidades = _comodidadesController.text;
    
    String anuncioId = FirebaseFirestore.instance.collection('anuncios').doc().id;

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20.0),
              Text('Salvando dados...'),
            ],
          ),
        ),
      );

      CollectionReference casasCollection =
          FirebaseFirestore.instance.collection('anuncios');

      List<String> imageUrls = [];
      for (String imagePath in _imagePaths) {
        imageUrls.add(imagePath);
      }

      await casasCollection.add({
        'userId': userId,
        'titulo': titulo,
        'descricao': descricao,
        'endereco': endereco,
        'preco': preco,
        'contato': contato,
        'imagens': imageUrls,
        'anuncioId': anuncioId,
        'isFavorito': false,
        'numQuartos': numQuartos,
        'numBanheiros': numBanheiros,
        'comodidades': comodidades,
      });

      // Fechar o CircularProgressIndicator
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();

      // Exibir mensagem de sucesso
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Color(0xEB129933),
                size: 50.0,
              ),
              SizedBox(width: 5.0),
              Text('Sucesso'),
            ],
          ),
          content: const Text('Os dados foram salvos com sucesso.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const homepage_locador(initialIndex: 1)),
                );
              },
              child: const Text('Fechar'),
            ),
          ],
        ),
      );

      _imagePaths.clear();
      _tituloController.clear();
      _descricaoController.clear();
      _enderecoController.clear();
      _precoController.clear();
      _contatoController.clear();
      _numQuartosController.clear();
      _numBanheirosController.clear();
      _comodidadesController.clear();
      setState(() {});
    } catch (e) {
      print('Erro ao cadastrar casa: $e');
      print('Error saving data to Firestore: $e');

      // Fechar o CircularProgressIndicator
      Navigator.of(context).pop();

      // Exibir mensagem de erro
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.error_outlined,
                color: Color(0xFFF44336),
                size: 50.0,
              ),
              SizedBox(width: 5.0),
              Flexible(
                child: Text('Erro ao criar anúncio!'),
              ),
            ],
          ),
          content: const Text(
            'Ocorreu um erro ao salvar os dados. Por favor, tente novamente.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _casasProvider = Provider.of<CasasProvider>(context);
    final casasProvider = Provider.of<CasasProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4743FF),
        title: const Text('Cadastrar Casas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Título',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 0.0),
                TextFormField(
                  controller: _tituloController,
                  decoration: const InputDecoration(
                    hintText: 'Escreva um pequeno título para o anúncio.',
                    contentPadding: EdgeInsets.only(top: 22.0, bottom: 2),
                  ),
                  maxLines: 2,
                  validator: (titulo) {
                    if (titulo == null || titulo.isEmpty) {
                      return 'O título não pode ser vazio!';
                    }
                    return null;
                  },
                  onChanged: (_) {
                    setState(() {
                      _isTituloValid = _tituloController.text.isNotEmpty;
                    });
                    _validateForm();
                  },
                ),
                if (!_isTituloValid)
                  const Text(
                    'O título não pode ser vazio!',
                    style: TextStyle(
                      color: Color(0xFFF44336),
                    ),
                  ),
                const SizedBox(height: 20.0),
                const Text(
                  'Imagens',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5.0),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Escolha uma opção:'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _abrirCamera();
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: const Color(0xFFFFFFFF),
                                backgroundColor: const Color(0xA14743FF),
                              ),
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Tirar nova foto'),
                            ),
                            const SizedBox(height: 10.0),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _abrirGaleria();
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: const Color(0xFFFFFFFF),
                                backgroundColor: const Color(0xA14743FF),
                              ),
                              icon: const Icon(Icons.photo_library),
                              label: const Text('Escolher foto da galeria'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_a_photo),
                  label: const Text('Adicionar fotos'),
                ),
                const SizedBox(height: 10.0),

                SizedBox(
                  height: 100.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _imagePaths.length,
                    itemBuilder: (context, index) {
                      final imagePath = _imagePaths[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Dismissible(
                          key: Key(imagePath),
                          direction: DismissDirection.up,
                          onDismissed: (direction) {
                            setState(() {
                              _imagePaths.removeAt(index);
                            });
                          },
                          child: Stack(
                            children: [
                              Image.network(
                                imagePath, // Use imagePath diretamente
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: -16,
                                right: -14,
                                child: IconButton(
                                  icon: const Icon(Icons.close,
                                      color: Color(0xFFFFFFFF)),
                                  onPressed: () {
                                    setState(() {
                                      _imagePaths.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Descrição',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5.0),
                TextFormField(
                  controller: _descricaoController,
                  decoration: const InputDecoration(
                     hintText: 'Escreva uma descrição detalhada do imóvel.',
                    contentPadding: EdgeInsets.only(top: 22.0, bottom: 2),
                  ),
                  maxLines: 3,
                  validator: (descricao) {
                    if (descricao == null || descricao.isEmpty) {
                      return 'A descrição não pode ser vazia!';
                    }
                    return null;
                  },
                  onChanged: (_) {
                    setState(() {
                      _isDescricaoValid = _descricaoController.text.isNotEmpty;
                    });
                    _validateForm();
                  },
                ),
                if (!_isDescricaoValid)
                  const Text(
                    'A descrição não pode ser vazia!',
                    style: TextStyle(
                      color: Color(0xFFF44336),
                    ),
                  ),
                const SizedBox(height: 20.0),
                const Text(
                  'Endereço',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5.0),
                TextFormField(
                  controller: _enderecoController,
                  decoration: const InputDecoration(
                    hintText: 'Escreva o endereço completo do imóvel.',
                    contentPadding: EdgeInsets.only(top: 22.0, bottom: 2),
                  ),
                  maxLines: 3,
                  validator: (endereco) {
                    if (endereco == null || endereco.isEmpty) {
                      return 'O endereço não pode ser vazio!';
                    }
                    return null;
                  },
                  onChanged: (_) {
                    setState(() {
                      _isEnderecoValid = _enderecoController.text.isNotEmpty;
                    });
                    _validateForm();
                  },
                ),
                if (!_isEnderecoValid)
                  const Text(
                    'O endereço não pode ser vazio!',
                    style: TextStyle(
                      color: Color(0xFFF44336),
                    ),
                  ),
                const SizedBox(height: 20.0),
               
                const Text(
                  'Preço',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5.0),
                TextFormField(
                  controller: _precoController,
                  decoration: const InputDecoration(
                    hintText: 'Escreva o valor do aluguel.',
                    contentPadding: EdgeInsets.only(top: 22.0, bottom: 2),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (preco) {
                    if (preco == null || preco.isEmpty) {
                      return 'O preço não pode ser vazio!';
                    }
                    return null;
                  },
                  onChanged: (_) {
                    setState(() {
                      _isPrecoValid = _precoController.text.isNotEmpty;
                    });
                    _validateForm();
                  },
                ),
                if (!_isPrecoValid)
                  const Text(
                    'O preço não pode ser vazio!',
                    style: TextStyle(
                      color: Color(0xFFF44336),
                    ),
                  ),
                const SizedBox(height: 20.0),
                const Text(
                  'Contato',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5.0),
                TextFormField(
                  controller: _contatoController,
                  decoration: const InputDecoration(
                    hintText: 'Coloque o seu WhatsApp',
                    contentPadding: EdgeInsets.only(top: 22.0, bottom: 2),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (contato) {
                    if (contato == null || contato.isEmpty) {
                      return 'O contato não pode ser vazio!';
                    }
                    return null;
                  },
                  onChanged: (_) {
                    setState(() {
                      _isContatoValid = _contatoController.text.isNotEmpty;
                    });
                    _validateForm();
                  },
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Número de Quartos',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5.0),
                TextFormField(
                  controller: _numQuartosController,
                  keyboardType: TextInputType.number,
                   decoration: const InputDecoration(
                     hintText: 'Indique quantos quartos o imóvel possui.',
                    ),
                  validator: (numQuartos) {
                    if (numQuartos == null || numQuartos.isEmpty) {
                      return 'O número de quartos não pode ser vazio!';
                    }
                    return null;
                  },
                  onChanged: (_) {
                    setState(() {
                      _isnumQuartos = _numQuartosController.text.isNotEmpty;
                    });
                    _validateForm();
                  },
                ),
                  if (!_isnumQuartos)
                  const Text(
                    'O número de quartos não pode ser vazio!',
                    style: TextStyle(
                      color: Color(0xFFF44336),
                    ),
                  ),

                const SizedBox(height: 20.0),
                const Text(
                  'Número de Banheiros',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5.0),
                TextFormField(
                  controller: _numBanheirosController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                     hintText: 'Indique quantos banheiros o imóvel possui.',
                    ),
                  validator: (numBanheiros) {
                    if (numBanheiros == null || numBanheiros.isEmpty) {
                      return 'O número de banheiros não pode ser vazio!';
                    }
                    return null;
                  },
                  onChanged: (_) {
                    setState(() {
                      _isnumBanheiros = _numBanheirosController.text.isNotEmpty;
                    });
                    _validateForm();
                  },
                ),
                  if (!_isnumBanheiros)
                  const Text(
                    'O número de banheiros não pode ser vazio!',
                    style: TextStyle(
                      color: Color(0xFFF44336),
                    ),
                  ),

                const SizedBox(height: 20.0),
                const Text(
                  'Comodidades',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5.0),
                TextFormField(
                  controller: _comodidadesController,
                   decoration: const InputDecoration(
                     hintText: 'Indique se o imóvel tem área de lazer, quintal amplo, garagem ampla, piscina.',
                    ),
                    maxLines: 3,
                  validator: (comodidades) {
                    if (comodidades == null || comodidades.isEmpty) {
                      return 'O campo comodidades não pode ser vazio!';
                    }
                    return null;
                  },
                  onChanged: (_) {
                    setState(() {
                      _iscomodidades = _comodidadesController.text.isNotEmpty;
                    });
                    _validateForm();
                  },
                ),
                 if (!_iscomodidades)
                  const Text(
                    'O campo comodidades não pode ser vazio!',
                    style: TextStyle(
                      color: Color(0xFFF44336),
                    ),
                  ),
                ElevatedButton(
                  onPressed: _isFormValid
                      ? () async {
                          if (_isValidData()) {
                            String userId = FirebaseAuth.instance.currentUser!.uid;
                            String anuncioId = DateTime.now().millisecondsSinceEpoch.toString();

                            Casa novaCasa = Casa( 
                              userId: userId,
                              titulo: _tituloController.text,
                              imagens: _imagePaths.toList(),
                              descricao: _descricaoController.text,
                              endereco: _enderecoController.text,
                              preco: double.parse(_precoController.text),
                              contato: _contatoController.text,
                              numQuartos: int.parse(_numQuartosController.text),
                              numBanheiros: int.parse(_numBanheirosController.text),
                              comodidades: _comodidadesController.text,
                              anuncioId: anuncioId,
                              isFavorito: false,
                              id: '', 
                              user: '',
                              casa: '',
                              tipoConta: '',
                              
                            );

                            casasProvider.adicionarCasa(novaCasa, userId);
                            saveDataToFirestore(context, userId);
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Row(
                                  children: [
                                    Icon(
                                      Icons.error_outlined,
                                      color: Color(0xFFF44336),
                                      size: 50.0,
                                    ),
                                    SizedBox(width: 5.0),
                                    Text('Erro de validação!'),
                                  ],
                                ),
                                content: const Text(
                                  'Por favor, preencha todos os campos corretamente.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xF25F5FFF)),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFFFFFFF)),
                  ),
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _isTituloValid &&
          _isDescricaoValid &&
          _isEnderecoValid &&
          _isPrecoValid &&
          _isContatoValid &&
          _isnumQuartos &&
          _isnumBanheiros &&
          _iscomodidades;
    });
  }

  bool _isValidData() {
    return _tituloController.text.isNotEmpty &&
        _imagePaths.isNotEmpty &&
        _descricaoController.text.isNotEmpty &&
        _enderecoController.text.isNotEmpty &&
        _precoController.text.isNotEmpty &&
        _contatoController.text.isNotEmpty &&
        _numQuartosController.text.isNotEmpty &&
        _numBanheirosController.text.isNotEmpty &&
        _comodidadesController.text.isNotEmpty;
  }

  @override
  void dispose() {
    _imagePaths.clear();
    super.dispose();
  }
}
