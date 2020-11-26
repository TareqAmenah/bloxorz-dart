import 'package:bloxorz/models/position.dart';

class Block {
  final int height;
  BlockState blockState;

  Block({this.height, this.blockState});

  set setBlockState(BlockState newBlockState) => blockState = newBlockState;
}

class BlockState {
  final Position basePosition;
  final PerpendicularityState perpendicularityState;

  BlockState({
    this.basePosition,
    this.perpendicularityState,
  });

  List<Position> getCoverdPositiones({int blockHeight}) {
    List<Position> positionsList = List<Position>();

    switch (perpendicularityState) {
      case PerpendicularityState.PerpendicularToXY:
        positionsList.add(basePosition);
        break;

      case PerpendicularityState.PerpendicularToXZ:
        for (int i = 0; i < blockHeight; i++)
          positionsList
              .add(Position(basePosition.xAxis, basePosition.yAxis + i));
        break;
      case PerpendicularityState.PerpendicularToYZ:
        for (int i = 0; i < blockHeight; i++)
          positionsList
              .add(Position(basePosition.xAxis + i, basePosition.yAxis));
        break;
    }
    return positionsList;
  }

  bool operator ==(blockState) {
    if (this.basePosition == blockState.basePosition &&
        this.perpendicularityState == blockState.perpendicularityState)
      return true;
    return false;
  }
}

enum PerpendicularityState {
  PerpendicularToXZ,
  PerpendicularToXY,
  PerpendicularToYZ,
}
