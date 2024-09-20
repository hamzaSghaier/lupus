import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart';
import 'package:lupus_app/entity/symptome.dart';
import 'package:lupus_app/screens/bilan/models/bilan_model.dart';
import 'package:lupus_app/screens/statistics/rdv_model.dart';
import 'package:path_provider/path_provider.dart';

import '../entity/profile.dart';

class FileService {
  //  Get local folder
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    //Directory appDocDir = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  //  Get local file
  static Future<File> _localFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  static Future<File> downloadFileVideo(String url, String filename) async {
    String extension = ".mp4";

    File file = await _localFile(filename + extension);
    if (file.existsSync()) {
      return file;
    } else {
      http.Client client = http.Client();
      try {
        var req = await client.get(Uri.parse(url));
        if (req.statusCode == 200) {
          var bytes = req.bodyBytes;
          //final file = await _localFile(filename + extension);
          await file.writeAsBytes(bytes);
          client.close();
          return file;
        } else {
          client.close();
          throw Exception(
              'Failed to Download Video . Network connection failed . filename : $filename');
        }
      } catch (e) {
        throw Exception(
            'Failed to Download Video . Network connection failed . filename : $filename');
      }
    }
  }

  static Future<File> writeImageFile(File file, String fileName) async {
    final path = await _localPath;
    // file.rename('$path' + fileName);

    final image = decodeImage(file.readAsBytesSync());

    // Resize the image to a 220x? thumbnail (maintaining the aspect ratio).
    final thumbnail = copyResize(image!, width: 220);

    // Save the thumbnail as a JPG.
    File('$path/$fileName').writeAsBytesSync(encodePng(thumbnail));

    return file;
  }

  // Write
  static Future<File> writeFile(String fileName, String content) async {
    final file = await _localFile(fileName);
    // Write the file.
    return file.writeAsString('$content;', mode: FileMode.append);
  }

  static Future<File> updateFile(String fileName, String content) async {
    final file = await _localFile(fileName);
    String contents = await file.readAsString();
    List<String> c = contents.split(";");
    c.removeWhere((element) => element.isEmpty);
    c.removeLast();
    c.add(content);
    String r = c.join(";");
    print("updating $fileName");
    // Write the file.
    return file.writeAsString('$r;', mode: FileMode.write);
  }

  static Future<File> updateBilan(BilanModel newBilan) async {
    final file = await _localFile("bilans.txt");
    String contents = await file.readAsString();
    List<String> c = contents.split(";");
    List<BilanModel> listbilans = [];
    c.removeWhere((element) => element.isEmpty);
    for (var e in c) {
      listbilans.add(BilanModel.fromJson(jsonDecode(e)));
    }
    listbilans.removeWhere((element) => element.id == newBilan.id);
    c = [];
    for (var e in listbilans) {
      c.add(jsonEncode(e.toJson()));
    }

    await FileService.writeFile(
        "done_bilans.txt", jsonEncode(newBilan.toJson()));

    String r = c.join(";");
    print("updating bilans.txt");
    // Write the file.
    return file.writeAsString('$r;', mode: FileMode.write);
  }

  static Future<File> writeProfileFile(String fileName, String content) async {
    final file = await _localFile(fileName);
    // Write the file.
    return file.writeAsString(content, mode: FileMode.write);
  }

  static Future<String> readFile(String fileName) async {
    try {
      final file = await _localFile(fileName);
      // Read the file
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      // If encountering an error, return 0
      throw Exception('Failed to read file $fileName');
    }
  }

  static Future<void> deleteAllFilesInDirectory() async {
    try {
      final path = await _localPath;
      final directory = Directory(path);

      if (await directory.exists()) {
        final files = directory.list();

        await for (var file in files) {
          if (file is File) {
            await file.delete();
            print('File ${file.path} deleted successfully');
          }
        }
      } else {
        print('Directory $path does not exist');
      }
    } catch (e) {
      throw Exception('Failed to delete files in directory $e');
    }
  }

  static Future<Map<String, dynamic>> getJson(String fileName) async {
    try {
      final file = await _localFile(fileName);

      // Read the file
      String contents = await file.readAsString();

      //Convert to json
      Map<String, dynamic> jsoncontents = json.decode(contents);

      return jsoncontents;
    } catch (e) {
      // If encountering an error, return 0
      throw Exception('Failed to get json, file $fileName | $e');
    }
  }

  static Future<List<SymptomeData>> getSymptomes(String fileName) async {
    try {
      final file = await _localFile(fileName);

      // Read the file
      String contents = await file.readAsString();
      List<SymptomeData> listBilans = [];
      print(fileName);
      contents.split(";").forEach((element) {
        if (element.isNotEmpty && element.isBlank == false) {
          print(jsonDecode(element));
          listBilans.add(SymptomeData.fromJson(jsonDecode(element)));
        }
      });

      return listBilans;
    } catch (e) {
      // If encountering an error, return 0
      throw Exception('Failed to get json, file $fileName | $e');
    }
  }

  static Future<List<BilanModel>> getAllBilans() async {
    try {
      final file = await _localFile("bilans.txt");

      // Read the file
      String contents = await file.readAsString();
      List<BilanModel> listBilans = [];
      print("bilans.txt");
      contents.split(";").forEach((element) {
        if (element.isNotEmpty && element.isBlank == false) {
          print(jsonDecode(element));
          listBilans.add(BilanModel.fromJson(jsonDecode(element)));
        }
      });

      return listBilans.reversed.toList();
    } catch (e) {
      // If encountering an error, return 0
      throw Exception('Failed to get json, file bilans.txt | $e');
    }
  }

