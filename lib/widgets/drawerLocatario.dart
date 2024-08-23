// ignore_for_file: camel_case_types, use_key_in_widget_constructors
import 'package:AlugaFacil/tela_Usuario/homepage_locatario.dart';
import 'package:flutter/material.dart';
import 'package:AlugaFacil/providers/UserProvider.dart';
import 'package:provider/provider.dart';
import '../tela_Locador/PasswordField.dart';

class drawerLocatario extends StatefulWidget {
  const drawerLocatario({Key? key, required this.scaffoldKey});

  final GlobalKey<ScaffoldState> scaffoldKey; 

  @override
  // ignore: library_private_types_in_public_api
  _drawerState createState() => _drawerState();
}

class _drawerState extends State<drawerLocatario> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                return UserAccountsDrawerHeader(
                  accountName: Text(userProvider.nome),
                  accountEmail: Text(userProvider.email),
                );
              },
            ),
            ListTile(
              onTap: () async {
                await _mostrarDialogoEditarPerfil(context);
              },
              leading: const Icon(Icons.edit),
              title: const Text("Editar Perfil"),
            ),
            const Divider(color: Colors.black38),
            ListTile(
              onTap: () {
                Navigator.pushReplacementNamed(context, "/homepage_locatario"); 
              },
              leading: const Icon(Icons.home),
              title: const Text("Instruções"),  //tela_InstrucoesLocatario(), Índice 0
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const homepage_locatario(initialIndex: 1), 
                  ),
                );
              },
              leading: const Icon(Icons.list_alt_rounded),
              title: const Text("Lista"), //tela_listaLocatario(), Índice 1
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const homepage_locatario(initialIndex: 2), 
                  ),
                );
              },
              leading: const Icon(Icons.filter_alt),
              title: const Text("Filtro"), //tela_filtrosLocatario(), Índice 2
            ),
              ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const homepage_locatario(initialIndex: 3),
                  ),
                );
              },
              leading: const Icon(Icons.favorite), 
              title: const Text("Favoritos"), //tela_favoritosLocatario(), // Índice 3
            ),
            const Divider(color: Colors.black38),
            ListTile(
              onTap: () {
                Navigator.pushReplacementNamed(context, "/tela_bemvindo");
              },
              leading: const Icon(Icons.logout),
              title: const Text("Sair"),
            ),
          ],
        ),
      ),
    );
  }

  bool hasEditedData = false;
  bool editarFotoPerfil = false;
  
}

// Função para mostrar o diálogo de edição de perfil
_mostrarDialogoEditarPerfil(BuildContext context) async {
  final nomeController = TextEditingController();
  final novaSenhaController = TextEditingController();
  final novoEmailController = TextEditingController();

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text("Editar Perfil"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: "Alterar nome"),
              ),
              TextFormField(
                controller: novoEmailController,
                decoration: const InputDecoration(labelText: "Alterar email"),
              ),
              PasswordField(controller: novaSenhaController),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              final newSenha = novaSenhaController.text;
              final newEmail = novoEmailController.text;
              final newName = nomeController.text;

              if (newName.isEmpty || newEmail.isEmpty || newSenha.isEmpty) {
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
                        Flexible(
                          child: Text(
                            'Erro ao alterar os dados!',
                          ),
                        ),
                      ],
                    ),
                    content: const Text(
                      'Preencha todos os campos corretamente para atualizar os dados.',
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
              } else {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  // ignore: prefer_const_constructors
                  builder: (context) => AlertDialog(
                    content: const Row(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(width: 20.0),
                        Text('Atualizando dados...'),
                      ],
                    ),
                  ),
                );

                try {
                  if (newSenha.isNotEmpty) {
                    await context.read<UserProvider>().changePassword(newSenha);
                  }

                  if (newEmail.isNotEmpty) {
                    // ignore: use_build_context_synchronously
                    await context.read<UserProvider>().changeEmail(newEmail);
                  }

                  if (newName.isNotEmpty) {
                    // ignore: use_build_context_synchronously
                    await context.read<UserProvider>().changeName(newName);
                  }

                  // ignore: use_build_context_synchronously
                  Navigator.of(context, rootNavigator: true).pop();

                  // ignore: use_build_context_synchronously
                  showDialog(
                    context: context,
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
                      content: const Text(
                        'Os dados foram salvos com sucesso.',
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context, rootNavigator: true).pop(); // Fechar o AlertDialog pai 
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                } catch (e) {
                  Navigator.of(context, rootNavigator: true).pop();

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
                          Text('Erro!'),
                        ],
                      ),
                      content: const Text(
                        'Ocorreu um erro ao atualizar os dados. Verifique e tente novamente.',
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

                  print('Error: $e');
                }
              }
            },
            child: const Text("Salvar"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancelar"),
          ),
        ],
      );
    },
  );
}

