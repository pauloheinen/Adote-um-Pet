class UserFile {
  final int? id;
  final int refOwner;
  final String item;

  const UserFile({
    required this.id,
    required this.refOwner,
    required this.item,
  });

  factory UserFile.fromJson(Map<String, dynamic> json) {
    return UserFile(
      id: json['id'],
      refOwner: json['refOwner'],
      item: json['item'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['refOwner'] = refOwner;
    data['item'] = item.toString();

    return data;
  }
}
