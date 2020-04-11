import 'dart:collection';
import 'dart:math';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snaake/game/blocs/game_bloc.dart';
import 'package:snaake/game/blocs/game_events.dart';
import 'package:snaake/game/blocs/game_state.dart';
import 'package:snaake/game/models/board.dart';
import 'package:snaake/game/models/food.dart';
import 'package:snaake/game/models/snake.dart';
import 'package:snaake/game/models/vec2d.dart';

GameState _stateY(int y, {Food food, int score}) {
  return GameState(
    isLoaded: true,
    score: score ?? 0,
    food: food ?? Food(x: 2, y: 16, score: 1),
    snake: Snake.fromPosition(5, y, 4),
    velocity: Vec2d(0, -1),
    board: Board(10, 20),
  );
}

GameState _state(
  List<Vec2d> snake, {
  Food food,
  int score,
  Vec2d velocity,
}) {
  return GameState(
    isLoaded: true,
    score: score ?? 0,
    food: food ?? Food(x: 2, y: 16, score: 1),
    snake: Snake(Queue.from(snake)),
    velocity: velocity ?? Vec2d(0, -1),
    board: Board(10, 20),
  );
}

void main() {
  group('test snake movement', () {
    blocTest(
      'with no input',
      build: () async => GameBloc(random: Random(200)),
      skip: 3,
      act: (bloc) async {
        bloc.add(LoadAssetsEvent());
        bloc.add(OnBoardCreatedEvent(Board(10, 20)));
        List.generate(11, (index) => bloc.add(UpdateGame()));
      },
      expect: List.generate(11, (index) => _stateY(10 - index)),
    );

    blocTest(
      'with arrow keys button pressed',
      build: () async => GameBloc(random: Random(200)),
      skip: 3,
      act: (bloc) async {
        bloc
          ..add(LoadAssetsEvent())
          ..add(OnBoardCreatedEvent(Board(10, 20)))
          ..add(UpdateGame())
          ..add(UpdateGame())
          ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowLeft))
          ..add(UpdateGame())
          ..add(UpdateGame())
          ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowUp))
          ..add(UpdateGame())
          ..add(UpdateGame())
          ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowRight))
          ..add(UpdateGame())
          ..add(UpdateGame())
          ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowDown))
          ..add(UpdateGame())
          ..add(UpdateGame());
      },
      expect: [
        _state(
          <Vec2d>[
            Vec2d(5, 10),
            Vec2d(5, 11),
            Vec2d(5, 12),
            Vec2d(5, 13),
          ],
          velocity: Vec2d(0, -1),
        ),
        _state(
          <Vec2d>[
            Vec2d(5, 9),
            Vec2d(5, 10),
            Vec2d(5, 11),
            Vec2d(5, 12),
          ],
          velocity: Vec2d(0, -1),
        ),
        _state(
          <Vec2d>[
            Vec2d(5, 9),
            Vec2d(5, 10),
            Vec2d(5, 11),
            Vec2d(5, 12),
          ],
          velocity: Vec2d(-1, 0),
        ),
        _state(
          <Vec2d>[
            Vec2d(4, 9),
            Vec2d(5, 9),
            Vec2d(5, 10),
            Vec2d(5, 11),
          ],
          velocity: Vec2d(-1, 0),
        ),
        _state(
          <Vec2d>[
            Vec2d(3, 9),
            Vec2d(4, 9),
            Vec2d(5, 9),
            Vec2d(5, 10),
          ],
          velocity: Vec2d(-1, 0),
        ),
        _state(
          <Vec2d>[
            Vec2d(3, 9),
            Vec2d(4, 9),
            Vec2d(5, 9),
            Vec2d(5, 10),
          ],
          velocity: Vec2d(0, -1),
        ),
        _state(
          <Vec2d>[
            Vec2d(3, 8),
            Vec2d(3, 9),
            Vec2d(4, 9),
            Vec2d(5, 9),
          ],
          velocity: Vec2d(0, -1),
        ),
        _state(
          <Vec2d>[
            Vec2d(3, 7),
            Vec2d(3, 8),
            Vec2d(3, 9),
            Vec2d(4, 9),
          ],
          velocity: Vec2d(0, -1),
        ),
        _state(
          <Vec2d>[
            Vec2d(3, 7),
            Vec2d(3, 8),
            Vec2d(3, 9),
            Vec2d(4, 9),
          ],
          velocity: Vec2d(1, 0),
        ),
        _state(
          <Vec2d>[
            Vec2d(4, 7),
            Vec2d(3, 7),
            Vec2d(3, 8),
            Vec2d(3, 9),
          ],
          velocity: Vec2d(1, 0),
        ),
        _state(
          <Vec2d>[
            Vec2d(5, 7),
            Vec2d(4, 7),
            Vec2d(3, 7),
            Vec2d(3, 8),
          ],
          velocity: Vec2d(1, 0),
        ),
        _state(
          <Vec2d>[
            Vec2d(5, 7),
            Vec2d(4, 7),
            Vec2d(3, 7),
            Vec2d(3, 8),
          ],
          velocity: Vec2d(0, 1),
        ),
        _state(
          <Vec2d>[
            Vec2d(5, 8),
            Vec2d(5, 7),
            Vec2d(4, 7),
            Vec2d(3, 7),
          ],
          velocity: Vec2d(0, 1),
        ),
        _state(
          <Vec2d>[
            Vec2d(5, 9),
            Vec2d(5, 8),
            Vec2d(5, 7),
            Vec2d(4, 7),
          ],
          velocity: Vec2d(0, 1),
        )
      ],
    );

    blocTest(
      'press opposite direction must not change the direction',
      build: () async => GameBloc(random: Random(200)),
      skip: 3,
      act: (bloc) async {
        bloc
          ..add(LoadAssetsEvent())
          ..add(OnBoardCreatedEvent(Board(10, 20)))
          ..add(UpdateGame())
          ..add(UpdateGame())
          ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowLeft))
          ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowRight))
          ..add(UpdateGame())
          ..add(UpdateGame())
          ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowUp))
          ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowDown))
          ..add(UpdateGame())
          ..add(UpdateGame())
          ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowRight))
          ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowLeft))
          ..add(UpdateGame())
          ..add(UpdateGame())
          ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowDown))
          ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowUp))
          ..add(UpdateGame())
          ..add(UpdateGame());
      },
      expect: [
        _state(
          <Vec2d>[
            Vec2d(5, 10),
            Vec2d(5, 11),
            Vec2d(5, 12),
            Vec2d(5, 13),
          ],
          velocity: Vec2d(0, -1),
        ),
        _state(
          <Vec2d>[
            Vec2d(5, 9),
            Vec2d(5, 10),
            Vec2d(5, 11),
            Vec2d(5, 12),
          ],
          velocity: Vec2d(0, -1),
        ),
        _state(
          <Vec2d>[
            Vec2d(5, 9),
            Vec2d(5, 10),
            Vec2d(5, 11),
            Vec2d(5, 12),
          ],
          velocity: Vec2d(-1, 0),
        ),
        _state(
          <Vec2d>[
            Vec2d(4, 9),
            Vec2d(5, 9),
            Vec2d(5, 10),
            Vec2d(5, 11),
          ],
          velocity: Vec2d(-1, 0),
        ),
        _state(
          <Vec2d>[
            Vec2d(3, 9),
            Vec2d(4, 9),
            Vec2d(5, 9),
            Vec2d(5, 10),
          ],
          velocity: Vec2d(-1, 0),
        ),
        _state(
          <Vec2d>[
            Vec2d(3, 9),
            Vec2d(4, 9),
            Vec2d(5, 9),
            Vec2d(5, 10),
          ],
          velocity: Vec2d(0, -1),
        ),
        _state(
          <Vec2d>[
            Vec2d(3, 8),
            Vec2d(3, 9),
            Vec2d(4, 9),
            Vec2d(5, 9),
          ],
          velocity: Vec2d(0, -1),
        ),
        _state(
          <Vec2d>[
            Vec2d(3, 7),
            Vec2d(3, 8),
            Vec2d(3, 9),
            Vec2d(4, 9),
          ],
          velocity: Vec2d(0, -1),
        ),
        _state(
          <Vec2d>[
            Vec2d(3, 7),
            Vec2d(3, 8),
            Vec2d(3, 9),
            Vec2d(4, 9),
          ],
          velocity: Vec2d(1, 0),
        ),
        _state(
          <Vec2d>[
            Vec2d(4, 7),
            Vec2d(3, 7),
            Vec2d(3, 8),
            Vec2d(3, 9),
          ],
          velocity: Vec2d(1, 0),
        ),
        _state(
          <Vec2d>[
            Vec2d(5, 7),
            Vec2d(4, 7),
            Vec2d(3, 7),
            Vec2d(3, 8),
          ],
          velocity: Vec2d(1, 0),
        ),
        _state(
          <Vec2d>[
            Vec2d(5, 7),
            Vec2d(4, 7),
            Vec2d(3, 7),
            Vec2d(3, 8),
          ],
          velocity: Vec2d(0, 1),
        ),
        _state(
          <Vec2d>[
            Vec2d(5, 8),
            Vec2d(5, 7),
            Vec2d(4, 7),
            Vec2d(3, 7),
          ],
          velocity: Vec2d(0, 1),
        ),
        _state(
          <Vec2d>[
            Vec2d(5, 9),
            Vec2d(5, 8),
            Vec2d(5, 7),
            Vec2d(4, 7),
          ],
          velocity: Vec2d(0, 1),
        )
      ],
    );

    blocTest(
      'on eat food',
      build: () async => GameBloc(random: Random(0)),
      skip: 3,
      act: (bloc) async {
        bloc
          ..add(LoadAssetsEvent())
          ..add(OnBoardCreatedEvent(Board(10, 20)))
          ..add(UpdateGame())
          ..add(UpdateGame());
      },
      expect: [
        // Eat
        _stateY(10, food: Food(x: 5, y: 9, score: 1)),

        // New score and food position
        _state(
          <Vec2d>[
            Vec2d(5, 9),
            Vec2d(5, 10),
            Vec2d(5, 11),
            Vec2d(5, 12),
            Vec2d(5, 13),
          ],
          score: 1,
          food: Food(
            x: 4,
            y: 19,
            score: 1,
          ),
        ),
      ],
    );
  });
}
