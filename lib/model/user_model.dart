class User {
  String nome;
  String email;
  String telefone;
  String empresa;
  String cargo;
  String departamento;
  int nivel;
  bool bloqueado;

  User({
    required this.nome,
    required this.email,
    required this.telefone,
    required this.empresa,
    required this.cargo,
    required this.departamento,
    required this.nivel,
    this.bloqueado = false,
  });

  // Adicione outros métodos relevantes, como fromMap() e toMap()
  // para conversão entre instâncias de User e mapas.
}