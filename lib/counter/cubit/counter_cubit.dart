import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';

const String kSendToWatchMethod = 'sendToWatch';
const String kRemoteMethod = 'updateFromApp';

class CounterCubit extends Cubit<int> {
  CounterCubit({
    this.channel,
  }) : super(0);
  final MethodChannel? channel;

  void increment() {
    final newState = state + 1;
    _sendToWatch(newState.toString());
    emit(newState);
  }

  void decrement() {
    final newState = state - 1;
    _sendToWatch(newState.toString());
    emit(newState);
  }

  void _sendToWatch(String text) {
    channel?.invokeMethod(kSendToWatchMethod, {
      'method': kRemoteMethod,
      'data': {
        'text': text,
      },
    });
  }
}
