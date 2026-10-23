import 'package:flutter/material.dart';
import 'package:tiara/request.dart';

/// Flat representation of a folder row returned by the GraphQL API.
/// Each row links a child folder GUID to its parent, allowing the tree to be rebuilt.
class FlatFolder(String name, String guid, String child) {
  final String name = name;
  final String guid = guid;
  final String child = child;

  @override
  String toString() {
    return "($name, $guid, $child)";
  }
}

/// A folder node in the tree structure
class FolderNode {
  final String name;
  final String guid;
  var children = <FolderNode>[];

  FolderNode({
    required this.name,
    required this.guid,
    List<FolderNode>? children,
  }) : children = children ?? [];
}

/// Recursively builds a tree of [FolderNode] objects starting from a parent folder.
/// Walks the flat parent-child maps and constructs nested nodes depth-first.
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

/// Fetches all bookmark folders from the server and assembles them into a tree.
/// The API returns a flat list, so this function builds two lookup maps (children and names)
/// then calls [assemble] to recursively construct the hierarchical [FolderNode] tree.
Future<FolderNode> getFolders() async {
  final folders = await getBookmarkFolders();
  Map<String, List<String>> children = {};
  Map<String, String> names = {};
  
  // Build lookup maps: parent GUID -> list of child GUIDs, and GUID -> display name
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

  // Create the root node with GUID "0" (the top-level bookmarks container)
  FolderNode root = FolderNode(
    name: "Bookmarks",
    guid: "0",
    children: assemble("0", children, names),
  );
  return root;
}

/// Callback type for adding a child folder, used to trigger a rebuild at the page level.
typedef AddChildCallback = void Function(FolderNode parent);

/// A single expandable folder tile in the tree.
/// Uses [StatefulWidget] so that child tiles can delegate add-child actions up to the page level
/// via [onAddChild], which triggers a full tree rebuild.
class FolderTile extends StatefulWidget {
  const FolderTile({
    super.key,
    required this.node,
    this.depth = 0,
    required this.onAddChild,
  });

  final FolderNode node;
  final int depth;
  final AddChildCallback onAddChild;

  @override
  State<StatefulWidget> createState() {
    return _FolderTileState();
  }
}

/// Private state for [FolderTile].
/// Recursively renders each folder as an [ExpansionTile] with action buttons.
/// The tile title scrolls horizontally so long folder names don't overflow the screen.
class _FolderTileState extends State<FolderTile> {
  // Delegates adding a child folder to the page-level callback so the tree rebuilds.
  void _addFolder() {
    widget.onAddChild(widget.node);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      // Horizontal scroll allows long folder names and buttons to fit on narrow screens.
      // ... in theory. Doesn't seem to actually do anything, but it might be because I'm
      // testing it on desktop. Idk.
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.node.name),
            const SizedBox(width: 8),
            // Placeholder button for adding a bookmark to this folder.
            IconButton.filledTonal(
              onPressed: () => print(widget.node.name),
              icon: const Icon(Icons.add_box, size: 20),
            ),
            // Adds a new child folder under this node.
            IconButton.filledTonal(
              onPressed: _addFolder,
              icon: const Icon(Icons.create_new_folder, size: 20),
            ),
          ],
        ),
      ),
      // Recursively build child tiles, passing the same callback down the tree.
      children: widget.node.children
          .map(
            (child) => FolderTile(
              node: child,
              depth: widget.depth + 1,
              onAddChild: widget.onAddChild,
            ),
          )
          .toList(),
    );
  }
}

/// Top-level page that displays the bookmark folder tree.
/// Manages async loading of folder data and owns the mutable tree state so that
/// adding children triggers a full rebuild via [setState].
class BookmarkFolderPage extends StatefulWidget {
  const BookmarkFolderPage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _BookmarkFolderPageState();
  }
}

/// Private state for [BookmarkFolderPage].
/// Holds the loaded tree root and manages loading/error states.
/// The [onAddChild] callback lives here so that [setState] rebuilds the entire tree
/// when a new folder is added at any depth.
class _BookmarkFolderPageState extends State<BookmarkFolderPage> {
  FolderNode? _root;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFolders();
  }

  // Asynchronously fetches and builds the folder tree on page init.
  Future<void> _loadFolders() async {
    try {
      _loading = true;
      final root = await getFolders();
      setState(() {
        _root = root;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  // Called by any [FolderTile] when the user adds a child folder.
  // Generates a unique GUID and inserts the new node, then rebuilds the whole tree.
  void _onAddChild(FolderNode parent) {
    final newFolder = FolderNode(name: "New folder", guid: uuid.v4());
    setState(() {
      parent.children.add(newFolder);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      // Show a loading spinner while data loads, an error message on failure,
      // or the full tree wrapped in a [ListView] for vertical scrolling.
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text("Error: $_error"))
          : _root == null
          ? const Center(child: Text("No folders found"))
          : ListView(
              children: [FolderTile(node: _root!, onAddChild: _onAddChild)],
            ),
    );
  }
}
