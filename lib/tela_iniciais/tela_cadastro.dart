// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, camel_case_types, unused_local_variable, prefer_const_literals_to_create_immutables, avoid_print

//import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../providers/UserProvider.dart';
import 'tela_login.dart'; 

class tela_cadastro extends StatefulWidget {
  const tela_cadastro({Key? key}) : super(key: key);

  @override
  _TelaCadastroState createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<tela_cadastro> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();

  bool _isObscured = true;
  String passwordStrength = '';

  void _toggleObscure() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

void _criarConta(BuildContext context, String tipoConta) async {
  String nome = nomeController.text;
  String email = emailController.text;
  String senha = senhaController.text;

  try {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    bool isEmailInUse = await userProvider.checkEmailInUse(email);
    if (isEmailInUse) {
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
              Text('Atenção!'),
            ],
          ),
          content: const Text(
            'Esse email já está em uso. Por favor, use outro email.',
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
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20.0),
            Text('Criando conta...'),
          ],
        ),
      ),
    );

    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: senha,
    );

    String userId = userCredential.user!.uid;

    String accountType = selectedAccountType ?? 'Normal';
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'tipoConta': accountType,
      
      
      // Outros campos como nome, fotoPerfil, etc.
    });

    // Crie a subcoleção "favoritos" apenas se a conta for do tipo "Normal".
if (accountType == 'Normal') {
  await FirebaseFirestore.instance.collection('users').doc(userId).collection('favoritos').doc('anunciosFavoritos').set({});
  print('A subcoleção "favoritos" para o tipo de conta Normal foi criada com sucesso!');
}

    //  // Crie a subcoleção "favoritos" para o novo usuário recém-criado, independentemente do valor de accountType
    // await FirebaseFirestore.instance.collection('users').doc(userId).collection('favoritos').doc('anunciosFavoritos').set({
    // });
    // print('A subcoleção "favoritos" foi criada com sucesso!');

    User? user = userCredential.user;
    if (user != null) {
      await user.updateDisplayName(nome);
    }

    Navigator.of(context, rootNavigator: true).pop();

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
            Text('Sucesso!'),
          ],
        ),
        content: const Text(
          'A conta foi criada com sucesso, clique no botão OK e volte para tela de login para entrar com os dados cadastrados.'
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/tela_login");
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  } catch (e) {
    Navigator.of(context).pop();

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
              child: Text('Erro ao criar a conta!'),
            ),
          ],
        ),
        content: const Text(
          'Ocorreu um erro ao criar a conta. Verifique os dados e tente novamente.',
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
    return Scaffold(
      backgroundColor: const Color(0xA14743FF),
      body: Container(
        padding: const EdgeInsets.all(35.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _logoApp(),
              const SizedBox(height: 20.0),
              _campoEmail(),
              const SizedBox(height: 10.0),
              _campoSenha(),
              const SizedBox(height: 4.0),
              Text(
                'Força da senha: $passwordStrength',
                //textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xFF96D9FF),
                ),
              ),
              const SizedBox(height: 10.0),
              _campoTipoConta(), 
            const SizedBox(height: 10.0),
              _botaoCriarConta(),
              const SizedBox(height: 10.0),
              _textoOu(),
              const SizedBox(height: 10.0),
              _textoRedirecionaTelaLogin(),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logoApp() {
    return Image.asset(
      'assets/imagens/NovaLogo_appFIGMA2.png',
      height: 150,
      width: 200,
    );
  }

  Widget _campoEmail() {
    return TextFormField(
      controller: emailController,
      style: const TextStyle(
        color: Color(0xFFFFFFFF),
      ),
      decoration: const InputDecoration(
        hintText: 'Digite seu email',
        hintStyle: TextStyle(
          color: Color(0xE2FFFFFF),
        ),
        suffixIcon: Padding(
          padding: EdgeInsets.only(top: 15.0, bottom: 2, left: 17),
          child: Icon(
            Icons.email,
            color: Color(0xFFFFFFFF),
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xEAFFFFFF)),
        ),
        contentPadding: EdgeInsets.only(top: 22.0, bottom: 2),
      ),
    );
  }

  Widget _campoSenha() {
    return TextFormField(
      controller: senhaController,
      obscureText: _isObscured,
      onChanged: (value) {
       setState(() {
          List<String> requirements = context.read<UserProvider>().checkPasswordRequirements(value);
         if (requirements.isEmpty) {
            passwordStrength = 'Forte';
       } else {
      passwordStrength = '\nRequisitos não atendidos:${requirements.join('\n')}';
       }
     });
   },
      style: const TextStyle(
        color: Color(0xFFFFFFFF),
      ),
      decoration: InputDecoration(
        hintText: 'Digite sua senha',
        hintStyle: const TextStyle(
          color: Color(0xE2FFFFFF),
        ),
        suffixIcon: IconButton(
          padding: const EdgeInsets.only(top: 15.0, bottom: 2, left: 17),
          icon: Icon(
            _isObscured ? Icons.visibility : Icons.visibility_off,
            color: Color(0xFFFFFFFF),
          ),
          onPressed: _toggleObscure,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xEAFFFFFF)),
        ),
        contentPadding: const EdgeInsets.only(top: 22.0, bottom: 2),
      ),
    );
  }

