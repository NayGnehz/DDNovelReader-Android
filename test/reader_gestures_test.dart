import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duoduo_langdu/widgets/reader_gestures.dart';

void main() {
  testWidgets('swipes dispatch exactly one action on the dominant axis',
      (tester) async {
    final actions = <String>[];
    await tester.pumpWidget(MaterialApp(
      home: ReaderGestures(
        onPreviousSentence: () => actions.add('previous sentence'),
        onNextSentence: () => actions.add('next sentence'),
        onPreviousPage: () => actions.add('previous page'),
        onNextPage: () => actions.add('next page'),
        onTapUp: (_) => actions.add('tap'),
        child: const SizedBox.expand(),
      ),
    ));
    final area = find.byType(ReaderGestures);
    for (final delta in [
      const Offset(0, -160),
      const Offset(0, 160),
      const Offset(-160, 0),
      const Offset(160, 0),
      const Offset(-180, 70),
    ]) {
      await tester.drag(area, delta);
      await tester.pump();
    }
    expect(actions, [
      'previous sentence', 'next sentence', 'next page', 'previous page',
      'next page',
    ]);

    actions.clear();
    await tester.drag(area, const Offset(0, 30));
    expect(actions, isEmpty);
    final gesture = await tester.startGesture(tester.getCenter(area));
    await gesture.moveBy(const Offset(0, 160));
    await gesture.cancel();
    expect(actions, isEmpty);
    await tester.tap(area);
    expect(actions, ['tap']);
  });
}
