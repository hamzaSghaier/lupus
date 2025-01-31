import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
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
          throw Exception('Failed to Download Video . Network connection failed . filename : $filename');
        }
      } catch (e) {
        throw Exception('Failed to Download Video . Network connection failed . filename : $filename');
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
    try {
      final file = await _localFile("bilans.txt");
      String contents = await file.readAsString();
      List<String> entries = contents.split(";");
      List<BilanModel> listBilans = [];

      // Remove empty entries
      entries.removeWhere((element) => element.isEmpty);

      // Convert all entries to BilanModel objects
      for (var entry in entries) {
        listBilans.add(BilanModel.fromJson(jsonDecode(entry)));
      }

      // Find and update the matching bilan
      int bilanIndex = listBilans.indexWhere((bilan) => bilan.id == newBilan.id);

      if (bilanIndex != -1) {
        // Only move to done_bilans if the bilan is marked as done
        if (newBilan.done && !listBilans[bilanIndex].done) {
          // Remove from main list and add to done_bilans
          listBilans.removeAt(bilanIndex);
          await FileService.writeFile("done_bilans.txt", jsonEncode(newBilan.toJson()));
        } else {
          // Just update the bilan in the main list
          listBilans[bilanIndex] = newBilan;
        }
      }

      // Convert back to JSON strings
      List<String> updatedEntries = listBilans.map((bilan) => jsonEncode(bilan.toJson())).toList();

      // Join with semicolons and add final semicolon
      String result = "${updatedEntries.join(';')};";

      // Write back to file
      return file.writeAsString(result, mode: FileMode.write);
    } catch (e) {
      print('Error updating bilan: $e');
      rethrow;
    }
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
      // throw Exception('Failed to get json, file bilans.txt | $e');
      return [];
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
      String contents = await file.readAsString();
      List<RdvModel> listRdv = [];

      if (contents.isNotEmpty) {
        final entries = contents.split(";").where((element) => element.isNotEmpty && element.isBlank == false);

        for (var element in entries) {
          try {
            final rdv = RdvModel.fromJson(jsonDecode(element));
            listRdv.add(rdv);
          } catch (e) {
            debugPrint('Error parsing RDV: $e');
            // Continue with next entry if one fails
            continue;
          }
        }

        // Sort RDVs by date, most recent first
        listRdv.sort((a, b) => b.date.compareTo(a.date));
      }

      return listRdv;
    } catch (e) {
      debugPrint('Error reading RDVs: $e');
      return []; // Return empty list instead of throwing
    }
  }

  static Future<void> deleteRdv(RdvModel rdv) async {
    try {
      final file = await _localFile("rdv.txt");
      String contents = await file.readAsString();
      List<String> entries = contents.split(";");
      List<RdvModel> listRdv = [];

      // Remove empty entries and convert to RdvModel
      entries.removeWhere((element) => element.isEmpty);
      for (var e in entries) {
        final currentRdv = RdvModel.fromJson(jsonDecode(e));
        if (currentRdv.id != rdv.id) {
          listRdv.add(currentRdv);
        }
      }

      // Convert back to string and write to file
      String updatedContent = listRdv.map((rdv) => jsonEncode(rdv.toJson())).join(';');
      await file.writeAsString('$updatedContent;', mode: FileMode.write);

      // Cancel the notification if it exists
      // Convert the ID to a 32-bit integer
      if (rdv.id != null) {
        final notificationId = rdv.id!.abs() % 100000; // Keep last 5 digits
        await AwesomeNotifications().cancel(notificationId);
      }
    } catch (e) {
      debugPrint('Error deleting RDV: $e');
      rethrow;
    }
  }

  static Future<RdvModel?> getLatestRDV() async {
    try {
      final rdvs = await getRDVs();

      // Filter future RDVs and sort by date
      final futureRdvs = rdvs.where((rdv) => rdv.date.isAfter(DateTime.now())).toList()..sort((a, b) => a.date.compareTo(b.date));

      // Return the earliest future RDV
      return futureRdvs.isNotEmpty ? futureRdvs.first : null;
    } catch (e) {
      debugPrint('Error getting latest RDV: $e');
      return null;
    }
  }

  static Future<File> updateRdvFile(List<RdvModel> rdvs) async {
    final file = await _localFile("rdv.txt");
    final content = rdvs.map((rdv) => jsonEncode(rdv.toJson())).join(';');
    return await file.writeAsString('$content;', mode: FileMode.write);
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
      final jsonProfile = jsonEncode(profile.toJson()); // Convert Profile to JSON string
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
