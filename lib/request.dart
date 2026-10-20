import 'package:grpc/grpc.dart';
import 'package:tiara/proto/listen.pbgrpc.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();

ListenerClient newClient([int port = 8080]) {
  final channel = ClientChannel(
    'localhost',
    port: port,
    options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
  );
  return ListenerClient(channel);
}

Future<void> requestDownload(String url) async {
  print("Clicked download button");
  final client = newClient();

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
  final client = newClient();

  final Link l = Link(id: uuid.v4(), token: uuid.v7(), url: url);
  try {
    var response = await client.queue(l);
    print("Added to queue: ${response.added}");
  } catch (ex) {
    print(ex);
  }
}

Future<void> addToBookmark(String url) async {
  print("Clicked bookmark button");
  final client = newClient();

  final Link l = Link(id: uuid.v4(), token: uuid.v7(), url: url);
  try {
    var response = await client.download(l);
    print("Response received: ${response.finished}");
  } catch (ex) {
    print(ex);
  }
}
