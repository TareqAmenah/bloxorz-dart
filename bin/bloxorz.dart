import 'package:bloxorz/controllers/game_controller.dart';

void main(List<String> arguments) {
  GameController gameController = GameController.authoInit();
  gameController.ucSolotion(gameController.block.blockState);
}
