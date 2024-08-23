// ignore_for_file: avoid_print, unnecessary_null_comparison, depend_on_referenced_packages

import 'package:AlugaFacil/models/Casa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'UserProvider.dart';

class CasasProvider extends ChangeNotifier {
  int _lastId = 0;
  List<Casa> _casas = [];
  List<Casa> get casas => _casas;

  Future<void> carregarCasas(UserProvider userprovider, SharedPreferences prefs) async {
    try {
      final userId = userprovider.userId;
      print('Carregando casas para o usuário com ID: $userId');

      final casasCollection = FirebaseFirestore.instance.collection('anuncios');

      if (userprovider.tipoConta == 'Normal') {
        final favoritosQuery = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('favoritos')
            .doc('anunciosFavoritos')
            .get();

        List<String> idsFavoritos = List<String>.from(favoritosQuery.data()?['anuncios'] ?? []);

        final querySnapshot = await casasCollection.get();

        _casas = querySnapshot.docs.map((doc) {
          Casa casa = Casa.fromMap(doc.data());
          casa.isFavorito = idsFavoritos.contains(casa.anuncioId);
          return casa;
        }).toList();
      } else {
        final querySnapshot = await casasCollection.where('userId', isEqualTo: userId).get();
        _casas = querySnapshot.docs.map((doc) => Casa.fromMap(doc.data())).toList();
      }

      notifyListeners();
      print('Casas carregadas com sucesso do Firestore!');
    } catch (e) {
      print('Erro ao carregar casas: $e');
    }
  }


  void adicionarCasa(Casa casa, String userId) {
    casa.id = buscarId();
    _casas.add(
      Casa(
        tipoConta: casa.tipoConta,
        userId: userId,
        titulo: casa.titulo,
        imagens: casa.imagens,
        descricao: casa.descricao,
        endereco: casa.endereco,
        preco: casa.preco,
        contato: casa.contato,
        id: casa.id,
        casa: casa.casa,
        isFavorito: casa.isFavorito,
        user: casa.user,
        anuncioId: casa.anuncioId,
        comodidades: casa.comodidades,
        numBanheiros: casa.numBanheiros,
        numQuartos: casa.numQuartos,
      ),
    );
    notifyListeners();
  }

  String buscarId() {
    _lastId++;
    return 'casa_$_lastId';
  }

  void favoritarCasa(String anuncioId, Casa casa, UserProvider userprovider) async {
  try {
    if (userprovider.tipoConta == 'Normal') {
      final userId = userprovider.userId;
      final favoritosRef = FirebaseFirestore.instance.collection('users').doc(userId).collection('favoritos').doc('anunciosFavoritos');

      await favoritosRef.update({
        'anuncios': FieldValue.arrayUnion([anuncioId]),
      });

       casa.isFavorito = true;
      notifyListeners();
      print('Anúncio adicionado como favorito com sucesso no Firestore!');
    }
  } catch (e) {
    print('Erro ao favoritar casa: $e');
  }
}

void desfavoritarCasa(String anuncioId, Casa casa, UserProvider userprovider) async {
  try {
    if (userprovider.tipoConta == 'Normal') {
      final userId = userprovider.userId;
      final favoritosRef = FirebaseFirestore.instance.collection('users').doc(userId).collection('favoritos').doc('anunciosFavoritos');

      await favoritosRef.update({
        'anuncios': FieldValue.arrayRemove([anuncioId]),
      });

      casa.isFavorito = false;
      notifyListeners();
      print('Anúncio removido como favorito com sucesso no Firestore!');
    }
  } catch (e) {
    print('Erro ao desfavoritar casa: $e');
  }
}

  List<Casa> get casasFavoritas {
    return _casas.where((casa) => casa.isFavorito).toList();
  }

  final List<String> _imagePaths = [];
  List<String> get imagePaths => _imagePaths;

  void adicionarImagens(List<String> paths) {
    _imagePaths.addAll(paths);
    notifyListeners();
  }

  final List<String> _imageUrls = [];
  List<String> get imageUrls => _imageUrls;

  void adicionarUrls(List<String> urls) {
    _imageUrls.addAll(urls);
    notifyListeners();
  }

  Future<void> excluirNoFirestore(String anuncioId) async {
    try {
      final anunciosCollection = FirebaseFirestore.instance.collection('anuncios');

      await anunciosCollection.where('anuncioId', isEqualTo: anuncioId).get().then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
      print('Anuncio excluido com sucesso no Firestore');
    } catch (error) {
      print('Erro ao excluir anúncio no Firestore: $error');
    }
  }

  Future<void> excluirCasa(String anuncioId) async {
    try {
      await excluirNoFirestore(anuncioId);
      _casas.removeWhere((casa) => casa.anuncioId == anuncioId);
      notifyListeners();
      print('Anuncio excluido com sucesso no provedor de casas!');
    } catch (error) {
      print('Erro ao excluir anúncio: $error');
    }
  }

  void atualizarCasa(Casa casaAtualizada) {
    final index = _casas.indexWhere((casa) => casa.anuncioId == casaAtualizada.anuncioId);
    if (index != -1) {
      _casas[index] = casaAtualizada;
      notifyListeners();
    }
  }

}

