library ferry_log_plugin;

import 'dart:async';

import 'package:ferry/ferry.dart';

typedef RequestCallback = FutureOr<void> Function(OperationRequest);
typedef ResponseCallback = FutureOr<void> Function(OperationResponse);

class LogLink extends TypedLink {
  LogLink({required this.onRequest, required this.onResponse});
  final RequestCallback onRequest;
  final ResponseCallback onResponse;

  @override
  Stream<OperationResponse<TData, TVars>> request<TData, TVars>(
    OperationRequest<TData, TVars> request, [
    NextTypedLink<TData, TVars>? forward,
  ]) async* {
    await onRequest(request);

    await for (final response in forward!(request)) {
      await onResponse(response);
      yield response;
    }
  }
}
