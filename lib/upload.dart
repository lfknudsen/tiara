import 'package:flutter/material.dart';
import 'package:tiara/components.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tiara/request.dart';
import 'package:tiara/util.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key, required this.title});

  final String title;

  @override
  State<UploadPage> createState() => _UploadPageState();
}

/// The individual list element.
class FileTile extends ListTile {
  const FileTile({super.key, required this.file, super.title});

  final PlatformFile file;
}

class _UploadPageState extends State<UploadPage> {
  List<FileTile> files = [];
  BigInt totalSize = BigInt.from(0);
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
  }

  /// Removes the given file from the list.
  Future<void> removeFile(PlatformFile file) async {
    try {
      setState(() {
        files = files.where((tile) => tile.file.uri != file.uri).toList();
        updateTotalSize();
      });
    } catch (e) {
      _error = e.toString();
    }
  }

  Future<void> updateTotalSize() async {
    BigInt acc = BigInt.from(0);
    for (final f in files) {
      acc += BigInt.from((await f.file.length()) ?? 0);
    }

    setState(() {
      totalSize = acc;
    });
  }

  /// Opens a file picker and adds any chosen files to the list.
  Future<void> chooseFiles() async {
    try {
      _loading = true;
      List<PlatformFile> fileList = await FilePicker.pickFiles();
      List<PlatformFile> existing = files.map((elem) => elem.file).toList();
      fileList.retainWhere((elem) => !existing.contains(elem));
      List<FileTile> outputList = [];
      for (final file in fileList) {
        final newTile = newFileTile(Key(file.uri.toString()), file);
        outputList.add(newTile);
      }
      setState(() {
        outputList.addAll(files);
        files = outputList;
        updateTotalSize();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void clearList() {
    setState(() {
      files = [];
      totalSize = BigInt.from(0);
    });
  }

  /// Constructor for a FileTile which assembles the correct title field.
  /// Since pressing the button has to execute a function local to this class,
  /// we can't just use a factory constructor inside FileTile.
  FileTile newFileTile(Key? key, PlatformFile src) {
    final title = Column(
      mainAxisAlignment: .center,
      crossAxisAlignment: .center,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Icon(Icons.description),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [Text(src.name)],
              ),
            ),
            IconButton(
              onPressed: () => {removeFile(src)},
              icon: Icon(Icons.remove_circle_outline),
              color: Color.fromARGB(255, 151, 0, 0),
            ),
          ],
        ),
      ],
    );
    return FileTile(key: key, file: src, title: title);
  }

  Future<void> clkUploadBtn() async {
    _loading = true;
    final success = await uploadFiles(files.map((elem) => elem.file).toList());
    if (success) {
      clearList();
    }
    _loading = false;
  }

  @override
  Widget build(BuildContext context) {
    String pluralS = "";
    if (files.length != 1) {
      pluralS = "s";
    }

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
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 2.5, 5),
                  child: ElevatedButton(
                    onPressed: chooseFiles,
                    child: IconText(Icons.attach_file, "Choose files"),
                  ),
                ),
                Expanded(child: Column(children: [])),
                Padding(
                  padding: const EdgeInsets.fromLTRB(2.5, 5, 5, 5),
                  child: ElevatedButton(
                    onPressed: clkUploadBtn,
                    child: IconText(Icons.upload_file, "Upload"),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(7, 5, 0, 5),
                  child: Text("${files.length} file$pluralS."),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(7, 5, 0, 5),
                  child: Text("Total size: ${formatBytes(totalSize)}."),
                ),
                Expanded(child: Column(children: [])),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 7, 5),
                  child: ElevatedButton(
                    onPressed: clearList,
                    child: Icon(Icons.remove_circle),
                  ),
                ),
              ],
            ),
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
