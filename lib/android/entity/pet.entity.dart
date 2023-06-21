import 'dart:core';

class Pet {
  final int? id;
  final String name;
  final int vaccinated;
  final int refOwner;

  const Pet({
    this.id,
    required this.name,
    required this.vaccinated,
    required this.refOwner,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      vaccinated: json['vaccinated'],
      refOwner: json['ref_owner'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['name'] = name;
    data['vaccinated'] = vaccinated;
    data['ref_owner'] = refOwner;

    return data;
  }

  static String getStatus(int vaccinated) {
    String result = "";

    switch (vaccinated) {
      case 0:
        result = "Não";
        break;
      case 1:
        result = "Sim";
        break;
      case 2:
        result = "Não sei";
        break;
    }
    return result;
  }
}
