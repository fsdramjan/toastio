import 'dart:convert';

import 'package:flutter/material.dart';
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

  Future<void> setup(WidgetTester tester) async {
    final key = GlobalKey<NavigatorState>();
    Toastio.initialize(key);
    await tester.pumpWidget(MaterialApp(
      navigatorKey: key,
      home: const Scaffold(body: Text('Home')),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('shortcut supports app image, custom icon and colors',
      (tester) async {
    await setup(tester);
    final image = MemoryImage(base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aEt8AAAAASUVORK5CYII=',
    ));
    Toastio.success(
      'Saved',
      appIcon: image,
      icon: const Icon(Icons.star),
      bgColor: Colors.purple,
      textColor: Colors.yellow,
      accentColor: Colors.green,
      iconColor: Colors.orange,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));
    expect(tester.widget<Image>(find.byType(Image)).image, image);
    expect(tester.widget<Text>(find.text('Saved')).style!.color, Colors.yellow);
    final iconContext = tester.element(find.byIcon(Icons.star));
    expect(IconTheme.of(iconContext).color, Colors.orange);
    final cards = tester.widgetList<Container>(find.byType(Container));
    expect(
        cards.any((card) =>
            card.decoration is BoxDecoration &&
            (card.decoration! as BoxDecoration).color ==
                Colors.purple.withValues(alpha: 0.92)),
        isTrue);
    expect(
        cards.any((card) =>
            card.decoration is BoxDecoration &&
            (card.decoration! as BoxDecoration).border ==
                Border.all(color: Colors.green.withValues(alpha: 0.20))),
        isTrue);
    Toastio.dismiss();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('manual dismissal animates before removing toast',
      (tester) async {
    await setup(tester);
    Toastio.info('Animated',
        reverseAnimationDuration: const Duration(milliseconds: 600));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));
    Toastio.dismiss();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Animated'), findsOneWidget);
    final fade = tester.widget<FadeTransition>(find
        .ancestor(
            of: find.text('Animated'), matching: find.byType(FadeTransition))
        .first);
    expect(fade.opacity.value, greaterThan(0));
    expect(fade.opacity.value, lessThan(1));
    await tester.pumpAndSettle();
    expect(find.text('Animated'), findsNothing);
  });

  testWidgets('auto dismissal and replacement do not remove newer toast',
      (tester) async {
    await setup(tester);
    Toastio.info('Old', duration: const Duration(milliseconds: 500));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));
    Toastio.dismiss();
    await tester.pump();
    Toastio.info('New', duration: const Duration(seconds: 1));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 550));
    expect(find.text('Old'), findsNothing);
    expect(find.text('New'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 450));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('New'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('New'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('close button and tap both animate dismissal', (tester) async {
    await setup(tester);
    for (final dismissOnTap in [false, true]) {
      Toastio.showGlobal('Dismiss me', dismissOnTap: dismissOnTap);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 450));
      await tester.tap(dismissOnTap
          ? find.text('Dismiss me')
          : find.bySemanticsLabel('Dismiss notification'));
      await tester.pump();
      expect(find.text('Dismiss me'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Dismiss me'), findsNothing);
    }
  });
}
