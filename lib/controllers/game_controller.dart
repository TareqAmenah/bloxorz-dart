import 'dart:collection';

import 'package:bloxorz/models/block.dart';
import 'package:bloxorz/models/play_ground.dart';
import 'package:bloxorz/models/position.dart';
import 'package:bloxorz/models/transition.dart';

class GameController {
  PlayGround playGround;
  Block block;
  int maxXAxis;
  int maxYAxis;
  List<BlockState> stateHistory = <BlockState>[];
  List<BlockState> visitedStates = <BlockState>[];
  List<MovementDirection> movmentHistory = <MovementDirection>[];
  bool isSolved = false;

  List<Transition> transitionsList = <Transition>[];

  GameController({
    this.playGround,
    this.block,
  }) {
    maxXAxis = playGround.width - 1;
    maxYAxis = playGround.height - 1;
  }

  GameController.authoInit() {
    final gridHeight = 6;
    final gridWidth = 6;
    var grid = <PlayGroundGridItem>[];
    for (var i = 0; i < gridHeight; i++) {
      for (var j = 0; j < gridWidth; j++) {
        grid.add(PlayGroundGridItem(
          position: Position(i, j),
          playGroundGridItemType: PlayGroundGridItemType.Normal,
        ));
      }
    }
    grid.removeWhere((element) =>
        element.position.xAxis == 4 && element.position.yAxis == 3);
    grid.add(PlayGroundGridItem(
      position: Position(4, 3),
      playGroundGridItemType: PlayGroundGridItemType.EndPoint,
    ));

    markGridItemAsEmbty(grid, 5, 5);
    markGridItemAsEmbty(grid, 0, 3);
    markGridItemAsEmbty(grid, 0, 4);
    markGridItemAsEmbty(grid, 1, 3);

    playGround = PlayGround(height: 6, width: 6, grid: grid);
    block = Block(
      height: 2,
      blockState: BlockState(
        basePosition: Position(0, 0),
        perpendicularityState: PerpendicularityState.PerpendicularToXY,
      ),
    );
  }

  void markGridItemAsEmbty(List<PlayGroundGridItem> grid, int x, int y) {
    grid.removeWhere((element) =>
        element.position.xAxis == x && element.position.yAxis == y);
    grid.add(PlayGroundGridItem(
      position: Position(x, y),
      playGroundGridItemType: PlayGroundGridItemType.Empty,
    ));
  }

  bool isVisited(BlockState blockStae) {
    for (var i = 0; i < visitedStates.length; i++) {
      if (blockStae == visitedStates[i]) return true;
    }
    return false;
  }

  BlockState _getNextBlockState(
      BlockState currentBlockState, MovementDirection movementDirection) {
    switch (movementDirection) {
      case MovementDirection.Up:
        switch (currentBlockState.perpendicularityState) {
          case PerpendicularityState.PerpendicularToXY:
            return BlockState(
              basePosition: Position(currentBlockState.basePosition.xAxis,
                  currentBlockState.basePosition.yAxis + 1),
              perpendicularityState: PerpendicularityState.PerpendicularToXZ,
            );
            break;

          case PerpendicularityState.PerpendicularToXZ:
            return BlockState(
              basePosition: Position(currentBlockState.basePosition.xAxis,
                  currentBlockState.basePosition.yAxis + block.height),
              perpendicularityState: PerpendicularityState.PerpendicularToXY,
            );
            break;

          case PerpendicularityState.PerpendicularToYZ:
            return BlockState(
              basePosition: Position(currentBlockState.basePosition.xAxis,
                  currentBlockState.basePosition.yAxis + 1),
              perpendicularityState: PerpendicularityState.PerpendicularToYZ,
            );
            break;
        }

        break;

      case MovementDirection.Downe:
        switch (currentBlockState.perpendicularityState) {
          case PerpendicularityState.PerpendicularToXY:
            return BlockState(
              basePosition: Position(currentBlockState.basePosition.xAxis,
                  currentBlockState.basePosition.yAxis - block.height),
              perpendicularityState: PerpendicularityState.PerpendicularToXZ,
            );
            break;

          case PerpendicularityState.PerpendicularToXZ:
            return BlockState(
              basePosition: Position(currentBlockState.basePosition.xAxis,
                  currentBlockState.basePosition.yAxis - 1),
              perpendicularityState: PerpendicularityState.PerpendicularToXY,
            );
            break;

          case PerpendicularityState.PerpendicularToYZ:
            return BlockState(
              basePosition: Position(currentBlockState.basePosition.xAxis,
                  currentBlockState.basePosition.yAxis - 1),
              perpendicularityState: PerpendicularityState.PerpendicularToYZ,
            );
            break;
        }
        break;

      case MovementDirection.Right:
        switch (currentBlockState.perpendicularityState) {
          case PerpendicularityState.PerpendicularToXY:
            return BlockState(
              basePosition: Position(currentBlockState.basePosition.xAxis + 1,
                  currentBlockState.basePosition.yAxis),
              perpendicularityState: PerpendicularityState.PerpendicularToYZ,
            );
            break;

          case PerpendicularityState.PerpendicularToXZ:
            return BlockState(
              basePosition: Position(currentBlockState.basePosition.xAxis + 1,
                  currentBlockState.basePosition.yAxis),
              perpendicularityState: PerpendicularityState.PerpendicularToXZ,
            );
            break;

          case PerpendicularityState.PerpendicularToYZ:
            return BlockState(
              basePosition: Position(
                  currentBlockState.basePosition.xAxis + block.height,
                  currentBlockState.basePosition.yAxis),
              perpendicularityState: PerpendicularityState.PerpendicularToXY,
            );
            break;
        }
        break;

      case MovementDirection.Left:
        switch (currentBlockState.perpendicularityState) {
          case PerpendicularityState.PerpendicularToXY:
            return BlockState(
              basePosition: Position(
                  currentBlockState.basePosition.xAxis - block.height,
                  currentBlockState.basePosition.yAxis),
              perpendicularityState: PerpendicularityState.PerpendicularToYZ,
            );
            break;

          case PerpendicularityState.PerpendicularToXZ:
            return BlockState(
              basePosition: Position(currentBlockState.basePosition.xAxis - 1,
                  currentBlockState.basePosition.yAxis),
              perpendicularityState: PerpendicularityState.PerpendicularToXZ,
            );
            break;

          case PerpendicularityState.PerpendicularToYZ:
            return BlockState(
              basePosition: Position(currentBlockState.basePosition.xAxis - 1,
                  currentBlockState.basePosition.yAxis),
              perpendicularityState: PerpendicularityState.PerpendicularToXY,
            );
            break;
        }
        break;
    }
    return null;
  }

