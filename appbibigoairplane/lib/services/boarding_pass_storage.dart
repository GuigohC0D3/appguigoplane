class BoardingPass {
  final String codigoReserva;
  final Map<String, dynamic> voo;
  final List<String> assentos;
  final bool expirado;

  BoardingPass({
    required this.codigoReserva,
    required this.voo,
    required this.assentos,
    this.expirado = false,
  });

  BoardingPass copyWith({
    String? codigoReserva,
    Map<String, dynamic>? voo,
    List<String>? assentos,
    bool? expirado,
  }) {
    return BoardingPass(
      codigoReserva: codigoReserva ?? this.codigoReserva,
      voo: voo ?? this.voo,
      assentos: assentos ?? this.assentos,
      expirado: expirado ?? this.expirado,
    );
  }

  factory BoardingPass.fromJson(Map<String, dynamic> json) {
    return BoardingPass(
      codigoReserva: json['codigoReserva'],
      voo: Map<String, dynamic>.from(json['voo']),
      assentos: List<String>.from(json['assentos']),
      expirado: json['expirado'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigoReserva': codigoReserva,
      'voo': voo,
      'assentos': assentos,
      'expirado': expirado,
    };
  }
}
