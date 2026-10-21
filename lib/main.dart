import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:tiara/bookmark.dart';
import 'package:tiara/home.dart';
import 'package:tiara/style.dart';

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
      home: PersistentTabView(
        tabs: [
          PersistentTabConfig(
            screen: MyHomePage(title: "Gown"),
            item: ItemConfig(
              icon: Icon(Icons.file_download),
              title: "Download",
              activeForegroundColor: navBarButtonActive,
              inactiveForegroundColor: navBarButtonInactive,
            ),
          ),
          PersistentTabConfig(
            screen: BookmarkPage(title: "Mark"),
            item: ItemConfig(
              icon: Icon(Icons.bookmark),
              title: "Bookmark",
              activeForegroundColor: navBarButtonActive,
              inactiveForegroundColor: navBarButtonInactive,
            ),
          ),
          //
          // INSERT MORE TABS HERE
          //
        ],
        navBarBuilder: (navBarConfig) => Style7BottomNavBar(
          navBarConfig: navBarConfig,
          navBarDecoration: NavBarDecoration(color: navBarBackgroundColour),
        ),
      ),
      //home: const MyHomePage(title: 'Gown'),
    );
  }
}
