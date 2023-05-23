// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, unused_element
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controller/user_controller.dart';
import 'components/user_add.dart';
import 'components/user_edit.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final supabase = Supabase.instance.client;
  late TextEditingController _searchController;
  late UsersController _usersController;

//callback para atualizar o status do usuário
  void _toggleUserStatus(Map<String, dynamic> user) {
    _usersController.toggleUserStatus(user, () {
      setState(() {
        // Atualize a exibição do usuário com o novo status
        user['usu_bloqueado'] = !(user['usu_bloqueado'] ?? false);
      });
    });
  }
  
//callback para editar usuário
  void _editUser(Map<String, dynamic> user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserScreen(user: user),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _usersController = UsersController(context);
    _searchController = TextEditingController(); // Passe o contexto aqui
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
                  onPressed: () {
                  },
                  icon: const Icon(Icons.refresh),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.remove_red_eye),
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildUserList(),
          ),
        ],
      ),
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: !blocked,
                          onChanged: (value) => _toggleUserStatus(user),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _editUser(user);
                          },
                        ),
                      ],
                    ),
                    onTap: () => _usersController.showUserDetails(user),
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
