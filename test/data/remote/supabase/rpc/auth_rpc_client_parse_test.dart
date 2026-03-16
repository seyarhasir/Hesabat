import 'package:flutter_test/flutter_test.dart';
import 'package:hesabat/data/remote/supabase/rpc/auth_rpc_client.dart';

void main() {
  group('parseRelinkResponse', () {
    test('parses string shop id as linked', () {
      final result = parseRelinkResponse('shop-uuid-1');

      expect(result.status, RelinkStatus.linked);
      expect(result.shopId, 'shop-uuid-1');
    });

    test('parses already_linked map', () {
      final result = parseRelinkResponse({
        'status': 'already_linked',
        'shop_id': 'shop-uuid-2',
      });

      expect(result.status, RelinkStatus.alreadyLinked);
      expect(result.shopId, 'shop-uuid-2');
    });

    test('parses inactive account status', () {
      final result = parseRelinkResponse({'status': 'inactive_account'});

      expect(result.status, RelinkStatus.inactiveAccount);
      expect(result.shopId, isNull);
    });

    test('parses null as not found', () {
      final result = parseRelinkResponse(null);

      expect(result.status, RelinkStatus.notFound);
      expect(result.shopId, isNull);
    });

    test('parses unknown payload as error', () {
      final result = parseRelinkResponse(123);

      expect(result.status, RelinkStatus.error);
      expect(result.shopId, isNull);
    });
  });
}
