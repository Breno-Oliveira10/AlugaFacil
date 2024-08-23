
class Casa {
  String titulo;
  List<String> imagens;
  String descricao;
  String endereco;
  double preco;  
  String contato;
  String id; 
  String casa;
  bool isFavorito; 
  String userId;
  String tipoConta;
  String anuncioId;
  String user;
  int numQuartos;
  int numBanheiros;
  String comodidades;
  
Casa({
    required this.tipoConta,
    required this.user,
    required this.userId,
    required this.titulo,
    required this.imagens,
    required this.descricao,
    required this.endereco,
    required this.preco,
    required this.contato, 
    required this.anuncioId,
    required this.id,
    required this.casa,
    required this.isFavorito,
    required this.numQuartos,
    required this.numBanheiros,
    required this.comodidades, 
  }); 

  String get getcomodidades => comodidades;
  set setcomodidades(String comodidades) => this.comodidades = comodidades;

 int get getnumQuartos => numQuartos;
  set setnumQuartos(int numQuartos) => this.numQuartos = numQuartos;

  int get getnumBanheiros => numBanheiros;
  set setnumBanheiros(int numBanheiros) => this.numBanheiros = numBanheiros;

  // Getters e Setters
  String get getuserId => userId;
  set setuserId(String userId) => this.userId = userId;

  String get getanuncioId => anuncioId;
  set setanuncioId(String anuncioId) => this.anuncioId = anuncioId;

   String get gettipoConta => tipoConta;
  //set set(String tipoConta) => this.tipoConta = tipoConta;

  String get getTitulo => titulo;
  set setTitulo(String titulo) => this.titulo = titulo;

  List<String> get getImagens => imagens;
  set setImagens(List<String> imagens) => this.imagens = imagens;

  String get getDescricao => descricao;
  set setDescricao(String descricao) => this.descricao = descricao;

  String get getEndereco => endereco;
  set setEndereco(String endereco) => this.endereco = endereco;

  double get getPreco => preco;
  set setPreco(double preco) => this.preco = preco;

  String get getContato => contato;
  set setContato(String contato) => this.contato = contato;

  String get getId => id;
  set setId(String id) => this.id = id;

   String? get getcasa => casa;
   set setcasa(String casa) => this.casa = casa;

 Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'imagens': imagens,
      'descricao': descricao,
      'endereco': endereco,
      'preco': preco,
      'contato': contato,
      'anuncioId': anuncioId,
      'isFavorito': isFavorito,
      'userId': userId,
     // 'tipoConta': tipoConta,
     // 'user': user,
      'numQuartos': numQuartos,
      'numBanheiros': numBanheiros,
      'comodidades': comodidades,
    };
  }


  static Casa fromMap(Map<String, dynamic> casaData) {
    return Casa(
      titulo: casaData['titulo'] ?? '',
      imagens: List<String>.from(casaData['imagens'] ?? []),
      descricao: casaData['descricao'] ?? '',
      endereco: casaData['endereco'] ?? '',
      preco: (casaData['preco'] ?? 0).toDouble(),
     // preco: casaData['preco'] ?? '',
      contato: casaData['contato'] ?? '',
      anuncioId: casaData['anuncioId'] ?? '',
      isFavorito: casaData['isFavorito'] ?? false,
      userId: casaData['userId'] ?? '',
      tipoConta: casaData['tipoConta'] ?? '',
      user: casaData['user'] ?? '',
      id: casaData['id'] ?? '',
      casa: casaData['casa'] ?? '',
      numQuartos: (casaData['numQuartos'] ?? 0).toInt(),
      numBanheiros: (casaData['numBanheiros'] ?? 0).toInt(),
      // numQuartos: casaData['numQuartos'] ?? '',
      // numBanheiros: casaData['numBanheiros'] ?? '',
      comodidades: casaData['comodidades'] ?? '',
    );
  }

}
