import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';

class Storage {
  static Future<void> _userCreated = _createUserFolders();
  static final _auth = FirebaseAuth.instance;

  static Future<void> loadUser() async {
    _userCreated = _createUserFolders();
    await _userCreated;
  }

  static Future<String> getUserDatabasesDirectory() async {
    await _userCreated;
    return _getUserDatabasesDirectory();
  }
  static Future<String> getUserDocumentsDirectory() async {
    await _userCreated;
    return _getUserDocumentsDirectory();
  }
  static Future<String> getFilePath(String fileName) async {
    await _userCreated;
    return _getFilePath(fileName);
  }
  static Future<String> getUserDirectory() async {
    await _userCreated;
    return _getUserDirectory();
  }

  static Future<File> getDocumentFile(int id, String name) async {
    await _userCreated;

    // Create document folder in documents directory
    String documentDirPath = Path.join(await _getUserDocumentsDirectory(), id.toString());
    var documentDir = Directory(documentDirPath);
    await _createFolder(documentDir);

    // Create the document
    String filePath = Path.join(documentDirPath, name)+'.pdf';
    File file = File(filePath);

    return file;
  }
  static Future<String> _getCurrentUserUid() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        return user.uid;
      }
    }
    catch (e) {
      print(e);
    }
    return "";
  }

  static Future<String> _getUserDatabasesDirectory() async {
    return Path.join(await _getUserDirectory(), "databases");
  }
  static Future<String> _getUserDocumentsDirectory() async {
    return Path.join(await _getUserDirectory(), "documents");
  }
  static Future<String> _getFilePath(String fileName) async {
    return Path.join(await _getUserDirectory(), fileName);
  }
  static Future<String> _getUserDirectory() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    // TODO: Dodati UUID preko pravog korisnika
    var userName = await _getCurrentUserUid();
    var dirPath = Path.join(appDocumentsPath, "users", userName);
    return dirPath;
  }
  static Future<void> _createUserFolders() async {
    print("Creating user directory");
    final Directory usrFolder =  Directory(await _getUserDirectory());
    final Directory usrDocFolder =  Directory(await _getUserDocumentsDirectory());
    final Directory usrDbFolder =  Directory(await _getUserDatabasesDirectory());

    await _createFolder(usrFolder);
    await _createFolder(usrDocFolder);
    await _createFolder(usrDbFolder);
  }

  static Future<void> _createFolder(Directory usrFolder) async {
    if (await usrFolder.exists()) {
      print("Skipping - "+ usrFolder.path);
    } else{
      print("Creating - "+ usrFolder.path);
      await usrFolder.create(recursive: true);
    }
  }

}