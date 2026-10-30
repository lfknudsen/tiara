import 'package:flutter/material.dart';
import 'package:tiara/components.dart';
import 'package:file_picker/file_picker.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key, required this.title});

  final String title;

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class FileTile extends ListTile {
  const FileTile({super.key, required this.file, super.title});

  final PlatformFile file;
}

class _UploadPageState extends State<UploadPage> {
  List<FileTile> files = [];
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
  }

  Future<void> removeFile(PlatformFile file) async {
    try {
      setState(() {
        files = files.where((tile) => tile.file.uri != file.uri).toList();
      });
    } catch (e) {
      _error = e.toString();
    }
  }

  Future<void> chooseFiles() async {
    try {
      _loading = true;
      List<PlatformFile> fileList = await FilePicker.pickFiles();
      List<FileTile> outputList = [];
      for (final file in fileList) {
        final newTile = newFileTile(null, file);
        outputList.add(newTile);
      }
      setState(() {
        outputList.addAll(files);
        files = outputList;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  FileTile newFileTile(Key? key, PlatformFile src) {
    final title = Column(
      mainAxisAlignment: .center,
      crossAxisAlignment: .center,
      children: [
        Row(
          children: [
            Icon(Icons.description),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [Text(src.name)],
              ),
            ),
            IconButton(
              onPressed: () => {removeFile(src)},
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ],
    );
    return FileTile(key: key, file: src, title: title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            IconTextButton(chooseFiles, Icons.attach_file, "Choose files"),
            _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? Center(child: Text("Error: $_error"))
                : files == []
                ? const Center(child: Text("Add files to see them here..."))
                : Expanded(child: ListView(children: files)),
          ],
        ),
      ),
    );
  }
}
