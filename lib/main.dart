import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
      useMaterial3: true,
    ),
    home: const HomePage(),
  ));
}

const url = 'https://bit.ly/4201Bty';

enum Action {
  rotateLeft,
  rotateRight,
  moreVisible,
  lessVisible,
  resetImage,
}

@immutable
class State {
  final double rotationDeg;
  final double alpha;

  const State({
    required this.rotationDeg,
    required this.alpha,
  });

  const State.zero()
      : rotationDeg = 0.0,
        alpha = 1.0;

  State rotateRight() => State(
        rotationDeg: rotationDeg + 10.0,
        alpha: alpha,
      );
  State rotateLeft() => State(
        rotationDeg: rotationDeg - 10.0,
        alpha: alpha,
      );
  State increaseAplha() => State(
        rotationDeg: rotationDeg,
        alpha: min(alpha + 0.1, 1.0),
      );
  State decreaseAplha() => State(
        rotationDeg: rotationDeg,
        alpha: max(alpha - 0.1, 0.0),
      );
}

State reducer(State oldState, Action? action) {
  switch (action) {
    case Action.rotateLeft:
      return oldState.rotateLeft();

    case Action.rotateRight:
      return oldState.rotateRight();

    case Action.moreVisible:
      return oldState.increaseAplha();

    case Action.lessVisible:
      return oldState.decreaseAplha();

    case Action.resetImage:
      return const State.zero();

    case null:
      return oldState;
  }
}

class HomePage extends HookWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final store = useReducer<State, Action?>(
      reducer,
      initialState: const State.zero(),
      initialAction: null,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              RotateRightButton(store: store),
              RotateLeftButton(store: store),
              IncreaseAlphaButton(store: store),
              DecreaseAlphaButton(store: store),
            ],
          ),
          const SizedBox(
            height: 128,
          ),
          Opacity(
            opacity: store.state.alpha,
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(
                store.state.rotationDeg / 360,
              ),
              child: Image.network(url),
            ),
          ),
          const SizedBox(
            height: 128,
          ),
          ResetImagePropertiesButton(store: store)
        ],
      ),
    );
  }
}

class ResetImagePropertiesButton extends StatelessWidget {
  const ResetImagePropertiesButton({
    super.key,
    required this.store,
  });

  final Store<State, Action?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        store.dispatch(Action.resetImage);
      },
      child: const Text(
        'Reset image properties',
      ),
    );
  }
}

class DecreaseAlphaButton extends StatelessWidget {
  const DecreaseAlphaButton({
    super.key,
    required this.store,
  });

  final Store<State, Action?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        store.dispatch(Action.moreVisible);
      },
      child: const Text('Increase alpha'),
    );
  }
}

class IncreaseAlphaButton extends StatelessWidget {
  const IncreaseAlphaButton({
    super.key,
    required this.store,
  });

  final Store<State, Action?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        store.dispatch(Action.lessVisible);
      },
      child: const Text('Decrease alpha'),
    );
  }
}

class RotateLeftButton extends StatelessWidget {
  const RotateLeftButton({
    super.key,
    required this.store,
  });

  final Store<State, Action?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        store.dispatch(Action.rotateLeft);
      },
      child: const Text('Rotate left'),
    );
  }
}

class RotateRightButton extends StatelessWidget {
  const RotateRightButton({
    super.key,
    required this.store,
  });

  final Store<State, Action?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        store.dispatch(Action.rotateRight);
      },
      child: const Text('Rotate right'),
    );
  }
}
