// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({Key? key}) : super(key: key);

  @override
  _AddUserDialogState createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _empresaController = TextEditingController();
  final TextEditingController _cargoController = TextEditingController();
  final TextEditingController _departamentoController = TextEditingController();
  final TextEditingController _nivelController = TextEditingController();
  bool _bloqueado = false;

  final supabase = Supabase.instance.client;

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

//função adiciona apesar do erro no terminal. 
  void _cadastrarUsuario(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final newUser = {
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
        final response = await supabase.from('usuarios').upsert([newUser]);
        if (response.error == null) {
          // Sucesso ao cadastrar usuário
          Navigator.of(context).pop(); // Fechar o Dialog de cadastro
          Navigator.of(context).pop(); // Voltar para a tela anterior
        } else {
          // Erro ao cadastrar usuário
          final errorMessage = response.error!.message;
          print('Erro ao cadastrar usuário: $errorMessage');
        }
      } catch (e) {
        // Erro ao cadastrar usuário
        final errorMessage = e.toString();
        print('Erro ao cadastrar usuário: $errorMessage');
      } finally {
        // Independente de sucesso ou erro, fechar o Dialog e voltar para a tela anterior
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar Usuário'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
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
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => _cadastrarUsuario(context),
          child: const Text('Cadastrar'),
        ),
      ],
    );
  }
}