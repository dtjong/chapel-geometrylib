/* Documentation for GeometryLib */
module GeometryLib {
/*
Point TODO: Add documentation
*/
class Point {
  var x, y, z: real;

  proc init() {
    this.x = 0;
    this.y = 0;
    this.z = 0;
  }

  proc init(x: real, y: real, z:real) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  /* Returns the distance between point and the origin */
  proc abs() {
    return distance(this, new Point());
  }

  proc distance(a: Point, b: Point) {
    var sum = a.x ** b.x + a.y ** b.y + a.z ** b.z;
    return sum ** (1/2);
  }
}
}