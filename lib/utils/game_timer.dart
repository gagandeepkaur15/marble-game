import 'dart:async';

class GameTimerUtils {
  int timeLeft = 10;
  Timer? timer;
  final void Function(int) onTick;
  final void Function() onTimeout;
  final int startTime;

  GameTimerUtils({required this.onTick, required this.onTimeout, this.startTime = 10,}):timeLeft = startTime ;

  void start() {
    timer?.cancel();
    timeLeft = startTime;
    onTick(timeLeft);
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (timeLeft > 0) {
        timeLeft--;
        onTick(timeLeft);
      } else {
        timer?.cancel();
        timeLeft = 0;  
        onTick(timeLeft);
        onTimeout();
      }
    });
  }

  void cancel() {
    timer?.cancel();
  }
}
