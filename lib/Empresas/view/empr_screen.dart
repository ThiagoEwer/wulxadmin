// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../controller/empr_controller.dart';
import 'components/empr_detail.dart';
import 'components/empr_edit.dart';

class EmpresasScreen extends StatefulWidget {
  const EmpresasScreen({Key? key}) : super(key: key);

  @override
  State<EmpresasScreen> createState() => _EmpresasScreenState();
}

class _EmpresasScreenState extends State<EmpresasScreen> {
  final EmpresasController _empresasController = EmpresasController();
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> data = [];
  List<dynamic> listaEmpresas = [];

  //callback do switch de mepresas
  void _toggleEmpresaStatus(Map<String, dynamic> empresa) {
    _empresasController.toggleEmpresaStatus(empresa, () {
      setState(() {
        // Atualize a exibição da empresa com o novo status
        empresa['emp_bloqueado'] = !(empresa['emp_bloqueado'] ?? false);
      });
    });
  }

  //chama a tela de edição.
  void _editarEmpresa(Map<String, dynamic> empresa) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmpresaEditScreen(empresa: empresa),
      ),
    );
  }

  //chama tela de detalhes em forma de bottomSheet
  void _showEmpresaDetails(Map<String, dynamic> empresa) {
    showModalBottomSheet(
      context: context,
      builder: (context) => EmpresaDetailScreen(empresa: empresa),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Empresas'),
      ),
      body: FutureBuilder<PostgrestResponse<dynamic>>(
        future: supabase.from('empresas').select().execute(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final data = snapshot.data!.data;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final empresa = data[index];
                  final blocked = empresa['emp_bloqueado'] ?? false;

                  return Card(
                    elevation: 2,
                    child: ListTile(
                      title: Text(empresa['emp_nome']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Razão: ${empresa['emp_nomecom']}'),
                          Text('Telefone: ${empresa['emp_telefone']}'),
                          Text('CNPJ: ${empresa['emp_cnpj']}'),
                          // Text('Endereço: ${empresa['emp_endereco']}'),
                          Text('Host: ${empresa['emp_host']}'),
                          // Text('Porta: ${empresa['emp_porta']}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: !blocked,
                            onChanged: (value) {
                              _toggleEmpresaStatus(empresa);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Lógica para editar a empresa
                              _editarEmpresa(empresa);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        _showEmpresaDetails(empresa);
                      },
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Erro ao carregar as empresas: ${snapshot.error}');
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
