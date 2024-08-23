// ignore: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String nome = '';
  String email = '';
  String senha = '';
  String tipoConta = '';
  String userId = '';


  UserProvider() {
    _loadFromPrefs(); // Carregar dados do SharedPreferences ao inicializar
  }

  void setTipoConta(String tipo) {
    tipoConta = tipo;
    notifyListeners();
    // ignore: avoid_print
    print('Tipo de conta definido como: $tipoConta');
  }

  void setUserId(String newUserId) {
    userId = newUserId;
    notifyListeners();
    // ignore: avoid_print
    print('ID do usuário definido como: $userId');
  }
 

  void setNameAndEmail(String newName, String newEmail) {
    nome = newName;
    email = newEmail;
    _saveToPrefs(); // Salvar nome e email no SharedPreferences
    notifyListeners();
  }


  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('nome', nome);
      prefs.setString('email', email);
      prefs.setString('senha', senha);
      prefs.setString('userId', userId);
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao salvar dados do usuário: $e');
    }
  }


  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      nome = prefs.getString('nome') ?? '';
      email = prefs.getString('email') ?? '';
      senha = prefs.getString('senha') ?? '';
      userId = prefs.getString('userId') ?? '';
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao carregar dados do SharedPreferences: $e');
    }
  }

    Future<void> changePassword(String newSenha) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePassword(newSenha);
        senha = newSenha;
        await _saveToPrefs();
        notifyListeners();
        // ignore: avoid_print
        print('Senha alterada com sucesso');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao alterar a senha: $e');
    }
  }

  
  Future<void> changeEmail(String newEmail) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateEmail(newEmail);
        email = newEmail;
        await _saveToPrefs();
        notifyListeners();
        // ignore: avoid_print
        print('E-mail alterado com sucesso');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao alterar o e-mail: $e');
    }
  }
  
  Future<void> changeName(String newName) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateDisplayName(newName);
        nome = newName;
        await _saveToPrefs();
        notifyListeners();
        // ignore: avoid_print
        print('Nome alterado com sucesso');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao alterar o nome: $e');
    }
  }

   Future<bool> checkEmailInUse(String email) async {
    try {
      final result = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      return result.isNotEmpty;
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao verificar o email: $e');
      return false;
    }
  }

List<String> checkPasswordRequirements(String password) {
  List<String> requirements = [];

  // Critérios de senha
  bool hasLength = password.length >= 8;
  bool hasDigits = password.contains(RegExp(r'\d'));
  bool hasSpecialChars = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  bool hasUpperCase = password.contains(RegExp(r'[A-Z]'));
  bool hasLowerCase = password.contains(RegExp(r'[a-z]'));

  // Verifica requisitos não atendidos
  if (!hasLength) {
    requirements.add(' A senha deve ter pelo menos 8 caracteres.');
  }
  if (!hasDigits) {
    requirements.add('A senha deve conter pelo menos um número.');
  }
  if (!hasSpecialChars) {
    requirements.add('A senha deve conter pelo menos um caractere especial.');
  }
  if (!hasUpperCase) {
    requirements.add('A senha deve conter pelo menos uma letra maiúscula.');
  }
  if (!hasLowerCase) {
    requirements.add('A senha deve conter pelo menos uma letra minúscula.');
  }

  return requirements;
}

}
  