class BilanModel {
  int? id;
  String? type;
  String? date;
  String? image;

  BilanModel({this.id, this.type, this.date, this.image});

  BilanModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    date = json['date'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['date'] = date;
    data['image'] = image;
    return data;
  }
}
