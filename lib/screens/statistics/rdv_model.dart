class RdvModel {
  int? id;
  DateTime date;
  String title, type, dateProchaineConsultation;

  RdvModel({
    this.id,
    required this.date,
    required this.title,
    required this.type,
    required this.dateProchaineConsultation,
  });

  factory RdvModel.fromJson(Map<String, dynamic> json) {
    return RdvModel(
        id: json['id'],
        date: DateTime.parse(json['date']),
        title: json['title'],
        dateProchaineConsultation: json['dateProchaineConsultation'],
        type: json['type']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['date'] = date.toIso8601String();
    data["dateProchaineConsultation"] = dateProchaineConsultation;
    data["type"] = type;
    return data;
  }
}
