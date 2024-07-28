class BilanModel {
  String? id;
  String? type;
  String? date;
  String? image;
  bool done = false;

  BilanModel({this.id, this.type, this.date, this.image});

  BilanModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    date = json['date'];
    image = json['image'];
    done = json['done'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['date'] = date;
    data['image'] = image;
    data['done'] = done;
    return data;
  }
}
