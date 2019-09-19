import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart' hide Route;
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:fluttery/animations.dart';
import 'package:hpi_flutter/app/widgets/main_scaffold.dart';
import 'package:kt_dart/collection.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class TimerPage extends StatelessWidget {
  final CountdownTimer _timer =
      CountdownTimer(Duration(minutes: 5), Duration(milliseconds: 200));

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _timer.stateStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return MainScaffold(
          appBar: AppBar(
            title: Text('Timer'),
          ),
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CountdownTimerWidget(_timer),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(
              _timer.state == CountdownTimerState.running
                  ? OMIcons.pause
                  : OMIcons.playArrow,
            ),
            onPressed: () => _timer.toggle(),
          ),
          bottomActions: KtList.of(
            IconButton(
              icon: Icon(OMIcons.replay),
              onPressed: () => _timer.reset(),
            ),
          ),
        );
      },
    );
  }
}

class CountdownTimer {
  Duration _total;
  final Duration updateFrequency;
  Stopwatch _stopwatch = Stopwatch();
  Timer _timer;
  Duration _additionalTime = Duration.zero;
  final Duration _zeroDelta = Duration(milliseconds: 50);

  BehaviorSubject<CountdownTimerState> _state =
      BehaviorSubject.seeded(CountdownTimerState.ready);
  CountdownTimerState get state => _state.value;
  Stream<CountdownTimerState> get stateStream => _state.stream.distinct();

  BehaviorSubject<Duration> _updates;
  Stream<Duration> get stream => _updates.stream;

  Duration get remaining =>
      isDone ? Duration.zero : _total + _additionalTime - _stopwatch.elapsed;
  bool get isDone =>
      state == CountdownTimerState.running &&
      _total + _additionalTime - _stopwatch.elapsed < _zeroDelta;

  CountdownTimer(this._total, this.updateFrequency)
      : assert(_total != null),
        assert(updateFrequency != null),
        _updates = BehaviorSubject.seeded(_total);

  void resume() {
    if (state == CountdownTimerState.running) return;

    if (state == CountdownTimerState.ready) {
      _stopwatch.reset();
      _additionalTime = Duration.zero;

      if (isDone) {
        _notifyUpdated();
        return;
      }
    }
    _state.value = CountdownTimerState.running;
    _stopwatch.start();
    _timer = Timer.periodic(updateFrequency, (t) {
      _notifyUpdated();
    });
  }

  void pause() {
    if (state == CountdownTimerState.ready ||
        state == CountdownTimerState.paused) return;

    _state.value = CountdownTimerState.paused;
    _stopwatch.stop();
    _timer.cancel();
  }

  void toggle() {
    if (state == CountdownTimerState.running)
      pause();
    else
      resume();
  }

  void add(Duration additionalTime) {
    assert(additionalTime != null);

    if (state == CountdownTimerState.ready) {
      _total += _additionalTime + additionalTime;
      _additionalTime = Duration.zero;
    } else {
      _additionalTime += additionalTime;
    }
    _notifyUpdated();
  }

  void reset() {
    if (state == CountdownTimerState.running) pause();

    _state.value = CountdownTimerState.ready;
    _stopwatch.reset();
    _additionalTime = Duration.zero;
    _notifyUpdated();
  }

  void _notifyUpdated() {
    if (isDone) {
      _timer?.cancel();
      _state.value = CountdownTimerState.ready;
      FlutterRingtonePlayer.playNotification();
    }
    _updates.value = remaining;
  }
}

enum CountdownTimerState { ready, running, paused }

class CountdownTimerWidget extends StatelessWidget {
  CountdownTimerWidget(this.timer) : assert(timer != null);

  final CountdownTimer timer;
  final Duration total = Duration(hours: 1);
  PolarCoord _lastCoords;

  @override
  Widget build(BuildContext context) {
    return RadialDragGestureDetector(
      onRadialDragStart: (coords) {
        _lastCoords = coords;
      },
      onRadialDragUpdate: (coords) {
        // _lastCoords ??= coords;
        // normalize in case we change from -pi to pi
        double difference =
            (coords.angle - _lastCoords.angle + pi) % (2 * pi) - pi;
        if (difference < -pi) difference += 2 * pi;

        Duration additional = Duration(
          microseconds: (total.inMicroseconds * difference / (2 * pi)).round(),
        );
        if (timer.remaining + additional > total)
          additional = total - timer.remaining;
        timer.add(additional);
        _lastCoords = coords;
      },
      child: StreamBuilder<Duration>(
        stream: timer.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return AspectRatio(
            aspectRatio: 1,
            child: Builder(
              builder: (context) => CustomPaint(
                painter: CountdownTimerPainter(context, timer, total),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CountdownTimerPainter extends CustomPainter {
  final BuildContext context;
  final CountdownTimer timer;
  final Duration total;
  final Paint _areaPaint;
  final Paint _tickSmallPaint;
  final Duration _tickSmallDistance = Duration(minutes: 1);
  final double _tickSmallLength = 10;
  final Paint _tickLargePaint;
  final int _tickLargeDistance = 5;
  final double _tickLargeLength = 20;
  final TextPainter _labelPainter;

  CountdownTimerPainter(this.context, this.timer, this.total)
      : assert(context != null),
        assert(timer != null),
        assert(total != null),
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
