import 'package:flutter/material.dart';
import 'package:pdf_hub/app/app_const.dart';
import 'package:pdf_hub/app/data/db_app/db_services_folder.dart';
import 'package:pdf_hub/app/data/db_app/db_services_pdf.dart';
import 'package:pdf_hub/app/data/db_app/init_db.dart';
import 'package:pdf_hub/app/domain/provider/provider_folder.dart';
import 'package:pdf_hub/app_router/app_router.dart';
import 'package:pdf_hub/di/app_depends.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'app/domain/provider/provider_folder_pdf.dart';
import 'app/domain/provider/provider_pdf.dart';

//String settingsKeyFirstPages = 'firstPages';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Database? db = await InitDb.create().database;
  final dbServicesFolder = DbServicesFolder(db: db!);
  final dbServicesPdf = DbServicesPdf(db: db);

  final dependsRepo =
      AppDepends(dbApiFolder: dbServicesFolder, dbApiPdf: dbServicesPdf);
 await dependsRepo.init(
    onError: (name, error, stackTrace) {
      throw '$name: $error: $stackTrace';
    },
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProviderPDF(pdfRepository: dependsRepo.pdfRepo),
        ),
        ChangeNotifierProvider(
          create: (context) => ProviderFolder(folderRepository: dependsRepo.folderRepo),
        ),
        ChangeNotifierProvider(
          create: (context) => ProviderFolderPdf(pdfRepository: dependsRepo.folderPdfRepo),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _router = AppRouter();

  @override
  void initState() {
    context.read<ProviderPDF>().updatePdfListModelHistory();
    context.read<ProviderFolder>().updateListFolder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      builder: (context, child) {
        final deviceData = MediaQuery.of(context);
        final constraintDataText = MediaQuery.textScalerOf(context).clamp(
            minScaleFactor: minPossibleTsf, maxScaleFactor: maxPossibleTsf);

        return MediaQuery(
            data: deviceData.copyWith(textScaler: constraintDataText),
            child: child ?? const SizedBox.shrink());
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.black, fontSize: 20),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.cyan, width: 5)),
        ),
        cardColor: Colors.grey.shade200,
        canvasColor: Colors.white,
        primaryColor: Colors.red.shade600,
        scaffoldBackgroundColor: Colors.white,
        // textTheme: TextTheme(),
        useMaterial3: true,
      ),
      routerConfig: _router.config(),
    );
  }
}
