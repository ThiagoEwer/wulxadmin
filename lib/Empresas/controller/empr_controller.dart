import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class EmpresasController {
   final supabase = Supabase.instance.client;

void toggleEmpresaStatus(
    Map<String, dynamic> empresa, VoidCallback setStateCallback) async {
  final updatedEmpresa = empresa;
  final blocked = empresa['emp_bloqueado'] ?? false;
  updatedEmpresa['emp_bloqueado'] = !blocked;

  try {
    final response = await supabase
        .from('empresas')
        .update(updatedEmpresa)
        .match({'emp_id': empresa['emp_id']});

    if (response != null) {
      if (response.error != null) {
        // Trate o erro ao atualizar a empresa
        print('Erro ao atualizar a empresa: ${response.error}');
        return;
      }
    } else {
      // Trate o caso em que a resposta é nula
      print('Erro ao atualizar a empresa: resposta nula');
    }

    setStateCallback(); // Chama o setState no _EmpresasScreenState
  } catch (error) {
    // Trate o erro ao atualizar a empresa
    print('Erro ao atualizar a empresa: $error');
  }
}

}
