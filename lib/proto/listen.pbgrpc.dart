// This is a generated file - do not edit.
//
// Generated from proto/listen.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'listen.pb.dart' as $0;

export 'listen.pb.dart';

@$pb.GrpcServiceName('Listener')
class ListenerClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ListenerClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.Reply> download(
    $0.Link request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$download, request, options: options);
  }

  $grpc.ResponseFuture<$0.Confirmation> queue(
    $0.Link request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$queue, request, options: options);
  }

  // method descriptors

  static final _$download = $grpc.ClientMethod<$0.Link, $0.Reply>(
      '/Listener/Download',
      ($0.Link value) => value.writeToBuffer(),
      $0.Reply.fromBuffer);
  static final _$queue = $grpc.ClientMethod<$0.Link, $0.Confirmation>(
      '/Listener/Queue',
      ($0.Link value) => value.writeToBuffer(),
      $0.Confirmation.fromBuffer);
}

@$pb.GrpcServiceName('Listener')
abstract class ListenerServiceBase extends $grpc.Service {
  $core.String get $name => 'Listener';

  ListenerServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Link, $0.Reply>(
        'Download',
        download_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Link.fromBuffer(value),
        ($0.Reply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Link, $0.Confirmation>(
        'Queue',
        queue_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Link.fromBuffer(value),
        ($0.Confirmation value) => value.writeToBuffer()));
  }

  $async.Future<$0.Reply> download_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Link> $request) async {
    return download($call, await $request);
  }

  $async.Future<$0.Reply> download($grpc.ServiceCall call, $0.Link request);

  $async.Future<$0.Confirmation> queue_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Link> $request) async {
    return queue($call, await $request);
  }

  $async.Future<$0.Confirmation> queue($grpc.ServiceCall call, $0.Link request);
}
