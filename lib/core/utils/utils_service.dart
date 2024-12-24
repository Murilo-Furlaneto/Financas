import 'package:financas/core/helpers/enum/enum_mes.dart';

class UtilsService {
  String retornaMes(int mes) {
    EnumMes nome_mes;

    try {
      if (mes < 1 || mes > 12) {
        print('Esse mês não existe');
      } else {
        return EnumMes.values[mes - 1].toString().split('.').last;
      }
    } catch (e) {
      print('Esse mês não existe.');
      print("Erro: $e");
    }
    return '';
  }
}
