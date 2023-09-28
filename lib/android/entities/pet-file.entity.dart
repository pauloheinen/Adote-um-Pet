class PetFile {
  final int? id;
  final int refPet;
  final String item;

  const PetFile({
    this.id,
    required this.refPet,
    required this.item,
  });

  factory PetFile.fromJson(Map<String, dynamic> json) {
    return PetFile(
      id: json['id'],
      refPet: json['ref_pet'],
      item: json['item'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['ref_pet'] = refPet;
    data['item'] = item.toString();

    return data;
  }
}
