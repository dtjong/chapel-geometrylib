/* Documentation for GeometryLib */
module GeometryLib {
/*
Point TODO: Add documentation
*/
class Point {
  var position;
  var dim;

  proc init(dim: int) {
    var position: [1..dim] real;
    this.position = position;
    this.dim = dim;
  }

  proc init(position: real ...?dim) {
    this.position = position;
    this.dim = dim;
  }

  /* Returns the distance between point and the origin */
  proc abs() {
    return distance(this, new Point(dim));
  }

  proc distance(a: Point, b: Point) {
    var posa = a.position;
    var posb = b.position;

    var sum: real;
    for (i, j) in zip(posa, posb) {
      sum += (i - j) ** 2; 
    }
    return sum ** (1/2);
  }
}
}