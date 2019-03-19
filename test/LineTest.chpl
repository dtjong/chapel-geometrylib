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
var point1: Point2D = new owned Point2D(3, 6);
var point2: Point2D = new owned Point2D(6, 10);
var line: Line = new owned Line(point1, point2);
assert(line.length() == 5);
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