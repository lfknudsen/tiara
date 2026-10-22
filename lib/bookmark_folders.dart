import 'package:flutter/material.dart';
import 'package:animated_tree_view/animated_tree_view.dart';
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

class Folder extends TreeNode<String> {
  Folder(String name, String guid, Folder? parent) : super(data:name, key:guid, parent:parent);
}

class RefFolder(String name, String guid) {
  final String name = name;
  final String guid = guid;
  final List<String> children = [];
}

// Finds all the subdirectories recursively of the given parent folder.
List<TreeNode<String>> assemble(
  String parentGuid,
  Map<String, List<String>> children,
  Map<String, String> names,
) {
  List<TreeNode<String>> output = [];
  if (children[parentGuid] != null && children[parentGuid]!.isNotEmpty) {
    for (final guid in children[parentGuid]!) {
      final name = names[guid];
      if (name == null) {
        print("Couldn't find name for GUID $guid");
        continue;
      }
      TreeNode<String> f = TreeNode<String>(data:name, key:guid);
      for (final c in assemble(f.key, children, names)) {
        f.add(c);
      }
      output.add(f);
    }
  }
  return output;
}

Future<TreeNode<String>> getFolders() async {
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

  TreeNode<String> root = TreeNode(data:"Bookmarks", key:"0", parent:null);
  for (final c in assemble(root.key, children, names)) {
    root.add(c);
  }
  return root;
}

void onTap() {

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
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: TreeView.simpleTyped<String, TreeNode<String>>(
                tree: snapshot.data!,
                builder: (context, node) {
                  return ListTile(
                    title: Text("${node.data}"),
                    subtitle: Text("${node.children.length} children"),
                    dense: true,
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            throw snapshot.error!;
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
