import 'package:flutter/material.dart';
import 'package:AlugaFacil/models/Casa.dart';
import 'package:AlugaFacil/tela_Locador/homepage_locador.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: camel_case_types, must_be_immutable
class tela_detalhesLocatario extends homepage_locador {
  Casa casa;

  tela_detalhesLocatario({Key? key, required this.casa, initialIndex = 1})
      : super(key: key);

  @override
  _DetalhesCasaScreenState createState() => _DetalhesCasaScreenState();
}

class _DetalhesCasaScreenState extends State<tela_detalhesLocatario> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<String> imagePaths = widget.casa.imagens;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Casa'),
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
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Título:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    widget.casa.titulo,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Descrição:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    widget.casa.descricao,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Endereço:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    widget.casa.endereco,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Preço:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'R\$ ${widget.casa.preco.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Contato:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
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
                  SizedBox(height: 5.0),
                  Text(
                    widget.casa.comodidades.toString(),
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),

       floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 45.0, // altera a altura do icone
            right: 45.0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
              child: IconButton(
                onPressed: () {
                  abrirWhatsApp(widget.casa.contato, widget.casa);
                },
                icon: FaIcon(
                  FontAwesomeIcons.whatsapp,
                  size: 34.0, // Ajuste o tamanho do ícone
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 17.0, //ajusta a altura da caixa de texto
            right: 5.0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                'Entrar em contato',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
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

  void abrirWhatsApp(String contato, Casa casa) async {
    
    var mensagem = 'Olá, esse anúncio ainda está disponível?\n\n';
    mensagem += 'Título: ${casa.titulo}\n';
    mensagem += 'Descrição: ${casa.descricao}\n';
    mensagem += 'Endereço: ${casa.endereco}\n';
    mensagem += 'Preço: R\$ ${casa.preco.toStringAsFixed(2)}\n';
    mensagem += 'Contato: ${casa.contato}\n';
    mensagem += 'Número de quartos: ${casa.numQuartos}\n';
    mensagem += 'Número de banheiros: ${casa.numBanheiros}\n';
    mensagem += 'Comodidades: ${casa.comodidades}\n';

    var whatsappUrl = "whatsapp://send?phone=$contato&text=${Uri.encodeComponent(mensagem)}";

    // ignore: deprecated_member_use
    if (await launch(whatsappUrl)) {
      // ignore: deprecated_member_use
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

}





