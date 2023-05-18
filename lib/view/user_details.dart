import 'package:flutter/material.dart';

class UserDetailScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserDetailScreen({Key? key, required this.user}) : super(key: key);

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
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}