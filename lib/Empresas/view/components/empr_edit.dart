// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmpresaEditScreen extends StatefulWidget {
  final Map<String, dynamic> empresa;

  const EmpresaEditScreen({Key? key, required this.empresa}) : super(key: key);

  @override
  _EmpresaEditScreenState createState() => _EmpresaEditScreenState();
}

class _EmpresaEditScreenState extends State<EmpresaEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;
  

  late TextEditingController _nomeController;
  late TextEditingController _nomecomController;
  late TextEditingController _telefoneController;
  late TextEditingController _cnpjController;
  late TextEditingController _enderecoController;
  late TextEditingController _hostController;
  late TextEditingController _portaController;
  late bool _bloqueado;

  @override
  void initState() {
    super.initState();

    _nomeController = TextEditingController(text: widget.empresa['emp_nome']);
    _nomecomController = TextEditingController(text: widget.empresa['emp_nomecom']);
    _telefoneController = TextEditingController(text: widget.empresa['emp_telefone']);
    _cnpjController = TextEditingController(text: widget.empresa['emp_cnpj']);
    _enderecoController = TextEditingController(text: widget.empresa['emp_endereco']);
    _hostController = TextEditingController(text: widget.empresa['emp_host']);
    _portaController = TextEditingController(text: widget.empresa['emp_porta'].toString());
    _bloqueado = widget.empresa['emp_bloqueado'] ?? false;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _nomecomController.dispose();
    _telefoneController.dispose();
    _cnpjController.dispose();
    _enderecoController.dispose();
    _hostController.dispose();
    _portaController.dispose();

    super.dispose();
  }

  void _salvarEdicao(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final updatedEmpresa = {
        'emp_id': widget.empresa['emp_id'],
        'emp_nome': _nomeController.text,
        'emp_nomecom': _nomecomController.text,
        'emp_telefone': _telefoneController.text,
        'emp_cnpj': _cnpjController.text,
        'emp_endereco': _enderecoController.text,
        'emp_host': _hostController.text,
        'emp_porta': int.parse(_portaController.text),
        'emp_bloqueado': _bloqueado,
      };

      try {
        final response = await supabase.from('empresas').upsert([updatedEmpresa]);
        if (response.error == null) {
          // Sucesso ao atualizar empresa
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Empresa atualizada com sucesso!'),
            ),
          );
          Navigator.of(context).pop(); // Fechar a tela de edição
        } else {
          // Erro ao atualizar empresa
          final errorMessage = response.error!.message;
          print('Erro ao atualizar empresa: $errorMessage');
        }
         Navigator.of(context).pop();
      } catch (e) {
        // Erro ao atualizar empresa
        final errorMessage = e.toString();
        print('Erro ao atualizar empresa: $errorMessage');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Empresa'),
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
                controller: _nomecomController,
                decoration: const InputDecoration(labelText: 'Nome Comercial'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome comercial';
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
                controller: _cnpjController,
                decoration: const InputDecoration(labelText: 'CNPJ'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o CNPJ';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _enderecoController,
                decoration: const InputDecoration(labelText: 'Endereço'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o endereço';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _hostController,
                decoration: const InputDecoration(labelText: 'Host'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o host';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _portaController,
                decoration: const InputDecoration(labelText: 'Porta'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a porta';
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
                    onPressed: () => _salvarEdicao(context),
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