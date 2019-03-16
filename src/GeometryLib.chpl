/* Documentation for GeometryLib */
module GeometryLib {
/*
Point TODO: Add documentation
*/
class Point {
  var doma = {1..0};
  var dim: int;
  var pos:[doma] real;

  proc init(dim: int) {
    doma = {1..dim};
    this.dim = dim;
  }

  proc init(pos: real ...?dim) {
    this.doma = {1..dim};
    this.dim = dim;
    this.pos = [i in doma] 0;
    for i in this.doma {
      this.pos[i] = pos[i];
    }
  }

  proc init(point: Point) {
    this.doma = point.dom();
    this.dim = point.dimensions();
    this.pos = [i in doma] 0;
    for i in this.doma {
      this.pos[i] = point[i];
    }
  }

  /* Position getter */
  proc position() ref {
    return pos;
  }

  /* Expands dimensions */ 
  proc expandDim(dim: int) : bool {
    if(dim <= this.dimensions()) {
      return false;
    }
    this.dom() = {1..dim};
    this.dimensions() = dim;
    return true;
  }

  /* Domain getter */
  proc dom() ref {
    return doma;
  }

  /* Dimensions getter */
  proc dimensions() ref {
    return dim;
  }

  /* Returns the distance between point and the origin */
  proc abs() : real {
    return distance(new owned Point(this.dimensions()));
  }

  /* Returns distance between this point and a given point */
  proc distance(point: Point) : real {
    if(point.dom() != this.dom()) {
      normalizeDimensions(this, point);
    }
    var sum: real;
    for (i, j) in zip(position(), point.position()) {
      sum += (i - j) ** 2; 
    }
    return sum ** (1/2);
  }

  /* Adds point to this point */
  proc add(point: Point) {
    if(point.dom() != this.dom()) {
      normalizeDimensions(this, point);
    }
    for i in dom() {
      this[i] += point[i];
    }
  }

  /* Subtracts point to this point */
  proc sub(point: Point) {
    if(point.dom() != this.dom()) {
      normalizeDimensions(this, point);
    }
    for i in dom() {
      this[i] -= point[i];
    }
  }

  /* Multiplies point to this point */
  proc mult(factor: real) {
    for i in dom() {
      this[i] *= factor;
    }
  }

  /* Divides point to this point */
  proc div(divisor: real) {
    for i in dom() {
      this[i] /= divisor;
    }
  }
    
  /* Checks if point is equal */
  proc equals(point: Point) : bool {
    if(point.dom() != this.dom()) {
      normalizeDimensions(this, point);
    }
    for i in dom() {
      if this[i] != point[i] {
        return false;
      }
    }
    return true;
  }
    
  /* Negates the point */
  proc negate() {
    for i in dom() {
      this[i] = -1 * this[i];
    }
  }

  /* Takes the dot product */
  proc dot(point: Point) {
    if(point.dom() != this.dom()) {
      normalizeDimensions(this, point);
    }
    for i in dom() {
      this[i] *= point[i];
    }
  }
}

proc Point.this(i: int) ref: real {
  return position()[i];
}

proc +(a: Point, b: Point) {
  var sum: unmanaged Point = new unmanaged Point(max(a.dimensions(), b.dimensions()));
  sum.add(a);
  sum.add(b);
  return sum;
}

proc -(a: Point, b: Point) {
  var diff: unmanaged Point = new unmanaged Point(max(a.dimensions(), b.dimensions()));
  diff.add(a);
  diff.sub(b);
  return diff;
}

proc *(a: Point, b: Point) {
  var mult: unmanaged Point = new unmanaged Point(max(a.dimensions(), b.dimensions()));
  mult.add(a);
  mult.dot(b);
  return mult;
}

proc *(a: Point, factor: real) {
  var mult: unmanaged Point = new unmanaged Point(a.dimensions());
  mult.add(a);
  mult.mult(factor);
  return mult;
}

proc /(a: Point, divisor: real) {
  var div: unmanaged Point = new unmanaged Point(a.dimensions());
  div.add(a);
  div.div(divisor);
  return div;
}

/* Normalizes the dimensions of the points */
proc normalizeDimensions(points: Point ...?dim) {
  var maxDim = 0;
  for i in 1..dim {
    maxDim = max(maxDim, points[i].dimensions());
  }
  for i in 1..dim {
    points[i].expandDim(maxDim);
  }
}
}