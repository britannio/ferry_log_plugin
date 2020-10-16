library ferry_log_plugin;

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:ferry/ferry.dart';

typedef RequestCallback = void Function(OperationRequest);
typedef ResponseCallback = void Function(OperationResponse);

class FerryLogPlugin extends TypedLink {
  FerryLogPlugin({@required this.onRequest, @required this.onResponse});
  final RequestCallback onRequest;
  final ResponseCallback onResponse;

  @override
  Stream<OperationResponse<TData, TVars>> request<TData, TVars>(
    OperationRequest<TData, TVars> request, [
    forward,
  ]) async* {
    onRequest(request);

    await for (final response in forward(request)) {
      onResponse(response);
      yield response;
    }
  }
}
