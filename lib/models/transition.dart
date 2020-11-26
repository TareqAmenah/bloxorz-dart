import 'package:bloxorz/controllers/game_controller.dart';

import './block.dart';

class Transition {
  BlockState preBlockState;
  BlockState newBlockState;
  MovementDirection movementDirection;
  Transition preTrnsition;
  int cost;

  Transition({
    this.preBlockState,
    this.newBlockState,
    this.movementDirection,
    this.preTrnsition,
    this.cost,
  });
}
