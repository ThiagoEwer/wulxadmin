import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../view/user_details.dart';

class UsersController {
  final BuildContext context;
  final supabase = Supabase.instance.client;
  late TextEditingController _searchController;

  UsersController(this.context) {
    _searchController = TextEditingController();
  }

  void dispose() {
    _searchController.dispose();

  }

  // Lógica para exibir detalhes do usuário
  Future<void> showUserDetails(Map<String, dynamic> user) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UserDetailScreen(user: user);
      },
    );
  }
  
  //mudar o status de bloqueado
 void toggleUserStatus(Map<String, dynamic> user, VoidCallback setStateCallback) async {
    final updatedUser = user;
    final blocked = user['usu_bloqueado'] ?? false;
    updatedUser['usu_bloqueado'] = !blocked;

    try {
      final response = await supabase
          .from('usuarios')
          .update(updatedUser)
          .match({'usu_id': user['usu_id']});

      if (response != null) {
        if (response.error != null) {
          // Trate o erro ao atualizar o usuário
          print('Erro ao atualizar o usuário: ${response.error}');
          return;
        }
      } else {
        // Trate o caso em que a resposta é nula
        print('Erro ao atualizar o usuário: resposta nula');
      }

      setStateCallback(); // Chama o setState no _UsersScreenState
    } catch (error) {
      // Trate o erro ao atualizar o usuário
      print('Erro ao atualizar o usuário: $error');
    }
  }

  // CRUD
//colocar aqui a função de adicionar usuário e excluir


}