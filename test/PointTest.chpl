use GeometryLib;

var point: Point = new Point(3);
if (point.position[1] == 0) {
    writeln("test passed");
} else {
    exit(1);
}

var point1: Point = new Point(1, 2, 3);
if (point1.position[2] == 2) {
    writeln("test passed");
} else {
    exit(1);
}

if (point1.abs() == 14 ** (1/2)) {
    writeln(point1.abs());
    writeln("test passed");
} else {
    exit(1);
}