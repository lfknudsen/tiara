import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiara/components.dart';
import 'package:tiara/request.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final urlText = TextEditingController();
  final nameText = TextEditingController();
  final descText = TextEditingController();

  void clickBookmarkBtn() async {
    final success = await addToBookmark(urlText.text);
    if (success) {
      urlText.text = "";
      nameText.text = "";
      descText.text = "";
    }
  }

  void clickPasteBtn() async {
    ClipboardData? data = await Clipboard.getData('text/plain');
    if (data != null) {
      String? clipboardText = data.text;
      if (clipboardText != null) {
        urlText.text = clipboardText;
      }
    }
  }

  @override
  void dispose() {
    urlText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(widget.title),
      ),
      body: Center
      (child: Column(
        mainAxisAlignment: .center, 
        crossAxisAlignment: .center,
        children: [
          Row(
              crossAxisAlignment: .center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    onPressed: clickPasteBtn,
                    child: IconText(Icons.paste, "Paste"),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: TextField(
                controller: urlText,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: "URL",
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: TextField(
                controller: nameText,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: "Name (optional)",
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
            IconTextButton(clickBookmarkBtn, Icons.bookmark_add, "Bookmark"),

        ],
        ),)
    );
  }

}