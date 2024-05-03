import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:izlogging/implementations/tests_log_provider.dart';
import 'package:izlogging/log_service.dart';
import 'package:texoit/core/data/texoit_client.dart';

Future<(TexoItClient, DioAdapter?)> testSetup({bool mocked = false}) async {
  log = TestsLogProvider('texoit test session');
  final client = TexoItClient();
  if (mocked) {
    return (client, DioAdapter(dio: client.dio, matcher: const UrlRequestMatcher()));
  }
  return (client, null);
}