  bool _isBlockStateAcceptable(BlockState newBlockState) {
    bool b;

    var coverdPositiones =
        newBlockState.getCoverdPositiones(blockHeight: block.height);
    for (var i = 0; i < coverdPositiones.length; i++) {
      b = playGround.isEmptyGridItem(coverdPositiones[i]);
      if (b) return false;
    }

    return true;
  }

  bool isWinState(BlockState currentBlockState) {
    var blockBasePosition = currentBlockState.basePosition;
    if (currentBlockState.perpendicularityState ==
            PerpendicularityState.PerpendicularToXY &&
        playGround.isEndPointGridItem(blockBasePosition)) return true;
    return false;
  }

  void printGrid() {
    var tList = List.generate(playGround.height, (i) => List(playGround.width),
        growable: false);
    playGround.grid.forEach((element) {
      switch (element.playGroundGridItemType) {
        case PlayGroundGridItemType.Empty:
          tList[element.position.yAxis][element.position.xAxis] = '-';
          break;
        case PlayGroundGridItemType.Normal:
          tList[element.position.yAxis][element.position.xAxis] = '0';
          break;
        case PlayGroundGridItemType.EndPoint:
          tList[element.position.yAxis][element.position.xAxis] = '#';
          break;
      }
    });
    block.blockState
        .getCoverdPositiones(blockHeight: block.height)
        .forEach((element) {
      tList[element.yAxis][element.xAxis] = '*';
    });
    for (var i = playGround.height - 1; i >= 0; i--) {
      print(tList[i]);
    }
    print('\n**************\n');
  }

  void printPathOnTheGrid(List<BlockState> path) {
    stateHistory.forEach((element) {
      printSingleState(element);
    });
  }

  void printSingleState(BlockState state) {
    var tList = List.generate(playGround.height, (i) => List(playGround.width),
        growable: false);
    playGround.grid.forEach((element) {
      switch (element.playGroundGridItemType) {
        case PlayGroundGridItemType.Empty:
          tList[element.position.yAxis][element.position.xAxis] = '-';
          break;
        case PlayGroundGridItemType.Normal:
          tList[element.position.yAxis][element.position.xAxis] = '0';
          break;
        case PlayGroundGridItemType.EndPoint:
          tList[element.position.yAxis][element.position.xAxis] = '#';
          break;
      }
    });
    state.getCoverdPositiones(blockHeight: block.height).forEach((element) {
      tList[element.yAxis][element.xAxis] = '*';
    });
    for (var i = playGround.height - 1; i >= 0; i--) {
      print(tList[i]);
    }
    print('\n**************\n');
  }

  void bfsSolotion(BlockState initBlockState) {
    print('-----------');
    printGrid();
    isSolved = false;
    _bfs(initBlockState);
    print('The end');
  }

