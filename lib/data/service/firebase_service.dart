import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  Future<void> loginFirebase(String email, String senha) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: senha);
    } catch (e) {
      String errorMessage;

      // Tratamento de erros comuns
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'Usuário não encontrado. Verifique o email.';
            break;
          case 'wrong-password':
            errorMessage = 'Senha incorreta. Tente novamente.';
            break;
          case 'invalid-email':
            errorMessage = 'O formato do email é inválido.';
            break;
          default:
            errorMessage = 'Erro desconhecido: ${e.message}';
        }
      } else {
        errorMessage = 'Ocorreu um erro inesperado.';
      }
    }
  }

  Future<void> signUpFirebase(
      String name, String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user?.updateDisplayName(name);

      await userCredential.user?.reload();
      User? updatedUser = FirebaseAuth.instance.currentUser;

      print("Usuário criado com sucesso: ${updatedUser?.displayName}");
    } catch (e) {
      print("Erro ao criar usuário: $e");
    }
  }

  Future<String> exitAccountFirebase() async {
    try {
      await FirebaseAuth.instance.signOut();
      return 'Você saiu da conta com sucesso!';
    } catch (e) {
      return 'Erro ao sair da conta: ${e.toString()}';
    }
  }
}
