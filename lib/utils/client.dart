class Client {
  int? id;
  String name;
  String age;
  String? hiredDate;

  Client({
    this.id,
    required this.name,
    required this.age,
    this.hiredDate,
  });


  factory Client.fromJson(Map<String, dynamic> json) => Client(
        id: json['id'] as int,
        name: json['name'] as String,
        age: json['age'] as String,
        hiredDate: json['create_at'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'create_at': hiredDate,
      };

  Client copyWith({
    int? id,
    String? name,
    String? age,
    String? hiredDate,
  }) {
    return Client(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      hiredDate: hiredDate ?? this.hiredDate,
    );
  }
}
