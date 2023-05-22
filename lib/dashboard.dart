import 'package:flutter/material.dart';
import 'package:wulxadmin/Empresas/view/empr_screen.dart';
import 'Usuarios/view/users_screen.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: AppBar(
        title: const Text('WULX ADMIN'),
      ),
      */
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            elevation: 2,
            minWidth: 2,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.selected,
            leading: Image.network(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGUVR8CFwT8nL91wlN-qstwUkNX3-mA4zt5OKn-PjdZgtZ2UixwcDNUkvklw8HgoS_rDs&usqp=CAU',
              width: 120, // Defina a largura desejada
              height: 120,
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text('Usuários'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.business),
                label: Text('Empresas'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.link),
                label: Text("API's Links"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text("Configurações"),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Center(
              child: _getPage(_selectedIndex),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const UsersScreen();
      case 1:
        return const EmpresasScreen();
      case 2:
        return const Center(child: Text('Página de API\'s Links'));
      case 3:
        return const Center(child: Text('Página de Configurações'));
      default:
        return Container();
    }
  }
}
