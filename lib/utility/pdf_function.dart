import 'package:intl/intl.dart';
import '../app/app_const.dart';
import '../app/domain/db_api_folder.dart';
import '../app/domain/model/folder_model.dart';
import '../app/domain/model/pdf_model.dart';

String formatterDate() {
  final dateTime = DateTime.now();
  final DateFormat formatter = DateFormat.yMd().add_Hms();
  final String formatDate = formatter.format(dateTime);
 // print('dataTime : $formatDate');
  return formatDate;
}

List<PdfModel?> sortListPdf(List<PdfModel?> list) {
  final DateFormat formatter = DateFormat.yMd().add_Hms();

  bool sorted = false;
  while (!sorted) {
    sorted = true;
    for (int i = 1; list.length > i; i++) {
      var dateTimeFirst = formatter.parse(list[i - 1]!.dateTime);
      var dateTimeSecond = formatter.parse(list[i]!.dateTime);
      if (dateTimeFirst.isBefore(dateTimeSecond)) {
        var tmp = list[i];
        list[i] = list[i - 1];
        list[i - 1] = tmp;
        sorted = false;
      }
    }
  }

  return list;
}

List<PdfModel?> comparePdfModel(
    {required List<PdfModel?> listFirst, required List<PdfModel?> listSecond}) {
  var list = <PdfModel?>[];

  for (var modelFirst in listFirst) {
    for (var modelSecond in listSecond) {
      if (modelSecond?.name == modelFirst?.name) {
        list.add(modelSecond);
      }
    }
  }
 // print('ListTest: $list');

  return list;
}

Future<void> initFolderStart(DbApiFolder folderServis) async {
  await folderServis.getListFolderDb().then((listFolder) async {
    if (listFolder.isEmpty) {
      final folderHistory = FolderModel(nameFolder: nameFolderHistory);
      await folderServis.insertFolderDb(folder: folderHistory);
    }
  });
}

String formatterNamePdf(String name, bool reverse) {
  if (reverse) {
    int length = name.length;
    String nameNew = name.substring(0, length - 4);
    return nameNew;
  } else {
    final extension = '.pdf';
    final nameReverse = name + extension;
    return nameReverse;
  }
}
