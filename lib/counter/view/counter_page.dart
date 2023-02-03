import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_watch/counter/counter.dart';
import 'package:flutter_watch/l10n/l10n.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  // ignore: avoid_field_initializers_in_const_classes
  final MethodChannel _channel = const MethodChannel('flutter_watch');

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(
        channel: _channel,
      ),
      child: CounterView(
        channel: _channel,
      ),
    );
  }
}

class CounterView extends StatefulWidget {
  const CounterView({
    required this.channel,
    super.key,
  });

  final MethodChannel channel;

  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  @override
  void initState() {
    super.initState();

    widget.channel.setMethodCallHandler((call) async {
      final methodName = call.method;
      final args = call.arguments;
      if (methodName != 'updateFromWatch') {
        return;
      }
      // ignore: avoid_dynamic_calls
      final text = args['text'] as String;
      if (text == 'increment') {
        context.read<CounterCubit>().increment();
      } else if (text == 'decrement') {
        context.read<CounterCubit>().decrement();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.counterAppBarTitle)),
      body: const Center(child: CounterText()),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => context.read<CounterCubit>().increment(),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () => context.read<CounterCubit>().decrement(),
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

class CounterText extends StatelessWidget {
  const CounterText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = context.select((CounterCubit cubit) => cubit.state);
    return Text('$count', style: theme.textTheme.displayLarge);
  }
}
