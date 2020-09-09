library ferry_log_plugin;

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:ferry/ferry.dart';
import 'package:ferry/plugins.dart';

typedef RequestCallback = Function(OperationRequest);
typedef ResponseCallback = Function(OperationResponse);

class FerryLogPlugin extends Plugin {
  FerryLogPlugin({@required this.onRequest, @required this.onResponse});
  final RequestCallback onRequest;
  final ResponseCallback onResponse;

  @override
  StreamTransformer<OperationRequest<TData, TVars>,
      OperationRequest<TData, TVars>> buildRequestTransformer<TData, TVars>() {
    return StreamTransformer.fromBind(
        (Stream<OperationRequest<TData, TVars>> requestStream) {
      requestStream.forEach((r) => onRequest(r));
      return requestStream;
    });
  }

  @override
  StreamTransformer<OperationResponse<TData, TVars>,
          OperationResponse<TData, TVars>>
      buildResponseTransformer<TData, TVars>() {
    return StreamTransformer.fromBind(
        (Stream<OperationResponse<TData, TVars>> responseStream) {
      responseStream.forEach(onResponse);
      return responseStream;
    });
  }
}
