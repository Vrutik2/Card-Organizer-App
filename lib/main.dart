import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

final dbHelper = DatabaseHelper();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dbHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Organizer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('sqflite'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _insertFolder,
              child: const Text('Insert Folder'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _queryFolders,
              child: const Text('Query Folder'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updateFolder,
              child: const Text('Update Folder'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _deleteFolder,
              child: const Text('Delete Folder'),
            ),
          ],
        ),
      ),
    );
  }


 void _insertFolder() async {
    Map<String, dynamic> row = {
      DatabaseHelper.folderName: 'Hearts',
      DatabaseHelper.columnSuit: 'Hearts'
    };
    final id = await dbHelper.insert(row);
    debugPrint('Inserted folder with id: $id');
  }

  
  void _queryFolders() async {
    final allRows = await dbHelper.queryAllRows();
    debugPrint('Query all folders:');
    for (final row in allRows) {
      debugPrint(row.toString());
    }
  }


  void _updateFolder() async {
    Map<String, dynamic> row = {
      DatabaseHelper.folderId: 1, 
      DatabaseHelper.folderName: 'Red Cards', 
      DatabaseHelper.columnSuit: 'Hearts',
    };
    final rowsAffected = await dbHelper.update(row);
    debugPrint('Updated $rowsAffected folder(s)');
  }


  void _deleteFolder() async {
    final id = 1; 
    final rowsDeleted = await dbHelper.delete(id);
    debugPrint('Deleted $rowsDeleted folder(s): folder $id');
  }
}