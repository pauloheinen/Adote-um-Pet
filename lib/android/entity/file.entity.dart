class File {
  final int? id;
  final int type;
  final int refOwner;
  final String item;

  static int profilePhoto = 0;
  static int petPhoto = 1;

  const File({
    required this.id,
    required this.type,
    required this.refOwner,
    required this.item,
  });

  factory File.fromJson(Map<String, dynamic> json) {
    return File(
      id: json['id'],
      type: json['type'],
      refOwner: json['refOwner'],
      item: json['item'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['type'] = type;
    data['refOwner'] = refOwner;
    data['item'] = item.toString();

    return data;
  }
}
