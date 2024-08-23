
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:AlugaFacil/tela_iniciais/tela_bemvindo.dart';

class tela_SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  
    Future.delayed(Duration(seconds: 7), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => tela_bemvindo()),
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xA14743FF), //0xA14743FF
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/imagens/NovaLogo_appFIGMA2.png',
            width: 400,
            height: 180,
            alignment: Alignment.bottomCenter,
          ),
          const SizedBox(height: 3.0), // espaçamento entre a imagem e o texto
          const Text(
            'Aluga Fácil',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 22.0,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
            const SizedBox(height: 35.0), //espaçamento entre o CircularProgressIndicator e o texto
           CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
    );
  }
}


