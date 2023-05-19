// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, unused_element
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
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showUserDetails(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UserDetailScreen(user: user);
      },
    );
  }

  void _searchUsers(String query) {
    // Lógica para filtrar os usuários com base na pesquisa
    // Atualize a exibição da lista com os resultados da pesquisa
  }

  void _viewUser() {
    // Lógica para visualizar o usuário selecionado
  }

  void _editUser() {
    // Lógica para editar o usuário selecionado
  }

  void _deleteUser() async {
    // Lógica para excluir o usuário
  }
   //mudar o status de bloqueado
  void _toggleUserStatus(Map<String, dynamic> user) async {
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

    // Atualize a exibição do usuário com o novo status
    setState(() {
      user['usu_bloqueado'] = !blocked;
    });
  } catch (error) {
    // Trate o erro ao atualizar o usuário
    print('Erro ao atualizar o usuário: $error');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários Cadastrados'),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            // Lógica para realizar a pesquisa
                            _searchUsers(_searchController.text);
                          },
                          icon: const Icon(Icons.search),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Pesquisar',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AddUserDialog();
                      },
                    );
                  },
                  icon: const Icon(Icons.add),
                ),
                IconButton(
                  onPressed: _viewUser,
                  icon: const Icon(Icons.remove_red_eye),
                ),
                IconButton(
                  onPressed: _editUser,
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: _deleteUser,
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildUserList(),
          ),
        ],
      ), /*
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
      ), */
    );
  }

  Widget _buildUserList() {
    return FutureBuilder<PostgrestResponse<dynamic>>(
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
                final blocked = user['usu_bloqueado'] ?? false;

                return Card(
                  elevation: 2,
                  child: ListTile(
                    title: Text(user['usu_nome']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cargo: ${user['usu_cargo']}'),
                        Text('Empresa: ${user['usu_empresa']}'),
                      ],
                    ),
                    trailing: Switch(
                      value: !blocked,
                      onChanged: (value) => _toggleUserStatus(user),
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
    );
  }
}