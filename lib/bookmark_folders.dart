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
TreeNode<String> assemble(
  TreeNode<String> parent,
  Map<String, List<String>> children,
  Map<String, String> names,
) {
  List<String> parentChildren = [];
  if (children[parent.key] != null && children[parent.key]!.length > 0) {
    for (final guid in children[parent.key]!) {
      parentChildren.add(guid);
    }
  }
  //print("${parent.guid} has ${parentChildren.length} children.");
  for (final childGuid in parentChildren) {
    final name = names[childGuid];
    if (name == null) {
      print("Couldn't find name for GUID $childGuid");
      continue;
    }
    TreeNode<String> f = TreeNode<String>(data:name, key:childGuid, parent:parent);
    parent.add(f);
    f = assemble(f, children, names);
    parent.children[childGuid] = f;
    //parent.children.add(f);
  }

  return parent;
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

  TreeNode<String> root = TreeNode(data:":root", key:"0", parent:null);
  Node n = Node(key: root.key, parent:null);
  root = assemble(root, children, names);
  return root;
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
                    title: Text("Item ${node.data} (${node.key})"),
                    subtitle: Text("Parent: ${node.parent?.key ?? "??????"}"), //Text("Level ${node.level}"),
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
