import 'package:bloxorz/models/position.dart';

class PlayGround {
  final int height;
  final int width;
  final List<PlayGroundGridItem> grid;

  PlayGround({
    this.height,
    this.width,
    this.grid,
  });

  bool isEmptyGridItem(Position position) {
    for (int i = 0; i < grid.length; i++) {
      var element = grid[i];
      if (element.position.xAxis == position.xAxis &&
          element.position.yAxis == position.yAxis) {
        if (element.playGroundGridItemType == PlayGroundGridItemType.Empty)
          return true;
        // if PlayGroundGridItemType is normal or endpoint
        return false;
      }
    }
    // if this (x,y) is out of the grid
    return true;
  }

  bool isEndPointGridItem(Position position) {
    // grid.forEach((element) {
    //   if (element.position.xAxis == position.xAxis &&
    //       element.position.yAxis == position.yAxis) {
    //     if (element.playGroundGridItemType == PlayGroundGridItemType.EndPoint)
    //       return true;
    //     // if PlayGroundGridItemType is normal or endpoint
    //     return false;
    //   }
    // });
    // // if this (x,y) is out of the grid
    // return false;
    for (int i = 0; i < grid.length; i++) {
      var element = grid[i];
      if (element.position.xAxis == position.xAxis &&
          element.position.yAxis == position.yAxis) {
        if (element.playGroundGridItemType == PlayGroundGridItemType.EndPoint)
          return true;
        // if PlayGroundGridItemType is normal or endpoint
        return false;
      }
    }
    return false;
  }
}

class PlayGroundGridItem {
  final Position position;
  final PlayGroundGridItemType playGroundGridItemType;

  PlayGroundGridItem({
    this.position,
    this.playGroundGridItemType,
  });
}

enum PlayGroundGridItemType {
  Normal,
  Empty,
  EndPoint,
}
