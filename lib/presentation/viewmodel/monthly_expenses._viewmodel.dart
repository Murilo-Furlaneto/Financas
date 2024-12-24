import 'package:financas/core/helpers/shared%20Preferences/preferences_helper.dart';
import 'package:financas/domain/model/monthly_expenses_model.dart';
import 'package:flutter/material.dart';

class MonthlyExpensesViewmodel extends ChangeNotifier {
  List<MonthlyExpenses> _expenses = [];
  final SharedPreferencesHelper _preferences;

  MonthlyExpensesViewmodel(SharedPreferencesHelper preferences)
      : _preferences = preferences;

  List<MonthlyExpenses> get getExpenses => _expenses;

  Future<void> saveLocalExpenses(List<MonthlyExpenses> expenses) async {
    try {
      _preferences.saveLocalExpenses(expenses);
      notifyListeners();
    } catch (e) {
      throw Exception('Erro ao salvar a conta');
    }
  }

  Future<List<MonthlyExpenses>> loadLocalExpenses() async {
    try {
      _expenses = await _preferences.loadLocalExpenses();
      if (_expenses.isNotEmpty) {
        return _expenses;
      }
    } catch (e) {
      throw Exception('Erro ao carregar as contas');
    }
    return [];
  }
}
