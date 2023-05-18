// ignore_for_file: library_private_types_in_public_api, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wulxadmin/view/user_add.dart';

import 'user_details.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final supabase = Supabase.instance.client;

  void _showUserDetails(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UserDetailScreen(user: user);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: AppBar(
        title: const Text('Usuários Cadastrados'),
      ),*/
      body: FutureBuilder<PostgrestResponse<dynamic>>(
        future: () async {
          try {
            return await supabase.from('usuarios').select().execute();
          } catch (error) {
            print('Erro ao carregar os usuários: $error');
            rethrow;
          }
        }(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final data = snapshot.data!.data;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final user = data[index];
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      title: Text(user['usu_nome']),
                      trailing: Text(user['usu_empresa']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email: ${user['usu_email']}'),
                          Text('Cargo: ${user['usu_cargo']}'),
                        ],
                      ),
                      onTap: () => _showUserDetails(user),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Erro ao carregar os usuários: ${snapshot.error}');
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AddUserDialog();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
