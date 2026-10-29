import 'package:flutter/material.dart';
import 'package:tiara/components.dart';
import 'package:file_picker/file_picker.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key, required this.title});

  final String title;

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  List<ListTile> files = [];
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
  }

  Future<void> chooseFiles() async {
    try {
      _loading = true;
      List<PlatformFile> fileList = await FilePicker.pickFiles();
      List<ListTile> outputList = [];
      for (final file in fileList) {
        final newTile = ListTile(title: Text(file.name));
        outputList.add(newTile);
      }
      setState(() {
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
