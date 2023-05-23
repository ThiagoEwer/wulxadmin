import 'package:flutter/material.dart';

class ModuleScreen extends StatelessWidget {
  ModuleScreen({Key? key}) : super(key: key);
  
  final List<String> modules = [
    'COMPRAS',
    'FATURAMENTO',
    'VENDAS',
    'FINANCEIRO',
    'ESTOQUE',
    'ARMAZEM',
    'PCP',
    'RH',
    'CONTABILIDADE',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Módulos'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0, // Reduzindo o espaçamento horizontal
          mainAxisSpacing: 8.0, // Reduzindo o espaçamento vertical
        ),
        itemCount: modules.length,
        itemBuilder: (context, index) {
          return ModuleCard(moduleName: modules[index]);
        },
      ),
    );
  }
}

class ModuleCard extends StatelessWidget {
  final String moduleName;

  const ModuleCard({Key? key, required this.moduleName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          // Ação quando o card for pressionado
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.category,
                size: 24.0, // Reduzindo o tamanho do ícone
              ),
              const SizedBox(height: 4.0),
              Text(
                moduleName,
                style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold), // Reduzindo o tamanho do texto
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
