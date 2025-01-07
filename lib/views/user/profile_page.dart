import 'dart:io';
import 'package:financas/core/helpers/shared%20Preferences/preferences_helper.dart';
import 'package:financas/data/service/firebase_service.dart';
import 'package:financas/model/user/user_model.dart';
import 'package:financas/repository/firebase/firebase_repository.dart';
import 'package:financas/views/authentication/login_page.dart';
import 'package:financas/provider/user/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _firebaseRepository = FirebaseRepository(FirebaseService());
  XFile? _image;
  final usuarioViewModel = UserViewModel(
      FirebaseRepository(FirebaseService()), SharedPreferencesHelper());
  UserModel? user;
  bool isEditing = false;

  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  Future<void> uploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _image = image;
      });
      saveImage(_image!.path);
    }
  }

  Future<void> loadImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('imagePath');
    if (imagePath != null) {
      setState(() {
        _image = XFile(imagePath);
      });
    }
  }

  Future<void> saveImage(String path) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('imagePath', path);
  }

  Future<void> getUser() async {
    UserModel usuario = await usuarioViewModel.getUser();
    setState(() {
      nomeController.text = usuario.nome;
      emailController.text = usuario.email;
    });
  }

  @override
  void initState() {
    super.initState();
    loadImage();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuário'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 90,
              child: Center(
                child: _image == null
                    ? IconButton(
                        icon: const Icon(Icons.account_circle, size: 60),
                        onPressed: () {
                          uploadImage();
                        },
                      )
                    : Image.file(File(_image!.path)),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: nomeController,
              enabled: isEditing,
              decoration: const InputDecoration(
                labelText: 'Nome',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: emailController,
              enabled: isEditing,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.10,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  if (isEditing == true) {
                    if (nomeController.text != usuarioViewModel.getuser.nome ||
                        emailController.text !=
                            usuarioViewModel.getuser.email) {
                      var newUser = UserModel(
                          email: emailController.text,
                          nome: nomeController.text,
                          senha: '');

                      await usuarioViewModel.updateUser(newUser);
                    }
                  }
                  setState(() {
                    isEditing = !isEditing;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isEditing ? Icons.save : Icons.edit,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isEditing ? 'Salvar' : 'Editar informações',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.10,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  await _firebaseRepository.exitAccoutnFirebase();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 2,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.exit_to_app_outlined,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Sair',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