  void _bfs(BlockState initBlockState) {
    print('*****');
    var queue = Queue();

    visitedStates.add(initBlockState);
    var acceptableTransitions = getAcceptableTransitions(Transition(
      movementDirection: MovementDirection.Up,
      newBlockState: initBlockState,
      preBlockState: null,
      preTrnsition: null,
      cost: 0,
    ));

    for (var transition in acceptableTransitions) {
      queue.add(transition);
    }

    while (queue.isNotEmpty) {
      Transition t = queue.first;
      queue.removeFirst();

      if (isWinState(t.newBlockState)) {
        print('This is win state');
        _printSolution(t);
        return;
      }

      visitedStates.add(t.newBlockState);

      var acceptableTransitions = getAcceptableTransitions(t);

      for (var transition in acceptableTransitions) {
        queue.add(transition);
      }
    }
  }

  void ucSolotion(BlockState initBlockState) {
    print('-----------');
    printGrid();
    this.isSolved = false;
    _ucs(initBlockState);
    print('The end');
  }

  void _ucs(BlockState initBlockState) {
    print('*****');

    var queue = Queue();

    visitedStates.add(initBlockState);
    var acceptableTransitions = getAcceptableTransitions(Transition(
      movementDirection: MovementDirection.Up,
      newBlockState: initBlockState,
      preBlockState: null,
      preTrnsition: null,
      cost: 0,
    ));

    for (var transition in acceptableTransitions) {
      queue.add(transition);
    }

    while (queue.isNotEmpty) {
      Transition t = queue.first;
      queue.removeFirst();

      if (isWinState(t.newBlockState)) {
        print('This is win state');
        _printSolution(t);
        return;
      }

      visitedStates.add(t.newBlockState);

      var acceptableTransitions = getAcceptableTransitions(t);
      //*************************************** her we sort childs by cost befor we add them to the queue */
      acceptableTransitions.sort((a, b) => a.cost.compareTo((b.cost)));

      for (var transition in acceptableTransitions) {
        queue.add(transition);
      }
    }
  }

  List<Transition> getAcceptableTransitions(Transition currentTransition) {
    List<Transition> acceptableMovment = List<Transition>();

    BlockState newBlockStateDown = _getNextBlockState(
        currentTransition.newBlockState, MovementDirection.Downe);
    if (_isBlockStateAcceptable(newBlockStateDown) &&
        !isVisited(newBlockStateDown)) {
      acceptableMovment.add(
        Transition(
          preBlockState: currentTransition.newBlockState,
          newBlockState: newBlockStateDown,
          movementDirection: MovementDirection.Downe,
          preTrnsition: currentTransition,
          cost: currentTransition.cost + 1,
        ),
      );
    }

    BlockState newBlockStateUp = _getNextBlockState(
        currentTransition.newBlockState, MovementDirection.Up);
    if (_isBlockStateAcceptable(newBlockStateUp) &&
        !isVisited(newBlockStateUp)) {
      acceptableMovment.add(
        Transition(
          preBlockState: currentTransition.newBlockState,
          newBlockState: newBlockStateUp,
          movementDirection: MovementDirection.Up,
          preTrnsition: currentTransition,
          cost: currentTransition.cost + 1,
        ),
      );
    }

    BlockState newBlockStateLeft = _getNextBlockState(
        currentTransition.newBlockState, MovementDirection.Left);
    if (_isBlockStateAcceptable(newBlockStateLeft) &&
        !isVisited(newBlockStateLeft)) {
      acceptableMovment.add(
        Transition(
          preBlockState: currentTransition.newBlockState,
          newBlockState: newBlockStateLeft,
          movementDirection: MovementDirection.Left,
          preTrnsition: currentTransition,
          cost: currentTransition.cost + 1,
        ),
      );
    }

    BlockState newBlockStateRight = _getNextBlockState(
        currentTransition.newBlockState, MovementDirection.Right);
    if (_isBlockStateAcceptable(newBlockStateRight) &&
        !isVisited(newBlockStateRight)) {
      acceptableMovment.add(
        Transition(
          preBlockState: currentTransition.newBlockState,
          newBlockState: newBlockStateRight,
          movementDirection: MovementDirection.Right,
          preTrnsition: currentTransition,
          cost: currentTransition.cost + 1,
        ),
      );
    }
    return acceptableMovment;
  }

  void _printSolution(Transition transition) {
    print(transition.movementDirection);
    var t = transition.preTrnsition;
    while (t.preTrnsition != null) {
      print(t.movementDirection);
      t = t.preTrnsition;
    }
  }
}

enum MovementDirection {
  Up,
  Downe,
  Left,
  Right,
}
