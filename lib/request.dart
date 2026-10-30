import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:grpc/grpc.dart';
import 'package:tiara/bookmark_folders.dart';
import 'package:tiara/proto/listen.pbgrpc.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

final uuid = Uuid();

ListenerClient newGRPCClient([int port = 8080]) {
  final channel = ClientChannel(
    'localhost',
    port: port,
    options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
  );
  return ListenerClient(channel);
}

Future<bool> requestDownload(String url) async {
  print("Clicked download button");
  final client = newGRPCClient();

  final Link l = Link(id: uuid.v4(), token: uuid.v7(), url: url);
  try {
    var response = await client.download(l);
    print("Downloaded: ${response.finished}");
    return response.finished;
  } catch (ex) {
    print(ex);
    return false;
  }
}

Future<bool> addToQueue(String url) async {
  print("Clicked queue button");
  final client = newGRPCClient();

  final Link l = Link(id: uuid.v4(), token: uuid.v7(), url: url);
  try {
    var response = await client.queue(l);
    print("Added to queue: ${response.added}");
    return response.added;
  } catch (ex) {
    print(ex);
    return false;
  }
}

Future<bool> addToBookmark(
  String url,
  String parent, {
  String? name,
  String? desc,
}) async {
  print("Clicked bookmark button");
  final uri = Uri.http("user:password@localhost:8081", "/graphql");
  final headers = <String, String>{
    "Accept": "application/graphql-response+json; charset=utf-8",
    "Content-Type": "application/json; charset=utf-8",
  };
  final newBookmark = <String, String>{
    "url": url,
    "parent": parent,
    "name": name ?? "",
    "desc": desc ?? "",
  };

  final body = <String, Object>{
    "query": "mutation CreateBookmark(\$newBookmark: NewBookmark!) {createBookmark(input:\$newBookmark) }",
    "variables": <String, Object>{"newBookmark": newBookmark},
  };
  final js = jsonEncode(body);
  print(js);
  try {
    final response = await http.post(uri, headers: headers, body: js);
    print("Response Status: ${response.statusCode}");
    print("Body: ${response.body}");
    return response.statusCode == 200;
  } catch (ex) {
    print(ex);
    return false;
  }
}

Future<List<FlatFolder>> getBookmarkFolders() async {
  final uri = Uri.http("user:password@localhost:8081", "/graphql");
  final headers = <String, String>{
    "Accept": "application/graphql-response+json; charset=utf-8",
    "Content-Type": "application/json; charset=utf-8",
  };

  final body = <String, Object>{
    "query": "query { folders {name, guid, child} } ",
  };
  final js = jsonEncode(body);
  print(js);
  try {
    final response = await http.post(uri, headers: headers, body: js);
    print("Response Status: ${response.statusCode}");
    final body = response.body;
    final map = jsonDecode(body);
    final folders = map["data"]["folders"];
    final List<FlatFolder> output = [];
    for (final folder in folders) {
      final f = FlatFolder(folder["name"], folder["guid"], folder["child"]);
      output.add(f);
    }
    return output;
  } catch (ex) {
    print(ex);
    return List.empty();
  }
}

Future<bool> addToFolders(String name, String? desc, String parent) async {
  if (name.trim().isEmpty) {
    return false;
  }
  final uri = Uri.http("user:password@localhost:8081", "/graphql");
  final headers = <String, String>{
    "Accept": "application/graphql-response+json; charset=utf-8",
    "Content-Type": "application/json; charset=utf-8",
  };
  final newFolder = <String, String>{
    "name": name.trim(),
    "desc": (desc ?? "").trim(),
    "parent": parent,
  };

  final body = <String, Object>{
    "query": "mutation CreateFolder(\$newFolder: NewFolder!) {createFolder(input:\$newFolder) }",
    "variables": <String, Object>{"newFolder": newFolder},
  };
  final js = jsonEncode(body);
  print(js);
  try {
    final response = await http.post(uri, headers: headers, body: js);
    print("Response Status: ${response.statusCode}\n");
    print("Body: ${response.body}");
    return response.statusCode == 200;
  } catch (ex) {
    print(ex);
    return false;
  }
}

String escapeName(String filename) {
  filename = filename.replaceAll('\\', '\\\\');
  filename = filename.replaceAll('"', '\\"');
  filename = filename.replaceAll('\r', '%0D');
  filename = filename.replaceAll('\n', '%0A');
  return filename;
}

Future<bool> uploadFiles(List<PlatformFile> files) async {
  final uri = Uri.http("localhost:8083", "/upload_multiple");
  final req = http.MultipartRequest("POST", uri);
  for (final file in files) {
    final mpFile = await http.MultipartFile.fromPath(
      "files",
      file.uri.path.substring(1),
      filename: escapeName(file.name),
    );
    req.files.add(mpFile);
  }
  try {
    final response = await req.send();
    print("Response Status: ${response.statusCode}\n");
    return response.statusCode == 200;
  } catch (ex) {
    print(ex);
    return false;
  }
}
