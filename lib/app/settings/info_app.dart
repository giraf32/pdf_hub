import 'package:flutter/material.dart';

class InfoApp extends StatelessWidget {
  const InfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Info'),
          backgroundColor: Colors.red,
        ),
        body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Данное приложение предназначено для работы с файлами формата PDF.'
                ' Оно не только открывает файлы, но и предоставляет удобный и быстрый способ работы с ними.\n'
                ' Обратите внимание: \n'
                '1. При добавлении PDF-файла в приложение создаётся его копия в памяти программы.'
                ' Вы можете открыть файл через приложение, но через один-два дня система автоматически удалит временную копию.\n'
                '2. Если вы часто работаете с определёнными файлами, создайте папку и добавьте их туда.'
                ' В этом случае файлы будут храниться в приложении постоянно.\n'
                '3. В приложении вы можете переименовывать, отправлять или удалять файлы. '
                ' Это не повлияет на исходный файл на вашем устройстве.\n'
                '4. Если вы решите удалить приложение, все добавленные файлы и папки будут удалены вместе с ним.',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              const SizedBox(
                height: 100,
              )
            ])));
  }
}
