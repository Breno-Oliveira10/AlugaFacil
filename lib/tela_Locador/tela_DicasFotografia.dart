import 'package:flutter/material.dart';
import 'package:AlugaFacil/widgets/drawerLocador.dart';


// ignore: camel_case_types, use_key_in_widget_constructors
class tela_DicasFotografia extends StatelessWidget {
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
        title: const Text('Dicas'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _openDrawer();
          },
        ),
      ),
      drawer: drawerLocador(scaffoldKey: _scaffoldKey),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDicaCard('Iluminação Adequada', 'Tire fotos durante o dia para aproveitar a luz natural.'),
            _buildDicaCard('Enquadramento da foto', 'Ao escolher tirar uma foto com a câmera ou selecionar uma já existente da galeria, opte sempre pelo formato horizontal para garantir uma melhor visualização no anúncio.'),
            _buildDicaCard('Fotografe Todos os Espaços', 'Capture quartos, áreas externas, salas, cozinhas e banheiros.'),
            _buildDicaCard('Destaque Características Únicas', 'No campo de comodidades no formulário de cadastro de casas, destaque características únicas do imóvel, como garagem ampla, área gourmet ou espaços verdes.'),
            _buildDicaCard('Fotos de Alta Resolução', 'Use câmeras de boa qualidade ou smartphones com uma boa resolução.'),
            _buildDicaCard('Fotos Externas', 'Inclua fotos da fachada, áreas externas, jardins e quintais.'),
            _buildDicaCard('Evitar Edições Excessivas', 'Evite edições excessivas, fotos autênticas são mais atraentes.'),
            _buildDicaCard('Fotos dos Arredores', 'Destaque a localização mostrando fotos dos arredores.'),
          ],
        ),
      ),
    );
  }

  Widget _buildDicaCard(String titulo, String descricao) {
    return Card(
       color: const Color(0xDFFFE7EB),
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              descricao,
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
