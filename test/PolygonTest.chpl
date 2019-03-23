use GeometryLib;

proc assert(cond: bool) {
    if(!cond) {
        exit(1);
    }
}

{
// test polygon constructors
var point1: Point2D = new owned Point2D(4, 6);
var point2: Point2D = new owned Point2D(6, 10);
var point3: Point2D = new owned Point2D(4, 9);
var poly = new owned Polygon(point1, point2, point3);
}