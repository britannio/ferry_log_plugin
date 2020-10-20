import 'package:ferry/ferry.dart';
import 'package:test/test.dart';

import 'package:ferry_log_plugin/ferry_log_plugin.dart';
import 'package:mockito/mockito.dart';

import "package:gql/ast.dart";
import "package:gql_exec/gql_exec.dart";

void main() {
  group('request', () {
    test(
      'should invoke the onRequest callback with the correct data',
      () async {
        // ARRANGE
        final tester = LogPluginTester();
        final plugin = FerryLogPlugin(
          onRequest: tester.onRequest,
          onResponse: tester.onResponse,
        );
        final request = MockRequest();
        when(request.operation).thenReturn(Operation(document: DocumentNode()));

        // ACT
        final responseStream =
            plugin.request(request, (_) => Stream.value(null));

        await responseStream.last;

        // ASSERT
        verify(tester.onRequest(request)).called(1);
      },
    );
    test(
      'should invoke the OnResponse callback with the correct data',
      () async {
        // ARRANGE
        final tester = LogPluginTester();
        final plugin = FerryLogPlugin(
          onRequest: tester.onRequest,
          onResponse: tester.onResponse,
        );
        final request = MockRequest();
        final response = OperationResponse(operationRequest: request);
        when(request.operation).thenReturn(Operation(document: DocumentNode()));

        // ACT
        final responseStream =
            plugin.request(request, (_) => Stream.value(response));

        await responseStream.last;

        // ASSERT
        verify(tester.onResponse(response));
      },
    );

    test(
      'should emit the response',
      () async {
        // ARRANGE
        final tester = LogPluginTester();
        final plugin = FerryLogPlugin(
          onRequest: tester.onRequest,
          onResponse: tester.onResponse,
        );
        final request = MockRequest();
        final response = OperationResponse(operationRequest: request);
        when(request.operation).thenReturn(Operation(document: DocumentNode()));

        // ACT
        final responseStream = plugin.request(
          request,
          (_) => Stream.value(response),
        );

        // ASSERT
        expect(responseStream, emitsInOrder([response, emitsDone]));
      },
    );
  });
}

abstract class LogPluginTesterBase {
  void onRequest(OperationRequest request);
  void onResponse(OperationResponse request);
}

class LogPluginTester extends Mock implements LogPluginTesterBase {}

class MockRequest extends Mock implements OperationRequest {}
