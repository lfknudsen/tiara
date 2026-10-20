import 'dart:convert';
import 'dart:io';
import 'package:grpc/grpc.dart';
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

Future<void> requestDownload(String url) async {
  print("Clicked download button");
  final client = newGRPCClient();

  final Link l = Link(id: uuid.v4(), token: uuid.v7(), url: url);
  try {
    var response = await client.download(l);
    print("Downloaded: ${response.finished}");
  } catch (ex) {
    print(ex);
  }
}

Future<void> addToQueue(String url) async {
  print("Clicked queue button");
  final client = newGRPCClient();

  final Link l = Link(id: uuid.v4(), token: uuid.v7(), url: url);
  try {
    var response = await client.queue(l);
    print("Added to queue: ${response.added}");
  } catch (ex) {
    print(ex);
  }
}

Future<void> addToBookmark(String url, {String? name, String? desc}) async {
  print("Clicked bookmark button");
  final uri = Uri.http("user:password@localhost:8081", "/graphql", );
  final headers = <String, String>{
    "Accept": "application/graphql-response+json", //; charset=utf-8",
    "Content-Type": "application/json",// charset=utf-8",
  };
  final newBookmark = <String, String> {
    "url": url,
    "name": name ?? "",
    "desc": desc ?? "",
  };

  final body = <String, Object> {
    "query":
     "mutation CreateBookmark(\$newBookmark: NewBookmark!) {createBookmark(input:\$newBookmark){url, name, desc} }",
    "variables": <String, Object>{
      "newBookmark": newBookmark
    }
  };
  final js = jsonEncode(body);
  print(js);
  try {
    final response = await http.post(uri, headers: headers, body: js);
    print("Response Status: ${response.statusCode}");
  } catch (ex) {
    print(ex);
  }
}
