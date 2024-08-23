// ignore_for_file: prefer_const_constructors, camel_case_types

import 'package:flutter/material.dart';

class tela_bemvindo extends StatelessWidget {
  const tela_bemvindo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xA14743FF), //480CA8
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _textobemvindo(),
            const SizedBox(height: 20.0),
            _logoComNome(),
            const SizedBox(height: 55.0),
            _botaoLogin(context),
            const SizedBox(height: 10.0),
            _botaoCadastro(context),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  Widget _textobemvindo() {
    return const Text(
      'Bem vindo',
      style: TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 22.0,
        fontWeight: FontWeight.w700,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _logoComNome() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        'assets/imagens/NovaLogo_appFIGMA2.png',
        width: 370,
        height: 160,
        alignment: Alignment.bottomCenter,
      ),
     // const SizedBox(height: 0), // Espaçamento entre a imagem e o texto
      Text(
        'Aluga Fácil',
        style: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 22.0,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
      ),
    ],
  );
}

  Widget _botaoLogin(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFFFFFFF),
        foregroundColor: Color(0xFF4743FF),
      ),
      child: const SizedBox(
        width: 280, //280
        height: 45, //45
        child: Center(
          child: Text(
            'Login',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 22.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      onPressed: () {
        Navigator.pushReplacementNamed(
          context,
          "/tela_login",
           
        );
      },
    );
  }

  Widget _botaoCadastro(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF4743FF),
        foregroundColor: Color(0xFFFFFFFF),
      ),
      child: const SizedBox(
        width: 280,
        height: 45,
        child: Center(
          child: Text(
            'Cadastro',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 22.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      onPressed: () {
        Navigator.pushReplacementNamed(
          context,
          "/tela_cadastro",
           
        );
      },
    );
  }
}
