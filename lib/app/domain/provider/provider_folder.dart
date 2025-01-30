import 'dart:developer';

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
      log('Error updateListFolder: $e', stackTrace: s);
    }
    notifierStateFolder = NotifierStateFolder.loaded;
    notifyListeners();
  }

  Future<void> saveFolder(FolderModel folder) async {
    try {
      await folderRepository.insertFolder(folder: folder);
    } catch (e, s) {
      log('Error saveFolder: $e', stackTrace: s);
    }
    updateListFolder();
  }

  Future<void> deleteFolder(int? id) async {
    try {
      await folderRepository.deleteFolder(id: id);
    } catch (e, s) {
      log('Error deleteFolder: $e', stackTrace: s);
    }
    updateListFolder();
  }

  Future<void> updateFolder(FolderModel folder) async {
    try {
      await folderRepository.updateFolder(folder: folder);
    } catch (e, s) {
      log('Error updateFolder: $e', stackTrace: s);
    }
    updateListFolder();
  }
}
