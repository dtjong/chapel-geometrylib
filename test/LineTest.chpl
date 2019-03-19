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
var vec: Vector = new owned Vector(3, 3);
var line: Line = new owned Line(point1, point2);
assert(line.start().equals(point1));
assert(line.end().equals(point2));
var line1: Line = new owned Line(point1, vec);
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

// line contains test
{
var point: Point2D = new owned Point2D(2, 4);
var point1: Point2D = new owned Point2D(3, 6);
var point2: Point2D = new owned Point2D(4, 8);
var point3: Point2D = new owned Point2D(1, 2);
var line: Line = new owned Line(point, point2);
assert(line.containsPoint(point1));
var line2: Line = new owned Line(point, point1);
assert(line2.containsPoint(point2));
}