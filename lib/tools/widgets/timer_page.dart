import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart' hide Route;
import 'package:hpi_flutter/app/widgets/main_scaffold.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class TimerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: AppBar(
        title: Text('Timer'),
      ),
      body: Builder(builder: (c) => _buildTimer(c)),
    );
  }

  Widget _buildTimer(BuildContext context) {
    var timer =
        CountdownTimer(Duration(seconds: 500), Duration(milliseconds: 200))
          ..resume();
    return StreamBuilder<Duration>(
      stream: timer.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Placeholder();

        return Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: AspectRatio(
              aspectRatio: 1,
              child: Builder(
                builder: (context) => CustomPaint(
                  painter: CountdownTimerPainter(context, timer),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CountdownTimer {
  final Duration total;
  final Duration frequency;
  Stopwatch _stopwatch = Stopwatch();
  Timer _timer;
  CountdownTimerState _state;

  BehaviorSubject<Duration> _updates;
  Stream<Duration> get stream => _updates.stream;

  Duration _remaining;
  Duration get remaining => _remaining;

  CountdownTimer(this.total, this.frequency)
      : assert(total != null),
        assert(frequency != null),
        _updates = BehaviorSubject.seeded(total),
        _remaining = total;

  void resume() {
    if (_state == CountdownTimerState.running) return;

    _state = CountdownTimerState.running;
    _stopwatch.start();
    _timer = Timer.periodic(frequency, (t) {
      _remaining = total - _stopwatch.elapsed;
      _updates.value = _remaining;
      if (_remaining.isNegative) t.cancel();
    });
  }

  void pause() {
    if (_state == CountdownTimerState.ready ||
        _state == CountdownTimerState.paused) return;

    _stopwatch.stop();
    _timer.cancel();
  }

  void reset() {
    if (_state == CountdownTimerState.ready) return;
    if (_state == CountdownTimerState.running) pause();

    _stopwatch.reset();
  }
}

enum CountdownTimerState { ready, running, paused }

class CountdownTimerPainter extends CustomPainter {
  final BuildContext context;
  final CountdownTimer timer;
  final Duration total = Duration(hours: 1);
  final Paint _areaPaint;
  final Paint _tickSmallPaint;
  final Duration _tickSmallDistance = Duration(minutes: 1);
  final double _tickSmallLength = 10;
  final Paint _tickLargePaint;
  final int _tickLargeDistance = 5;
  final double _tickLargeLength = 20;
  final TextPainter _labelPainter;

  CountdownTimerPainter(this.context, this.timer)
      : assert(context != null),
        assert(timer != null),
        _areaPaint = Paint()..color = Theme.of(context).primaryColor,
        _tickSmallPaint = Paint()
          ..color = Colors.black
          ..strokeWidth = 1.5,
        _tickLargePaint = Paint()
          ..color = Colors.black
          ..strokeWidth = 3,
        _labelPainter = TextPainter(
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );

  @override
  void paint(Canvas canvas, Size size) {
    var theme = Theme.of(context);
    var total = this.total.inMicroseconds;
    var remaining = timer.remaining.inMicroseconds;

    var halfSize = size.shortestSide / 2 - 20;
    var labelPos = halfSize - 20;
    var tickEnd = labelPos - 5;

    canvas.drawArc(
      Rect.fromCircle(center: size.center(Offset.zero), radius: tickEnd),
      -pi / 2,
      2 * pi * remaining / total,
      true,
      _areaPaint,
    );

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);

    var count = total / _tickSmallDistance.inMicroseconds;
    for (var i = 0; i < count; i++) {
      var isLarge = i % _tickLargeDistance == 0;
      var direction = 2 * pi * (i.toDouble() / count - 0.25);

      canvas.drawLine(
        Offset.fromDirection(
          direction,
          tickEnd - (isLarge ? _tickLargeLength : _tickSmallLength),
        ),
        Offset.fromDirection(direction, tickEnd),
        isLarge ? _tickLargePaint : _tickSmallPaint,
      );

      if (isLarge) {
        _labelPainter.text = TextSpan(
          text: (i * _tickSmallDistance.inMinutes).toString(),
          style: theme.textTheme.display1,
        );
        _labelPainter.layout();
        _labelPainter.paint(
          canvas,
          Offset.fromDirection(direction, labelPos) +
              Offset(
                _labelPainter.size.width / 2 * (cos(direction) - 1),
                _labelPainter.size.height / 2 * (sin(direction) - 1),
              ),
        );
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
