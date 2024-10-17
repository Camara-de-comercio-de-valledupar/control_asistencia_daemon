class Assistance {
  final int id;
  final DateTime createdAt;

  Assistance({
    required this.id,
    required this.createdAt,
  });

  factory Assistance.fromJson(Map<String, dynamic> json) {
    return Assistance(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
