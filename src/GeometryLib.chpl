/* Documentation for GeometryLib */
module GeometryLib {
/*
Point TODO: Add documentation
*/
class Point {
  var pos;
  var di;

  proc init(dim: int) {
    var pos: [1..dim] real;
    this.pos = pos;
    this.di = dim;
  }

  proc init(pos: real ...?dim) {
    this.pos = pos;
    this.di = dim;
  }

  /* Position getter */
  proc position() ref {
    return pos;
  }

  /* Position setter */
  proc setPosition(pos: real ...?dim) {
    this.pos = pos;
    this.di = dim;
  }

  /* Dimensions getter */
  proc dim() ref {
    return di;
  }

  /* Returns the distance between point and the origin */
  proc abs() {
    return distance(new Point(dim()));
  }

  /* Returns distance between this point and a given point */
  proc distance(point: Point) {
    var sum: real;
    for (i, j) in zip(position(), point.position()) {
      sum += (i - j) ** 2; 
    }
    return sum ** (1/2);
  }

  /* Adds point to this point */
  proc add(point: Point) {
    for i in 1..dim() {
      this[i] += point[i];
    }
  }

  /* Subtracts point to this point */
  proc sub(point: Point) {
    for i in 1..dim() {
      this[i] -= point[i];
    }
  }

  /* Multiplies point to this point */
  proc mult(factor: int) {
    for i in 1..dim() {
      this[i] *= factor;
    }
  }

  /* Divides point to this point */
  proc div(divisor: int) {
    for i in 1..dim() {
      this[i] /= divisor;
    }
  }
    
  /* Checks if point is equal */
  proc equals(point: Point) {
    for i in 1..dim() {
      if this[i] != point[i] {
        return false;
      }
    }
    return true;
  }
}

proc Point.this(i: int): real {
  return position()[i];
}

proc +(a: Point, b: Point) {
  var sum: Point = new Point(a.dim);
  sum.add(a);
  sum.add(b);
  return sum;
}
}