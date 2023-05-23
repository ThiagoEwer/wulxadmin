// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditUserScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const EditUserScreen({Key? key, required this.user}) : super(key: key);

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _telefoneController;
  late TextEditingController _empresaController;
  late TextEditingController _cargoController;
  late TextEditingController _departamentoController;
  late TextEditingController _nivelController;
  late bool _bloqueado;

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.user['usu_nome']);
    _emailController = TextEditingController(text: widget.user['usu_email']);
    _telefoneController = TextEditingController(text: widget.user['usu_telefone']);
    _empresaController = TextEditingController(text: widget.user['usu_empresa']);
    _cargoController = TextEditingController(text: widget.user['usu_cargo']);
    _departamentoController = TextEditingController(text: widget.user['usu_departamento']);
    _nivelController = TextEditingController(text: widget.user['usu_nivel'].toString());
    _bloqueado = widget.user['usu_bloqueado'] ?? false;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _empresaController.dispose();
    _cargoController.dispose();
    _departamentoController.dispose();
    _nivelController.dispose();
    super.dispose();
  }
  
void _atualizarUsuario(BuildContext context) async {
  if (_formKey.currentState!.validate()) {
    final updatedUser = {
      'usu_id': widget.user['usu_id'],
      'usu_nome': _nomeController.text,
      'usu_email': _emailController.text,
      'usu_telefone': _telefoneController.text,
      'usu_empresa': _empresaController.text,
      'usu_cargo': _cargoController.text,
      'usu_departamento': _departamentoController.text,
      'usu_nivel': int.parse(_nivelController.text),
      'usu_bloqueado': _bloqueado,
    };

    try {
      final response = await supabase.from('usuarios').upsert([updatedUser]);
      if (response.error == null) {
        // Sucesso ao atualizar usuário
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuário atualizado com sucesso!'),
          ),
        );
        Navigator.of(context).pop(); // Fechar a tela de edição
      } else {
        // Erro ao atualizar usuário
        final errorMessage = response.error!.message;
        print('Erro ao atualizar usuário: $errorMessage');
      }
    } catch (e) {
      // Erro ao atualizar usuário
      final errorMessage = e.toString();
      print('Erro ao atualizar usuário: $errorMessage');
    }
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Usuário'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o telefone';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _empresaController,
                decoration: const InputDecoration(labelText: 'Empresa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a empresa';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cargoController,
                decoration: const InputDecoration(labelText: 'Cargo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o cargo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _departamentoController,
                decoration: const InputDecoration(labelText: 'Departamento'),
              ),
              TextFormField(
                controller: _nivelController,
                decoration: const InputDecoration(labelText: 'Nível'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nível';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor, insira um valor numérico';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: const Text('Bloqueado'),
                value: _bloqueado,
                onChanged: (bool value) {
                  setState(() {
                    _bloqueado = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                    ),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () => _atualizarUsuario(context),
                    child: const Text('Salvar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
