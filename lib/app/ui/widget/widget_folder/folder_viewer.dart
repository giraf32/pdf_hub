import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pdf_hub/app/domain/model/folder_model.dart';
import 'package:pdf_hub/app/ui/widget/widget_folder/delete_rename_folder.dart';
import 'package:pdf_hub/app_router/app_router.gr.dart';



class FolderViewer extends StatefulWidget {
  const FolderViewer({super.key, required this.folderModel});

  final FolderModel folderModel;
  // final _id;

  @override
  State<FolderViewer> createState() => _FolderViewerState();
}

class _FolderViewerState extends State<FolderViewer> {


  @override
  Widget build(BuildContext context) {
   
    return ListTile(

      subtitle: Text(widget.folderModel.nameFolder,
          textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
      title: Image.asset('assets/icon_folder.jpg'),

      onTap: () => context.router
          .push(FolderPdfList(nameFolder: widget.folderModel.nameFolder)),
      //OpenListPdfFolder().openPDFRoute(context, folderModel.nameFolder),
      onLongPress: () {

        showBottomSheet(
           // isScrollControlled: true,
            context: context,
            builder: (context) =>
                DeleteRenameFolder(id: widget.folderModel.id, folderModel: widget.folderModel));
      },
    );


  }
}
