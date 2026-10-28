import 'package:flutter/material.dart';
import 'package:tiara/components.dart';
import 'package:tiara/request.dart';

class FolderCreationPage extends StatefulWidget {
  const FolderCreationPage({
    super.key,
    required this.title,
    required this.prevContext,
  });

  final String title;
  final BuildContext prevContext;

  @override
  State<StatefulWidget> createState() => _FolderCreationPageState();
}

class _FolderCreationPageState extends State<FolderCreationPage> {
  final nameText = TextEditingController();
  final descText = TextEditingController();

  void clickNewFolderBtn() async {
    final success = await addToFolders(nameText.text, descText.text);
    if (success && widget.prevContext.mounted) {
      final temp = nameText.text;
      nameText.text = "";
      descText.text = "";
      Navigator.pop(widget.prevContext, temp);
    }
  }

  @override
  void dispose() {
    nameText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        leading: BackButton(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: TextField(
                controller: nameText,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: "Name",
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: TextField(
                controller: descText,
                maxLines: 5,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: "Description (optional)",
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 15),
                ),
              ),
            ),
            IconTextButton(clickNewFolderBtn, Icons.create_new_folder, "Folder"),
          ],
        ),
      ),
    );
  }
}
