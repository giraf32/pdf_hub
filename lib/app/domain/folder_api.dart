import 'package:pdf_hub/app/domain/model/folder_model.dart';

abstract class FolderApi{
  Future<void> insertFolder({required FolderModel folder});
  Future<void> updateFolder({required FolderModel folder});
  Future<List<FolderModel?>> getListFolder();
  Future<void> deleteFolder({required int? id});

}