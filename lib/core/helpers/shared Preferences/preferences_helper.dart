import 'package:financas/model/monthly%20epenses/monthly_expenses_model.dart';
import 'package:financas/model/user/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  Future<void> saveUser(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJson = user.toJson();
    await prefs.setString('usuario', userJson);
  }

  Future<UserModel?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('usuario');

    if (userJson != null) {
      return UserModel.fromJson(userJson);
    }
    return null;
  }

  Future<void> saveLocalExpenses(List<MonthlyExpenses> expenses) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String value = expenses.map((e) => e.toString()).toList().join(',');

    prefs.setString('expenses', value);
  }

  Future<List<MonthlyExpenses>> loadLocalExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? value = prefs.getString('expenses');

    if (value != null) {
      List<String> expenses = value.split(',');
      return expenses.map((e) => MonthlyExpenses.fromJson(e)).toList();
    } else {
      throw Exception('Nenhuma Conta salva');
    }
  }
}
