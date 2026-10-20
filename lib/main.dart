import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiara/components.dart';
import 'package:tiara/request.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tiara',
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: const Color.fromARGB(255, 58, 183, 79),
        ),
      ),
      home: const MyHomePage(title: 'Gown'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final textControl = TextEditingController();
  final logControl  = TextEditingController();

  void clickDownloadBtn() {
    requestDownload(textControl.text);
    textControl.text = "";
  }

  void clickQueueBtn() {
    addToQueue(textControl.text);
    textControl.text = "";
    setState(() {});
  }

  void clickBookmarkBtn() {
    addToBookmark(textControl.text);
    textControl.text = "";
  }

  void clickPasteBtn() async {
    ClipboardData? data = await Clipboard.getData('text/plain');
    if (data != null) {
      String? clipboardText = data.text;
      if (clipboardText != null) {
        textControl.text = clipboardText;
      }
    }
  }

  @override
  void dispose() {
    textControl.dispose();
    super.dispose();
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
                controller: textControl,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: "Enter a URL",
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                ),
              ),
            ),
            IconTextButton(clickQueueBtn, Icons.queue, "Queue"),
            IconTextButton(
              clickDownloadBtn,
              Icons.download_for_offline,
              "Download",
            ),
            IconTextButton(clickBookmarkBtn, Icons.bookmark_add, "Bookmark"),
            
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextField(
                controller: logControl,
                autocorrect: false,
                readOnly: true,
                stylusHandwritingEnabled: false,
                maxLines: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
