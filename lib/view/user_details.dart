import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserDetailScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserDetailScreen({Key? key, required this.user}) : super(key: key);
  
  void _excluirUsuario(BuildContext context, SupabaseClient supabase) async {
    // Exibir um AlertDialog de confirmação antes de excluir o usuário
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Usuário'),
        content: const Text('Tem certeza de que deseja excluir este usuário?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sim'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Não'),
          ),
        ],
      ),
    );

    // Se o usuário confirmou a exclusão
    if (result == true) {
      // Exclua o usuário atual do banco de dados
      final response = await supabase
          .from('usuarios')
          .delete()
          .match({'usu_id': user['usu_id']});

      if (response.error != null) {
        // Erro ao excluir usuário
        final errorMessage = response.error!.message;
        print('Erro ao excluir usuário: $errorMessage');
      } else {
        // Sucesso ao excluir usuário
         Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Detalhes do Usuário'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${user['usu_nome']}'),
            Text('Email: ${user['usu_email']}'),
            Text('Telefone: ${user['usu_telefone']}'),
            Text('Empresa: ${user['usu_empresa']}'),
            Text('Cargo: ${user['usu_cargo']}'),
            Text('Departamento: ${user['usu_departamento']}'),
            Text('Nível: ${user['usu_nivel']}'),
            Text('Bloqueado: ${user['usu_bloqueado']}'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => _excluirUsuario(context, Supabase.instance.client),
          child: const Text('Excluir'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
