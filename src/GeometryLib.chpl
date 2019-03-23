/* Documentation for GeometryLib */
module GeometryLib {

var TOLERANCE : real = .0000001;

/*
Point
-----------
*/
class Point {
  var Domain = {1..0};
  var pos:[Domain] real;
  var isVec: bool;

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
  proc dimensions() : int {
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
  proc dot(point: Point) : real {
    if(point.dom() != this.dom()) {
      normalizeDimensions(this, point);
    }
    var sum : real = 0;
    for i in dom() {
      sum += this[i] * point[i];
    }
    return sum;
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

  /* Returns a point that is an orthogonal question */
  proc orthogonalDirection() : Point {
    var orth: Point = new unmanaged Point(dimensions());
    if(this[1] == 0) {
      orth[1] = 1;
    } else if(this[2] == 0) {
      orth[2] = 1;
    } else {
      orth[1] = -orth[2];
      orth[2] = orth[1];
    }
    return orth;
  }
}

class Point2D: Point {
  proc init(x: real, y: real) {
    super.init(x, y);
  }

  proc init() {
    super.init(2);
  }

  proc init(point: Point2D) {
    super.init(point);
  }

  proc x() ref: real {
    return this[1];
  }

  proc y() ref: real {
    return this[2];
  }
}

class Point3D: Point {
  proc init(x: real, y: real, z: real) {
    super.init(x, y, z);
  }

  proc init() {
    super.init(3);
  }

  proc init(point: Point3D) {
    super.init(point);
  }

  proc x() ref: real {
    return this[1];
  }

  proc y() ref: real {
    return this[2];
  }

  proc z() ref: real {
    return this[3];
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
  return a.dot(b);
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
proc add(point1: Point, point2: Point) : Point {
  var result: Point = new unmanaged Point(point1);
  result.add(point2);
  return result;
}

proc sub(point1: Point, point2: Point) : Point {
  var result: Point = new unmanaged Point(point1);
  result.sub(point2);
  return result;
}

proc mult(point: Point, factor: real) : Point {
  var result: Point = new unmanaged Point(point);
  result.mult(factor);
  return result;
}

proc div(point: Point, divisor: real) : Point {
  var result: Point = new unmanaged Point(point);
  result.div(divisor);
  return result;
}

proc dot(point1: Point, point2: Point) : real {
  return point1.dot(point2);
}

/* Calculates the midpoint of the two given points */
proc midpoint(point1: Point, point2: Point) : Point {
  normalizeDimensions(point1, point2);
  var midpoint: Point = new unmanaged Point(point1.dimensions());
  for i in 1..point1.dimensions() {
    midpoint[i] = (point1[i] + point2[i]) / 2;
  }
  return midpoint;
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
class Line {
  var st: Point;
  var en: Point;

  /* Construct line from two points */
  proc init(start: Point, end: Point = nil, direction: Point = nil) {
    this.st = new unmanaged Point(start); 
    if(direction == nil) {
      normalizeDimensions(start, end);
      this.en = new unmanaged Point(end); 
    } else {
      normalizeDimensions(start, direction);
      var end = new unmanaged Point(start);
      end.add(direction);
      this.en = new unmanaged Point(end);
    }
  }

  proc deinit() {
    delete start();
    delete end();
  }

  /* Getter and setter for start */
  proc start() ref {
    return this.st;
  }

  /* Getter and setter for end */
  proc end() ref {
    return this.en;
  }

  /* Returns the length of the line */
  proc length() : real {
    return INFINITY;
  }

  /* 
  Returns true if the point is on the line, pass in true for unbounded for ray 
  calculations.
  */
  proc contains(point: Point) : bool {
    return isColinear(point: Point, start(), end());
  }

  /*
  Returns the direction of the line
  */
  proc direction() : Point {
    return end() - start();
  }

  /* Finds the angle between two lines */
  proc angle(line: Line) : real {
    var d1 = this.direction();
    var d2 = line.direction();
    return acos((d1*d2)/(d1.magnitude()*d2.magnitude()));
  }

  /* Returns true if the lines are parallel */
  proc isParallel(line: Line) : bool {
    var angle: real = this.angle(line);
    return realeq(angle, 0) || realeq(angle, pi);
  }

  /* Returns true if the lines are perpendicular */
  proc isPerpendicular(line: Line) : bool {
    return this.direction().dot(line.direction()) == 0;
  }

  /* Creates parallel line to this that passes through given point */
  proc parallelLine(point: Point) : Line {
    var end: Point = point + direction();
    return new unmanaged Line(point, end);
  }

  /* Creates perpendicular line to this that passes through given point */
  proc perpendicularLine(point: Point) : Line {
    var end: Point = point + direction().orthogonalDirection();
    return new unmanaged Line(point, end);
  }

  /* Returns the points */
  proc points() {
    return (start(), end());
  }

  /* Returns true if this line is equal */
  proc equals(line: Line) : bool {
    return isColinear(start(), end(), line.start(), line.end());
  }
}

class LineSegment : Line {
  proc init(start: Point, end: Point = nil, direction: Point = nil) {
    super.init(start, end, direction);
  }

  override proc length() : real {
    return abs((start() - end()).magnitude());
  }

  override proc contains(point: Point) : bool {
    var nonzero: int = 1;
    for i in 1..point.dimensions() {
      if(point[i] != 0) {
        nonzero = i;
        break;
      }
    }
    if(point[nonzero] > start()[nonzero] && point[nonzero] > end()[nonzero]) {
      return false;
    }
    if(point[nonzero] < start()[nonzero] && point[nonzero] < end()[nonzero]) {
      return false;
    }
    return isColinear(point: Point, start(), end());
  }

  /* Returns true if this line segment is equal */
  override proc equals(line: Line) : bool {
    return (start().equals(line.start()) && end().equals(line.end())) ||
          (start().equals(line.end()) && end().equals(line.start()));
  }

  /* Returns the midpoint of the line */
  proc midpoint() : Point {
    return GeometryLib.midpoint(start(), end());
  }

  /* Returns a perpendicular bisector */
  proc perpendicularBisector() : Line {
    return perpendicularLine(midpoint());
  }
}

class Ray: Line {
  proc init(start: Point, end: Point = nil, direction: Point = nil) {
    super.init(start, end, direction);
  }

  override proc contains(point: Point) : bool {
    var nonzero: int = 1;
    for i in 1..point.dimensions() {
      if(point[i] != 0) {
        nonzero = i;
        break;
      }
    }
    if(point[nonzero] < start()[nonzero] && point[nonzero] < end()[nonzero]) {
      return false;
    }
    return isColinear(point: Point, start(), end());
  }

  /* Returns true if this line segment is equal */
  override proc equals(line: Line) : bool {
    return isColinear(start(), end(), line.start(), line.end()) && start().equals(line.start());
  }

  /* Returns the source of the array (Same as start()) */
  proc source() ref {
    return start();
  }
}

class Line2D : Line {
  proc init(start: Point2D, end: Point2D = nil, direction: Point2D = nil) {
    super.init(start, end, direction);
  }

  /* Point - slope form */
  proc init(start: Point2D, slope: real) {
    if(slope == INFINITY) {
      super.init(start, new unmanaged Point(start.x(), start.y() + 1));
    }
    super.init(start, new unmanaged Point(start.x() + 1, slope));
  }

  proc slope() : real {
    if(start()[1] == end()[1]) {
      return INFINITY;
    }
    return (start()[2] - end()[2]) / (start()[1] - end()[1]);
  }
}

class Ray2D : Ray {
  proc init(start: Point2D, end: Point2D = nil, direction: Point2D = nil) {
    super.init(start, end, direction);
  }
}

class LineSegment2D : LineSegment {
  proc init(start: Point2D, end: Point2D = nil, direction: Point2D = nil) {
    super.init(start, end, direction);
  }
}

class Line3D : Line {
  proc init(start: Point3D, end: Point3D = nil, direction: Point3D = nil) {
    super.init(start, end, direction);
  }
}

class Ray3D : Line {
  proc init(start: Point3D, end: Point3D = nil, direction: Point3D = nil) {
    super.init(start, end, direction);
  }
}

class LineSegment3D : Line {
  proc init(start: Point3D, end: Point3D = nil, direction: Point3D = nil) {
    super.init(start, end, direction);
  }
}

/* Equality checking for floating point values. Is there a better way in chapel? */
proc realeq(a: real, b: real) : bool {
  return abs(a - b) < TOLERANCE;
}

class Polygon {
  var Domain = {1..0};
  var vert:[Domain] Point;

  proc init(vertices: Point ...?dim){
    this.Domain = {1..dim}; 
    this.vert = [i in Domain] new unmanaged Point(0);
    for i in 1..dim {
      vert[i] = new unmanaged Point(vertices[i]);
    }
  }
}
}