import 'package:financas/core/helpers/shared%20Preferences/preferences_helper.dart';
import 'package:financas/domain/model/user_model.dart';
import 'package:financas/presentation/view/authentication/sign_up_page.dart';
import 'package:financas/presentation/view/home_page.dart';
import 'package:flutter/material.dart';

class CheckPage extends StatefulWidget {
  CheckPage({Key? key}) : super(key: key);
  final prefs = SharedPreferencesHelper();

  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final UserModel? user = await widget.prefs.getUser();

      if (user != null) {
        return Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      } else {
        return Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SignUpPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
