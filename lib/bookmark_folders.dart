import 'package:flutter/material.dart';
import 'package:tiara/request.dart';

class FlatFolder(String name, String guid, String child) {
  final String name = name;
  final String guid = guid;
  final String child = child;

  @override
  String toString() {
    return "($name, $guid, $child)";
  }
}

/// A folder node in the tree structure, replacing TreeNode from animated_tree_view.
class FolderNode {
  final String name;
  final String guid;
  final List<FolderNode> children;

  FolderNode({
    required this.name,
    required this.guid,
    this.children = const [],
  });
}

// Finds all the subdirectories recursively of the given parent folder.
List<FolderNode> assemble(
  String parentGuid,
  Map<String, List<String>> children,
  Map<String, String> names,
) {
  List<FolderNode> output = [];
  if (children[parentGuid] != null && children[parentGuid]!.isNotEmpty) {
    for (final guid in children[parentGuid]!) {
      final name = names[guid];
      if (name == null) {
        print("Couldn't find name for GUID $guid");
        continue;
      }
      FolderNode f = FolderNode(
        name: name,
        guid: guid,
        children: assemble(guid, children, names),
      );
      output.add(f);
    }
  }
  return output;
}

Future<FolderNode> getFolders() async {
  final folders = await getBookmarkFolders();
  Map<String, List<String>> children = {};
  Map<String, String> names = {};
  for (final folder in folders) {
    if (folder.child != "") {
      if (children.containsKey(folder.guid)) {
        if (children[folder.guid] == null) {
          children[folder.guid] = [];
        }
        children[folder.guid]!.add(folder.child);
      } else {
        children[folder.guid] = [folder.child];
      }
    }
    if (!names.containsKey(folder.guid)) {
      names[folder.guid] = folder.name;
    }
  }

  FolderNode root = FolderNode(
    name: "Bookmarks",
    guid: "0",
    children: assemble("0", children, names),
  );
  return root;
}

void addBookmark(FolderNode node) {
  print(node.name);
}

void addFolder(FolderNode node) {
  // Adding a new folder would require state management; for now just print
  print("Add folder to: ${node.name}");
}

/// Recursive widget that builds a tree using ExpansionTile
class FolderTile extends StatelessWidget {
  final FolderNode node;
  final int depth;

  const FolderTile({super.key, required this.node, this.depth = 0});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(node.name),
            const SizedBox(width: 8),
            IconButton.filledTonal(
              onPressed: () => addBookmark(node),
              icon: const Icon(Icons.add_box, size: 20),
            ),
            IconButton.filledTonal(
              onPressed: () => addFolder(node),
              icon: const Icon(Icons.create_new_folder, size: 20),
            ),
          ],
        ),
      ),
      children: node.children
          .map((child) => FolderTile(node: child, depth: depth + 1))
          .toList(),
    );
  }
}

class BookmarkFolderPage extends StatefulWidget {
  const BookmarkFolderPage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _BookmarkFolderPageState();
  }
}

class _BookmarkFolderPageState extends State<BookmarkFolderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: getFolders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return ListView(children: [FolderTile(node: snapshot.data!)]);
          } else if (snapshot.hasError) {
            throw snapshot.error!;
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
