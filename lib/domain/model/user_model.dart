import 'dart:convert';

class UserModel {
  final String nome;
  final String email;
  final String senha;
 
  UserModel({
    required this.nome,
    required this.email,
    required this.senha,
  });

  

  UserModel copyWith({
    String? nome,
    String? email,
    String? senha,
  }) {
    return UserModel(
      nome: nome ?? this.nome,
      email: email ?? this.email,
      senha: senha ?? this.senha,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nome': nome,
      'email': email,
      'senha': senha,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      nome: map['nome'] as String,
      email: map['email'] as String,
      senha: map['senha'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserModel(nome: $nome, email: $email, senha: $senha)';

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.nome == nome &&
      other.email == email &&
      other.senha == senha;
  }

  @override
  int get hashCode => nome.hashCode ^ email.hashCode ^ senha.hashCode;
}
