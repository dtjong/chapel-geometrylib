/* Documentation for GeometryLib */
module GeometryLib {

class GeoObj {}

/*
Point
-----------
*/
class Point : GeoObj {
  var Domain = {1..0};
  var pos:[Domain] real;

  /*
  Initializes a point with dim dimensions intialized to 0.
  */
  proc init(dim: int) {
    Domain = {1..dim};
  }

  /*
  Initializes a point at the given location
  */
  proc init(pos: real ...?dim) {
    this.Domain = {1..dim};
    this.pos = [i in Domain] 0;
    for i in this.Domain {
      this.pos[i] = pos[i];
    }
  }

  /*
  Initializes a point as a copy of a point.
  */
  proc init(point: Point) {
    this.Domain = point.dom();
    this.pos = [i in Domain] 0;
    for i in this.Domain {
      this.pos[i] = point[i];
    }
  }

  /* Position getter */
  proc position() ref {
    return pos;
  }

  /* Expands dimensions to dim, or do nothing if point is bigger */ 
  proc expandDim(dim: int) : bool {
    if(dim <= this.dimensions()) {
      return false;
    }
    this.dom() = {1..dim};
    return true;
  }

  /* Domain getter */
  proc dom() ref {
    return Domain;
  }

  /* Dimensions getter */
  proc dimensions() {
    return dom().high;
  }

  /* Returns the distance between point and the origin */
  proc magnitude() : real {
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
    return sum ** (1/2 : real);
  }

  /* Returns distance between this point and a given point */
  proc manhattanDistance(point: Point) : real {
    if(point.dom() != this.dom()) {
      normalizeDimensions(this, point);
    }
    var sum: real;
    for (i, j) in zip(position(), point.position()) {
      sum += abs(i - j);
    }
    return sum;
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

  /* Returns the closest point, or the point if none exists */
  proc closest(points: Point ...?dim) : Point {
    var minDistance = max(real);
    var closest: Point = this;
    for i in 1..dim {
      var distance = this.distance(points[i]);
      if(distance <= minDistance) {
        minDistance = distance;
        closest = new unmanaged Point(points[i]);
      }
    }
    return closest;
  }
}

class Point2D: Point {
  proc init(x: real, y: real) {
    super.init(x, y);
  }
}

class Point3D: Point {
  proc init(x: real, y: real, z: real) {
    super.init(x, y, z);
  }
}

class Vector: Point {
  proc init(points: real ...?dim) {
    super.init((...points));
  }
}

/* Allows array-like access for points */
proc Point.this(i: int) ref: real {
  return position()[i];
}

/* Addition operator */
proc +(a: Point, b: Point) {
  var sum: unmanaged Point = new unmanaged Point(max(a.dimensions(), b.dimensions()));
  sum.add(a);
  sum.add(b);
  return sum;
}

/* Subtraction operator */
proc -(a: Point, b: Point) {
  var diff: unmanaged Point = new unmanaged Point(max(a.dimensions(), b.dimensions()));
  diff.add(a);
  diff.sub(b);
  return diff;
}

/* Dot product operator */
proc *(a: Point, b: Point) {
  var mult: unmanaged Point = new unmanaged Point(max(a.dimensions(), b.dimensions()));
  mult.add(a);
  mult.dot(b);
  return mult;
}

/* Scalar product operator */
proc *(a: Point, factor: real) {
  var mult: unmanaged Point = new unmanaged Point(a.dimensions());
  mult.add(a);
  mult.mult(factor);
  return mult;
}

/* Scalar division operator */
proc /(a: Point, divisor: real) {
  var div: unmanaged Point = new unmanaged Point(a.dimensions());
  div.add(a);
  div.div(divisor);
  return div;
}

/* Normalizes the dimensions of the points, expanding all dimensions to the max */
proc normalizeDimensions(points: Point ...?dim) {
  var maxDim = 0;
  for i in 1..dim {
    maxDim = max(maxDim, points[i].dimensions());
  }
  for i in 1..dim {
    points[i].expandDim(maxDim);
  }
}

/* "Static" functions */
proc add(point1: Point, point2: Point) {
  point1.add(point2);
}

proc sub(point1: Point, point2: Point) {
  point1.sub(point2);
}

proc mult(point: Point, factor: real) {
  point.mult(factor);
}

proc div(point: Point, divisor: real) {
  point.div(divisor);
}

proc dot(point1: Point, point2: Point) {
  point1.dot(point2);
}

/* Calculates the affine rank of a set of points (1 for line, 2 for plane, etc) */
proc affineRank(points: Point ...?dim) : int {
  if (dim == 0) {
    return -1;
  }
  var pointCopy: dim*Point;
  for i in 1..dim {
    pointCopy[i] = new unmanaged Point(points[i]);
  }
  proc matrank(points: Point ...?dim) : int {
    // Returns the index of the pivot, or -1 if its all 0
    proc pivot(row: int) : int {
      for i in 1..points[row].dimensions() {
        if(points[row][i] != 0) {
          return i;
        }
      }
      return -1;
    }
    var rank : int = 0;
    for i in 1..dim {
      var pivotIndex = pivot(i);
      if(pivotIndex != -1) {
        rank += 1;
        // Reducing points below
        for j in (i+1)..dim {
          var piv = pivot(j);
          if(piv != -1) {
            var ratio = points[i][pivotIndex]/points[j][piv];
            points[j].mult(ratio);
            points[j].sub(points[i]);
          }
        }
      } 
    }
    rank = max(rank, 1);
    return rank;
  }
  normalizeDimensions((...pointCopy));
  return matrank((...pointCopy));
}

/* Calculates if given points are colinear */
proc isColinear(points: Point ...?dim) : bool {
  return affineRank((...points)) <= 1;
}

/* Calculates if given points are coplanar */
proc isCoplanar(points: Point ...?dim) : bool {
  return affineRank((...points)) <= 2;
}

/*
Line
-----------
*/
class Line : GeoObj {
  var st: Point;
  var en: Point;

  /* Construct line from two points */
  proc init(start: Point, end: Point) {
    normalizeDimensions(start, end);
    this.st = start; 
    this.en = end; 
  }

  /* Construct line from point and vector */
  proc init(start: Point, vec: Vector) {
    normalizeDimensions(start, vec);
    this.st = start; 
    var end = new unmanaged Point(start);
    end.add(vec);
    this.en = end;
  }

  /* Getter and setter for start */
  proc start() ref {
    return this.st;
  }

  /* Getter and setter for end */
  proc end() ref {
    return this.en;
  }

  proc length() : real {
    return start().distance(end());
  }

  /* 
  Returns true if the point is on the line, pass in true for unbounded for ray 
  calculations.
  */
  proc containsPoint(obj: GeoObj) : bool {
    // Save for subclasses
    // if(isColinear(point, start(), end())) {
    //   if(!unbounded) {
    //     if(point[1] >= end()[1] && point[1] <= start()[1]) {
    //       return true;
    //     } else if(point[1] <= end()[1] && point[1] >= start()[1]) {
    //       return true;
    //     }
    //   } else {
    //     if(end()[1] > start()[1] && point[1] >= start()[1]) {
    //       return true;
    //     } else if(end()[1] < start()[1] && point[1] <= start()[1]) {
    //       return true;
    //     }
    //   }
    // }

    // TODO: Figure out type checking in this forsaken language
    // if(obj.type == Point) {
      return isColinear(obj: Point, start(), end());
    // }
    return false;
  }
}
}