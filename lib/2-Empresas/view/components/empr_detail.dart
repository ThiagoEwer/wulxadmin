import 'package:flutter/material.dart';
class EmpresaDetailScreen extends StatelessWidget {
  final Map<String, dynamic> empresa;

  const EmpresaDetailScreen({Key? key, required this.empresa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Empresa'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${empresa['emp_nome']}'),
            Text('Razão: ${empresa['emp_nomecom']}'),
            Text('Telefone: ${empresa['emp_telefone']}'),
            Text('CNPJ: ${empresa['emp_cnpj']}'),
            Text('Endereço: ${empresa['emp_endereco']}'),
            Text('Host: ${empresa['emp_host']}'),
            Text('Porta: ${empresa['emp_porta']}'),
            Text('Bloqueado: ${empresa['emp_bloqueado']}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implemente a lógica para editar a empresa
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}