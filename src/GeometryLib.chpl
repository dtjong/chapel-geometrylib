/* Documentation for GeometryLib */
module GeometryLib {
/*
Point
-----------
*/
class Point {
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

  /* Returns the closest point, or the point if none exists */
  proc closest(points: Point ?...dim) : Point {
    var minDistance = max(real);
    var closest: Point = this;
    for i in dim {
      var distance = this.distance(points[i]);
      if(distance <= minDistance) {
        minDistance = distance;
        closest = points[i];
      }
    }
    return closest;
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
}