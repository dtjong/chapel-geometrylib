use GeometryLib;

proc assert(cond: bool) {
    if(!cond) {
        exit(1);
    }
}

{
// Test empty constructor
var point: Point = new owned Point(3);
assert(point[1] == 0 && point[3] == 0);
}

{
// Test init constructor
var point: Point = new owned Point(1, 2, 3);
assert(point[2] == 2);
}

{
// Test copy constructor
var point: Point = new owned Point(1, 2, 3);
var copyPoint: Point = new owned Point(point);
assert(copyPoint[2] == 2);
}

{
// Test absolute value
var point: Point = new owned Point(1, 2, 3);
assert(point.abs() == 14 ** (1/2));
}

{
// Test equals
var point: Point = new owned Point(1, 2, 3);
var point1: Point = new owned Point(1, 2, 3);
assert(point.equals(point1));
}

{
// Test negate
var point: Point = new owned Point(2, 4, 6);
point.negate();
assert(point[1] == -2 && point[2] == -4 && point[3] == -6);
}

{
// Test dot
var point: Point = new owned Point(1, 2, 3);
var point1: Point = new owned Point(1, 2, 3);
point.dot(point1);
assert(point[1] == 1 && point[2] == 4 && point[3] == 9);
}

{
// Test expand dimensions
var point: Point = new owned Point(2, 2);
assert(point.expandDim(3));
assert(point[1] == 2);
assert(point[3] == 0);
assert(!point.expandDim(3));
}

{
// Test normalize dimensions
var point: Point = new owned Point(2, 2);
var point1: Point = new owned Point(4, 2, 0);
normalizeDimensions(point, point1);
assert(point[3] == 0);
}

{
// Test arithmetic functions
var point: Point = new owned Point(1, 2, 3);
var point1: Point = new owned Point(3, 2, 3);
point.add(point1);
assert(point[1] == 4 && point[2] == 4 && point[3] == 6);

point.sub(point1);
assert(point[1] == 1 && point[2] == 2 && point[3] == 3);

point.mult(4);
assert(point[1] == 4 && point[2] == 8 && point[3] == 12);

point.div(2);
assert(point[1] == 2 && point[2] == 4 && point[3] == 6);

point.negate();
assert(point[1] == -2 && point[2] == -4 && point[3] == -6);

var point2: Point = point + point1;
assert(point2[1] == 1 && point2[2] == -2 && point2[3] == -3);

var point3: Point = point - point1;
assert(point3[1] == -5 && point3[2] == -6 && point3[3] == -9);

var point4: Point = point * point2;
assert(point4[1] == -2 && point4[2] == 8 && point4[3] == 18);

var point5: Point = point4 / 2;
assert(point5[1] == -1 && point5[2] == 4 && point5[3] == 9);

var point6: Point = point5 * 3;
assert(point6[1] == -3 && point6[2] == 12 && point6[3] == 27);
}