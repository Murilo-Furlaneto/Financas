import 'package:financas/domain/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class IFirebaseRepositoryInterface {
  Future<void> loginFirebase(String email, String senha, BuildContext context);
  Future<void> signUpFirebase(String nome, String email, String senha);
  Future<void> exitAccoutnFirebase();
  Future<UserModel> getUserInformation();
  Future<void> updateUser(UserModel user);
  Future<void> updatePassword(String novaSenha);
  Future<void> sendPasswordResetEmail(String email);
  Future<User> getCurrentUser();
}
