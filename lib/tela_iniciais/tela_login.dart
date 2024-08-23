// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:AlugaFacil/tela_Locador/homepage_locador.dart';
import 'package:AlugaFacil/tela_Usuario/homepage_locatario.dart';
import 'package:AlugaFacil/tela_iniciais/esqueceu_senha.dart';
import 'package:AlugaFacil/tela_iniciais/tela_cadastro.dart';
import 'package:provider/provider.dart';
import '../providers/UserProvider.dart';

class tela_login extends StatefulWidget {
  const tela_login({super.key});

  @override
  _Tela_loginState createState() => _Tela_loginState();
}


class _Tela_loginState extends State<tela_login> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  bool _isObscured = true;
  String passwordStrength = '';

  void _toggleObscure() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }


void _loginUser(BuildContext context) async {
  print('Iniciando login...');

  try {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
   //final casasprovider = Provider.of<CasasProvider>(context, listen: false);

    if (emailController.text.isEmpty || senhaController.text.isEmpty) {
      _showErrorDialog(context, 'Preencha todos os campos corretamente para fazer o login.');
      return;
    }

    if (!_isValidPassword(senhaController.text)) {
      _showErrorDialog(context, 'Tamanho de senha inválido. Por favor, insira a senha cadastrada correta.');
      return;
    }

    // Mostrar o CircularProgressIndicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20.0),
            Text('Verificando dados...'),
          ],
        ),
      ),
    );

    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text,
      password: senhaController.text,
    );

     print('Login bem-sucedido!');

     
    // Obtenha o usuário atualmente logado
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String nome = nomeController.text;
      String email = emailController.text;
      
      await user.updateDisplayName(nome); // Atualize o nome no Firebase 
      userProvider.setNameAndEmail(nome, email);  // Atualize os dados no provedor de usuário
    
      // Obter o documento do Firestore do usuário
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        // Verificar e definir o tipo de conta no UserProvider
        String tipoConta = userDoc['tipoConta'] ?? 'Normal';
        userProvider.setTipoConta(tipoConta);
        userProvider.setUserId(user.uid); // Define o userId 
      }

      // Fechar o AlertDialog de progresso
      Navigator.of(context).pop();

      if (userProvider.tipoConta == 'Normal') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => homepage_locatario()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => homepage_locador()),
        );
      }
    }
  } catch (e) {
     print('Erro ao fazer login: $e');
    // Fechar o AlertDialog de progresso
    Navigator.of(context).pop();

    _showErrorDialog(
      context,
      'Ocorreu um erro ao fazer o login. Verifique os dados e tente novamente.'
    );

    print('Error: $e');
  }
}

bool _isValidPassword(String password) {
  return password.length >= 8;
}

void _showErrorDialog(BuildContext context, String message) {
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
      content: Text(message),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xA14743FF), //0xA14743FF
      body: Container(
        padding: const EdgeInsets.all(34.0), 
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _logoApp(),
              const SizedBox(height: 5.0), 
              _campoNome(),
              const SizedBox(height: 5.0,),
              _campoEmail(),
              const SizedBox(height: 5.0),
              _campoSenha(),
              const SizedBox(height: 5.0),
              _campoEsqueceuSenha(), // Novo widget adicionado
              const SizedBox(height: 20.0),
              _botaoEntrar(),
              const SizedBox(height: 20.0),
              _textoOu(),
              const SizedBox(height: 10.0),
              _textoRedirecionaTelaCadastro(),
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
      width: 150,
    );
  }

  
  Widget _campoNome() {
    return TextFormField(
       controller: nomeController,
      style: const TextStyle(
        color: Color(0xFFFFFFFF),
      ),
      decoration: const InputDecoration(
        hintText: 'Digite seu nome',
        hintStyle: TextStyle(
          color: Color(0xE2FFFFFF), // cor do placeholder
        ),
        suffixIcon: Padding(
          padding: EdgeInsets.only(top: 15.0, bottom: 2, left: 17),
          child: Icon(
            Icons.person,
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
      decoration: InputDecoration(
        hintText: 'Digite sua senha',
        hintStyle: TextStyle(
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
      style: const TextStyle(
        color: Color(0xFFFFFFFF),
      ),
      obscureText: _isObscured,
    );
  }

  Widget _campoEsqueceuSenha() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => esqueceu_senha()),
          );
        },
        child: Text(
          'Esqueceu a senha?',
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }

  Widget _textoOu() {
    return Text(
      'ou',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xFFFFFFFF),
      ),
    );
  }

  Widget _botaoEntrar() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4743FF),
        foregroundColor: Color(0xFFFFFFFF),
      ),
      child: const Text('Entrar'),
      onPressed: () {
        _loginUser(context);
      },
    );
  }

  void _navigateToCadastro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => tela_cadastro()),
    );
  }

  Widget _textoRedirecionaTelaCadastro() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Não tem uma conta? ',
        style: TextStyle(
          color: Color(0xFFFFFFFF),
        ),
        children: [
          TextSpan(
            text: 'Cadastre-se',
            style: TextStyle(
              color: Color(0xFF00C58A), // cor "Verde-mar" (0xFF00C58A)
            ),
            recognizer: TapGestureRecognizer()..onTap = _navigateToCadastro,
          ),
        ],
      ),
    );
  }
}
 