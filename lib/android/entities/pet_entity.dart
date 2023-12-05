class Pet {
  late int? id;
  String? name;
  final int refOwner;
  final int refCity;
  String? info;

  Pet({
    this.id,
    this.name,
    required this.refOwner,
    required this.refCity,
    this.info,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      refOwner: json['ref_owner'],
      refCity: json['ref_city'],
      info: json['info'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['name'] = name;
    data['ref_owner'] = refOwner;
    data['ref_city'] = refCity;
    data['info'] = info;

    return data;
  }

  void copyFrom(Pet originalPet) {
    id = originalPet.id;
    name = originalPet.name;
    info = originalPet.info;
  }
}