String? selectedAccountType; 

Widget _campoTipoConta() {
  return ListTile(
    
     title: Padding( padding:  const EdgeInsets.only(top: 15.0),
    child: Text(
      'Tipo de Conta:',
      style: TextStyle(
        color: Color(0xFFFFFFFF),
        fontWeight: FontWeight.bold,
      ),
    ),
    ),
    
    trailing: DropdownButton<String>(
     hint: Padding(
      padding:  const EdgeInsets.only(right: 15.0, top: 13.0),
       child: Text(
        'Escolha a conta',  
        style: TextStyle(
          color: Color(0xFFFFFFFF),
        ),
      ),
      ),
     
      value: selectedAccountType,
      onChanged: (String? newValue) {
        setState(() {
          selectedAccountType = newValue!;
        });
      },
      items: <String>['Normal', 'Anúncio'].map<DropdownMenuItem<String>>(
        (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
              value,
              style: TextStyle(
                color: Color(0xFF050505), // Texto preto quando aberto
              ),
            ),
            ),
          );
        },
      ).toList(),
      selectedItemBuilder: (BuildContext context) {
        return <String>['Normal', 'Anúncio'].map<Widget>((String value) {
          return Padding(
            padding:  const EdgeInsets.only(right: 31.0, top: 19.0),
            child: Text(
            value,
            style: TextStyle(
              color: Color(0xFFFFFFFF), // Texto branco quando fechado e escolhido
            ),
          ),
       );
        }).toList();
      },
    underline: Container(
       height: 2,
        color: Color.fromARGB(255, 252, 180, 180), // cor para a linha de seleção
      ),
      
    ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
      
  );
}

Widget _botaoCriarConta() {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF4743FF),
      foregroundColor: Color(0xFFFFFFFF),
      minimumSize: Size(210, 37),
    ),
    child: const Text('Criar conta'),
    onPressed: () {
      if (selectedAccountType == null) {
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
                Text('Atenção!'),
              ],
            ),
            content: const Text(
              'Escolha o tipo de conta antes de criar a conta.',
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
        _criarConta(context, selectedAccountType!);
      }
    },
  );
}

  Widget _textoOu() {
    return const Text(
      'ou',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xFFFFFFFF),
      ),
    );
  }

  Widget _textoRedirecionaTelaLogin() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => tela_login()),
        );
      },
      child: RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          text: 'Já tem uma conta? ',
          style: TextStyle(
            color: Color(0xFFFFFFFF),
          ),
          children: [
            TextSpan(
              text: 'Fazer login',
              style: TextStyle(
                color: Color(0xFF00C58A),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
