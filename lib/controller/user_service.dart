import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  static final supabase = Supabase.instance.client;

  //delete usuario por ID.
  static Future<void> deleteUser(int id) async {
    final response = await supabase
        .from('usuarios')
        .delete()
        .match({'id': id});

    if (response.error != null) {
      throw Exception('Erro ao excluir o usuário: ${response.error!.message}');
    }
  }
  
}