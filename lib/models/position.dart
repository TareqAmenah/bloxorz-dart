class Position {
  final int xAxis, yAxis;
  Position(this.xAxis, this.yAxis);

  bool operator ==(other) {
    if (this.xAxis == other.xAxis && this.yAxis == other.yAxis) return true;
    return false;
  }
}
