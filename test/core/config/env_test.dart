import 'package:flutter_test/flutter_test.dart';
import 'package:hesabat/core/config/env.dart';

void main() {
  test('throws when required env values are missing', () async {
    await expectLater(
      EnvConfig.load,
      throwsA(anything),
    );
  });
}
