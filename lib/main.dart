import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(
          seedColor: const Color.fromARGB(255, 58, 183, 79),
        ),
      ),
      home: const MyHomePage(title: 'Gown'),
    );
  }
}

class IconText extends StatelessWidget {
  const IconText(this.icon, this.text, {super.key});
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      crossAxisAlignment: .center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Icon(icon), Text(" $text")],
        ),
      ],
    );
  }
}

class IconTextButton extends StatelessWidget {
  const IconTextButton(this.onPressed, this.icon, this.text, {super.key});
  final String text;
  final IconData icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: key,
      padding: const EdgeInsets.fromLTRB(85, 5, 85, 5),
      child: ElevatedButton(
        onPressed: onPressed,
        child: IconText(icon, text, key: key),
      ),
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
            IconTextButton(clickQueueBtn, Icons.bookmark_add, "Bookmark"),
          ],
        ),
      ),
    );
  }
}
