import 'package:toastio/toastio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ToastType contains four types', () {
    expect(ToastType.values, hasLength(4));
    expect(ToastType.values, contains(ToastType.success));
    expect(ToastType.values, contains(ToastType.error));
    expect(ToastType.values, contains(ToastType.warning));
    expect(ToastType.values, contains(ToastType.info));
  });

  test('ToastPosition contains three positions', () {
    expect(ToastPosition.values, hasLength(3));
  });
}
