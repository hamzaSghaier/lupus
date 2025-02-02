class BilanModel {
  String? id;
  String? type;
  String? date;
  String? image;        // keep for backward compatibility
  List<String>? images; // new field for multiple images
  bool done = false;
  bool? hasReminder;    // new field for reminder functionality

  BilanModel({
    this.id, 
    this.type, 
    this.date, 
    this.image, 
    this.images, 
    this.hasReminder,
  });

  BilanModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    date = json['date'];
    image = json['image'];
    done = json['done'] ?? false;
    hasReminder = json['hasReminder'];
    images = json['images'] != null ? List<String>.from(json['images']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['date'] = date;
    data['image'] = image;
    data['done'] = done;
    data['hasReminder'] = hasReminder;
    data['images'] = images;
    return data;
  }
}