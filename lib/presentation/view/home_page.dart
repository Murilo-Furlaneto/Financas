import 'package:financas/core/helpers/shared%20Preferences/preferences_helper.dart';
import 'package:financas/domain/model/monthly_expenses_model.dart';
import 'package:financas/presentation/view/profile_page.dart';
import 'package:financas/presentation/viewmodel/monthly_expenses._viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MonthlyExpenses> monthlyExpenses = [];
  final prefs = SharedPreferencesHelper();

  Future<void> saveLocalExpenses(List<MonthlyExpenses> expenses) async {
    prefs.saveLocalExpenses(expenses);
  }

  Future<List<MonthlyExpenses>> loadLocalExpenses() async {
    return prefs.loadLocalExpenses();
  }

  @override
  Widget build(BuildContext context) {
    final _monthlyExpenses = Provider.of<MonthlyExpensesViewmodel>(context);

    @override
    void initState() {
      super.initState();
      _monthlyExpenses.loadLocalExpenses();
    }

    @override
    void dispose() {
      super.dispose();
      _monthlyExpenses.saveLocalExpenses(_monthlyExpenses.getExpenses);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()));
            },
            icon: const Icon(
              Icons.account_circle,
              size: 30,
            )),
        title: const Text('Minhas despesas'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => showAddAccountDialog(context),
              icon: const Icon(
                Icons.add,
                size: 30,
              ))
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                itemCount: _monthlyExpenses.getExpenses.length,
                itemBuilder: (BuildContext context, int index) {
                  MonthlyExpenses monthlyExpenses =
                      _monthlyExpenses.getExpenses[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(monthlyExpenses.title[0]),
                    ),
                    title: Text(
                      monthlyExpenses.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Vencimento: ${monthlyExpenses.dueDate}'),
                    trailing: Text(
                        'R\$ ${monthlyExpenses.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  );
                }),
          ],
        ),
      )),
    );
  }

  void showAddAccountDialog(BuildContext context) {
    final TextEditingController accountNameController = TextEditingController();
    final TextEditingController dueDateController = TextEditingController();
    final TextEditingController amountController = TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Adicionar Conta'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: accountNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome da conta',
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  controller: dueDateController,
                  decoration: const InputDecoration(
                    labelText: 'Dia do Vencimento',
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: amountController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Valor',
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  String accountName = accountNameController.text;
                  int? dueDate = int.tryParse(dueDateController.text);
                  double? amount = double.tryParse(amountController.text);

                  if (dueDate != null &&
                      dueDate >= 1 &&
                      dueDate <= 31 &&
                      amount != null &&
                      accountName.isNotEmpty) {
                    setState(() {
                      monthlyExpenses.add(MonthlyExpenses(
                          id: '$accountName - $dueDate',
                          title: accountName,
                          amount: amount,
                          dueDate: dueDate));
                    });
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Por favor, insira valores válidos')));
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          );
        });
  }
}