  static Future<List<BilanModel>> getDoneBilans() async {
    try {
      final file = await _localFile("done_bilans.txt");

      // Read the file
      String contents = await file.readAsString();
      List<BilanModel> listBilans = [];
      print("done_bilans.txt");
      contents.split(";").forEach((element) {
        if (element.isNotEmpty && element.isBlank == false) {
          print(jsonDecode(element));
          listBilans.add(BilanModel.fromJson(jsonDecode(element)));
        }
      });

      return listBilans.reversed.toList();
    } catch (e) {
      // If encountering an error, return 0
      throw Exception('Failed to get json, file bilans.txt | $e');
    }
  }

  static Future<List<RdvModel>> getRDVs() async {
    try {
      final file = await _localFile("rdv.txt");

      // Read the file
      String contents = await file.readAsString();
      List<RdvModel> listRdv = [];
      print("rdv.txt");
      contents.split(";").forEach((element) {
        if (element.isNotEmpty && element.isBlank == false) {
          print(jsonDecode(element));
          listRdv.add(RdvModel.fromJson(jsonDecode(element)));
        }
      });

      return listRdv;
    } catch (e) {
      // If encountering an error, return 0
      throw Exception('Failed to get json, file rdv.txt | $e');
    }
  }

  static Future<RdvModel?> getLatestRDV() async {
    try {
      final file = await _localFile("rdv.txt");

      // Read the file
      String contents = await file.readAsString();
      List<String> listRdv = [];
      print("rdv.txt");
      print(contents);
      listRdv = contents.split(";");
      listRdv.removeWhere((e) => e.isEmpty);
      RdvModel? latest = RdvModel.fromJson(jsonDecode(listRdv.last));
      if (latest.date.isBefore(DateTime.now())) {
        return null;
      }
      return latest;
    } catch (e) {
      // If encountering an error, return 0
      throw Exception('Failed to get json, file rdv.txt | $e');
      return null;
      //throw Exception('Failed to get json, file rdv.txt | $e');
    }
    return null;
  }

  static Future<List<Remarque>> getRemarques() async {
    try {
      final file = await _localFile("remarques.txt");

      // Read the file
      String contents = await file.readAsString();
      List<Remarque> listRemarques = [];
      contents.split(";").forEach((element) {
        if (element.isNotEmpty && element.isBlank == false) {
          print(jsonDecode(element));
          listRemarques.add(Remarque.fromJson(jsonDecode(element)));
        }
      });

      return listRemarques;
    } catch (e) {
      // If encountering an error, return 0
      throw Exception('Failed to get json, file remarques.txt | $e');
    }
  }

  static Future<Profile> getProfile() async {
    try {
      final file = await _localFile("profile.txt");
      String contents = await file.readAsString();

      // Decode the JSON string and create a Profile object
      final Map<String, dynamic> profileMap = jsonDecode(contents);
      final Profile profile = Profile.fromJson(profileMap);

      return profile;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<Profile?> getProfileByLogin(tel, password) async {
    try {
      final file = await _localFile("profile.txt");
      String contents = await file.readAsString();

      // Decode the JSON string and create a Profile object
      final Map<String, dynamic> profileMap = jsonDecode(contents);
      print(profileMap);
      Profile profile = Profile.fromJson(profileMap);
      if (profile.numTel == tel && profile.password == password) {
        profile = await updateProfileIsLogged(true) ?? profile;
        return profile;
      }
      return null;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<Profile?> updateProfileIsLogged(isLoggedIn) async {
    try {
      final file = await _localFile("profile.txt");
      String contents = await file.readAsString();

      // Decode the JSON string and create a Profile object
      final Map<String, dynamic> profileMap = jsonDecode(contents);
      final Profile profile = Profile.fromJson(profileMap);
      profile.isLoggedIn = isLoggedIn;
      final jsonProfile =
          jsonEncode(profile.toJson()); // Convert Profile to JSON string
      await FileService.writeProfileFile("profile.txt", jsonProfile);

      return profile;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<Symptome?> getlatestSymptomes() async {
    try {
      final file = await _localFile("symptomes_log.txt");

      // Read the file
      String contents = await file.readAsString();
      List<String> c = contents.split(";");
      c.removeWhere((element) => element.isEmpty);

      if (c.isNotEmpty) {
        return Symptome.fromJson(jsonDecode(c.last));
      }
    } catch (e) {
      // If encountering an error, return 0
      return null;
    }
    return null;
  }

  static Future<Symptome> updatelatestSymptomes(Symptome newSymp) async {
    try {
      final file = await _localFile("symptomes_log.txt");

      // Read the file
      String contents = await file.readAsString();
      List<String> c = contents.split(";");
      c.removeWhere((element) => element.isEmpty);
      Symptome lastSymp = Symptome.fromJson(jsonDecode(c.removeLast()));
      print(lastSymp.toJson());
      writeFile("symptomes_log.txt", jsonEncode(newSymp.toJson()));
      return newSymp;
    } catch (e) {
      // If encountering an error, return 0
      throw Exception('Failed to get json, file symptomes_log.txt | $e');
    }
  }
}
