import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:lupus_app/entity/symptome.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart';
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

  static Future<List<SymptomeData>> getBilans(String fileName) async {
    try {
      final file = await _localFile(fileName);

      // Read the file
      String contents = await file.readAsString();
      List<SymptomeData> listBilans = [];
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
}
