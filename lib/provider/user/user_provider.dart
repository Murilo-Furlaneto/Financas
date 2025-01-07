import 'package:financas/core/helpers/shared%20Preferences/preferences_helper.dart';
import 'package:financas/model/user/user_model.dart';
import 'package:financas/repository/firebase/firebase_repository.dart';
import 'package:flutter/material.dart';

class UserViewModel extends ChangeNotifier {
  final FirebaseRepository _firebaseRepository;
  final SharedPreferencesHelper _preferences;
  UserModel _user = UserModel(nome: '', email: '', senha: '');

  UserViewModel(this._firebaseRepository, this._preferences);

  UserModel get getuser => _user;

  set setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  Future<UserModel> getUser() async {
    try {
      _user = await _firebaseRepository.getUserInformation();
      notifyListeners();
      return _user;
    } on Exception {
      throw Exception('Erro ao carregar as informações do usuário');
    } catch (e, stackTrace) {
      print('StackTrace: $stackTrace');
      throw Exception('Erro metodo getUserInformation: $e');
    }
  }

  Future<void> saveUser(UserModel user) async {
    try {
      await _preferences.saveUser(user);
      _user = user;
      notifyListeners();
    } on Exception {
      throw Exception('Erro ao salvar o  usuário');
    } catch (e, stackTrace) {
      print('StackTrace: $stackTrace');
      throw Exception('Erro metodo saveUser: $e');
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _firebaseRepository.updateUser(user);
      _user = user;
      notifyListeners();
    } on Exception {
      throw Exception('Erro ao atualizar as informações do usuário');
    } catch (e, stackTrace) {
      print('StackTrace: $stackTrace');
      throw Exception('Erro metodo updateUser: $e');
    }
  }

  Future<void> updatePassword(String novaSenha) async {
    try {
      await _firebaseRepository.updatePassword(novaSenha);
      notifyListeners();
    } on Exception {
      throw Exception('Erro ao atualizar a senha');
    } catch (e, stackTrace) {
      print('StackTrace: $stackTrace');
      throw Exception('Erro metodo updatePassword: $e');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseRepository.sendPasswordResetEmail(email);
      notifyListeners();
    } on Exception {
      throw Exception('Erro ao atualizar a senha');
    } catch (e, stackTrace) {
      print('StackTrace: $stackTrace');
      throw Exception('Erro metodo sendPasswordResetEmail: $e');
    }
  }
}
