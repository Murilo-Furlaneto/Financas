import 'package:financas/core/errors/error.dart';
import 'package:financas/data/service/firebase_service.dart';
import 'package:financas/model/user/user_model.dart';
import 'package:financas/repository/firebase/firebase_repository_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseRepository implements IFirebaseRepositoryInterface {
  final FirebaseService firebaseService;

  FirebaseRepository(this.firebaseService);

  @override
  Future<void> loginFirebase(
      String email, String senha, BuildContext context) async {
    try {
      await firebaseService.loginFirebase(email, senha,);
    } on Exception {
      FirebaseError("Erro ao fazer o login");
    } catch (e, stacktrace) {
      print('Erro ao fazer login via firebase: $e');
      print('Stack Trace: $stacktrace');
    }
  }

  @override
  Future<void> signUpFirebase(String nome, String email, String senha) async {
    try {
      await firebaseService.signUpFirebase(nome, email, senha);
    } on Exception {
      FirebaseError("Erro ao fazer o cadastro");
    } catch (e, stacktrace) {
      print('Erro de cadastro via Firebase: $e');
      print('Stack Trace: $stacktrace');
    }
  }

  @override
  Future<void> exitAccoutnFirebase() async {
    try {
      await firebaseService.exitAccountFirebase();
    } on Exception {
      FirebaseError("Erro ao fazer logout Firebase");
    } catch (e, stacktrace) {
      print('Erro ao fazer logout Firebase $e');
      print('Stack Trace: $stacktrace');
    }
  }

  @override
  Future<UserModel> getUserInformation() async {
    try {
      User user = FirebaseAuth.instance.currentUser!;
      UserModel userModel =
          UserModel(nome: user.displayName!, email: user.email!, senha: '');
      return userModel;
    } on FirebaseAuthException catch (e) {
      print('Erro ao acessar o usuário: ${e.message}');
      rethrow;
    } catch (e, stacktrace) {
      print('Erro inesperado ao obter informações do usuário: $e');
      print('Stack Trace: $stacktrace');
      throw Exception('Erro ao obter informações do usuário');
    }
  }

  @override
  Future<void> updateUser(UserModel user) async {
    try {
      User userFirebase = FirebaseAuth.instance.currentUser!;

      // Comparar nome e email para verificar se há mudanças
      if (user.nome != userFirebase.displayName) {
        await FirebaseAuth.instance.currentUser!.updateDisplayName(user.nome);
      }

      if (user.email != userFirebase.email) {
        await FirebaseAuth.instance.currentUser!.updateEmail(user.email);
      }
    } on FirebaseAuthException catch (e) {
      print('Erro ao atualizar o usuário: ${e.message}');
      rethrow;
    } catch (e, stacktrace) {
      print('Erro inesperado ao atualizar as informações do usuário: $e');
      print('Stack Trace: $stacktrace');
      throw Exception('Erro ao atualizar informações do usuário');
    }
  }

  @override
  Future<void> updatePassword(String novaSenha) async {
    try {
      User user = FirebaseAuth.instance.currentUser!;
      await user.updatePassword(novaSenha);
      print('Senha atualizada com sucesso');
    } on FirebaseAuthException catch (e) {
      print('Erro ao atualizar a senha: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      print('E-mail de redefinição enviado com sucesso');
    } on FirebaseAuthException catch (e) {
      print('Erro ao enviar o e-mail de redefinição: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<User> getCurrentUser() async {
    return FirebaseAuth.instance.currentUser!;
  }
}
