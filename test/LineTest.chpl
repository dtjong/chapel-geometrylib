use GeometryLib;

proc assert(cond: bool) {
    if(!cond) {
        exit(1);
    }
}

{
// test line constructors
var point1: Point2D = new owned Point2D(4, 6);
var point2: Point2D = new owned Point2D(6, 10);
var dir: Point2D = new owned Point2D(3, 3);
var line: Line = new owned Line(point1, point2);
assert(line.start().equals(point1));
assert(line.end().equals(point2));
var line1: Line = new owned Line(point1, point1, dir);
assert(line1.start().equals(point1));
assert(line1.end().equals(new owned Point(7, 9)));
}

// line length test
{
var point1: Point2D = new owned Point2D(2, 5);
var point2: Point2D = new owned Point2D(6, 10);
var line: Line = new owned Line(point1, point2);
assert(line.length() == INFINITY);
}

// line contains point test
{
var point: Point2D = new owned Point2D(2, 4);
var point1: Point2D = new owned Point2D(3, 6);
var point2: Point2D = new owned Point2D(4, 8);
var point3: Point2D = new owned Point2D(1, 2);
var line: Line = new owned Line(point, point2);
assert(line.contains(point1));
var line2: Line = new owned Line(point, point1);
assert(line2.contains(point2));
}

// test direction method
{
var point: Point2D = new owned Point2D(2, 4);
var point1: Point2D = new owned Point2D(3, 6);
var line: Line = new owned Line(point, point1);
assert(line.direction().equals(new owned Point(1, 2)));
}

// test angle method
{
var point: Point2D = new owned Point2D(1, 0);
var point2: Point2D = new owned Point2D(1, 1);
var point3: Point2D = new owned Point2D(0, 1);
var point1: Point2D = new owned Point2D(2, 2);
var origin: Point2D = new owned Point2D(0, 0);
var line: Line = new owned Line(origin, point1);
var line1: Line = new owned Line(origin, point);
assert(abs(line.angle(line1) - pi / 4) <= .00000001);
// Testing parallel
var line2: Line = new owned Line(origin, point);
var line3: Line = new owned Line(point3, point2);
var line4: Line = new owned Line(origin, point3);
assert(line2.isParallel(line3));
assert(!line2.isParallel(line));
// Testing perpendicular
assert(line2.isPerpendicular(line4));
assert(!line2.isPerpendicular(line3));
}

{
var point: Point2D = new owned Point2D(0, 0);
var point1: Point2D = new owned Point2D(1, 1);
var point2: Point2D = new owned Point2D(2, 0);
var line: Line = new owned Line(point, point1);
assert(line.parallelLine(point2).isParallel(line));
assert(line.perpendicularLine(point2).isPerpendicular(line));
}

{
var point: Point2D = new owned Point2D(0, 0);
var point1: Point2D = new owned Point2D(1, 1);
var line: Line = new owned Line(point, point1);
assert(line.points()[1][1] == 0);
}

{
// Test line equals
var point: Point2D = new owned Point2D(0, 0);
var point1: Point2D = new owned Point2D(1, 1);
var point2: Point2D = new owned Point2D(2, 2);
var point3: Point2D = new owned Point2D(3, 3);
var line: Line = new owned Line(point, point1);
var line1: Line = new owned Line(point2, point3);
assert(line.equals(line1));
}

{
// Testing line segment length
var point: Point2D = new owned Point2D(0, 0);
var point1: Point2D = new owned Point2D(3, 4);
var line: LineSegment = new owned LineSegment(point, point1);
assert(line.length() == 5);
}

{
// Testing line segment length
var point: Point2D = new owned Point2D(0, 0);
var point1: Point2D = new owned Point2D(0, 4);
var point2: Point2D = new owned Point2D(0, 3);
var point3: Point2D = new owned Point2D(0, 5);
var line: LineSegment = new owned LineSegment(point, point1);
assert(line.contains(point2));
assert(!line.contains(point3));
}

{
var point: Point2D = new owned Point2D(0, 0);
var point1: Point2D = new owned Point2D(1, 1);
var point2: Point2D = new owned Point2D(0, 0);
var point3: Point2D = new owned Point2D(1, 1);
var point4: Point2D = new owned Point2D(2, 2);
var line: LineSegment = new owned LineSegment(point, point1);
var line1: LineSegment = new owned LineSegment(point2, point3);
var line2: LineSegment = new owned LineSegment(point2, point4);
assert(line.equals(line1));
assert(!line.equals(line2));
}

{
var point: Point2D = new owned Point2D(0, 0);
var point1: Point2D = new owned Point2D(1, 1);
var point2: Point2D = new owned Point2D(0, 0);
var point4: Point2D = new owned Point2D(2, 2);
var line: Ray = new owned Ray(point, direction = point1);
var line1: Ray = new owned Ray(point2, direction = point4);
var line2: Ray = new owned Ray(point4, direction = point1);
assert(line.equals(line1));
assert(!line.equals(line2));
}

{
// Test midpoint
var point: Point = new owned Point(2, 2);
var point1: Point = new owned Point(4, 6);
var lineseg: LineSegment = new owned LineSegment(point, point1);
var mid = lineseg.midpoint();
assert(mid[1] == 3 && mid[2] == 4);
}

{
// Test perpendicular bisector
var point: Point = new owned Point(0, 0);
var point1: Point = new owned Point(6, 6);
var lineseg: LineSegment = new owned LineSegment(point, point1);
var bisector: Line = lineseg.perpendicularBisector();
assert(lineseg.isPerpendicular(bisector));
assert(bisector.contains(lineseg.midpoint()));
}

{
// Line2D constructors
var point: Point2D = new owned Point2D(0, 0);
var point1: Point2D = new owned Point2D(6, 6);
var line: Line2D = new owned Line2D(point, point1);
var line1: Line2D = new owned Line2D(point, 1);
assert(line.isParallel(line1));
var lineseg2D: LineSegment2D = new owned LineSegment2D(point, point1);
var ray2D: Ray2D = new owned Ray2D(point1, point);
// Slope
assert(line.slope() == 1);
}

{
// 3D Constructors
var point1: Point3D = new owned Point3D(6, 6, 6);
var point2: Point3D = new owned Point3D(0, 0, 9);
var line3d: Line3D = new owned Line3D(point1, point2);
var ray3d: Ray3D = new owned Ray3D(point1, point2);
var seg3d: LineSegment3D = new owned LineSegment3D(point1, point2);
}