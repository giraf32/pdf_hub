import 'package:flutter/material.dart';
import 'package:pdf_hub/app/domain/folder_api.dart';
import 'package:pdf_hub/app/domain/model/folder_model.dart';



enum NotifierStateFolder { initial, loading, loaded }

class ProviderFolder extends ChangeNotifier {
  ProviderFolder({required this.folderRepository});
  final FolderApi folderRepository;

  // final _folderRepository =
  //     FolderRepository(dbServicesFolder: DbServicesFolder(InitDb.create()));

  NotifierStateFolder notifierStateFolder = NotifierStateFolder.initial;

  var listFolder = <FolderModel?>[];

  Future<void> updateListFolder() async {
    try {
      notifierStateFolder = NotifierStateFolder.loading;

      listFolder = await folderRepository.getListFolder();
    } catch (e, s) {
      print('Error updateListFolder: $e');
      print('Error updateListFolder: $s');
    }
    notifierStateFolder = NotifierStateFolder.loaded;
    notifyListeners();
  }

  Future<void> saveFolder(FolderModel folder) async {
    try {
      await folderRepository.insertFolder(folder: folder);
    } catch (e, s) {
      print('Error saveFolder: $e');
      print('Error saveFolder: $s');
    }
    updateListFolder();
  }

  Future<void> deleteFolder(int? id) async {
    try {
      await folderRepository.deleteFolder(id: id);
    } catch (e, s) {
      print('Error deleteFolder: $e');
      print('Error deleteFolder: $s');
    }
    updateListFolder();
  }

  Future<void> updateFolder(FolderModel folder) async {
    try {
      await folderRepository.updateFolder(folder: folder);
    } catch (e, s) {
      print('Error updateFolder: $e');
      print('Error updateFolder: $s');
    }
    updateListFolder();
  }
}
