% Student Full Name: Brent Palmer
% Student ID: 300193610

% ----------------
% read_xyz_file(File, Points)
% This predicate takes the name of an XYZ file that 
% contains 3D Points (File), and stores the list
% of the 3D Points in Points in the 
% form [[x1,y1,z1],[x2,y2,z2],...,[xn,yn,zn]].
% ----------------

read_xyz_file(File, Points) :-
    open(File, read, Stream),
    read_line_to_string(Stream,_),
    read_xyz_points(Stream,Points),
    close(Stream).
read_xyz_points(Stream, []) :-
    at_end_of_stream(Stream).
read_xyz_points(Stream, [Point|Points]) :-
    \+ at_end_of_stream(Stream),
    read_line_to_string(Stream,L), 
    split_string(L, "\t", "\s\t\n",XYZ), 
    convert_to_float(XYZ,Point),
    read_xyz_points(Stream, Points).

% ----------------
% convert_to_float(IntegerList, FloatList)
% This predicate takes a list of decimal numbers IntegerList in
% string representation and converts them into floats,
% which are stored in the second list FloatList.
% ----------------

convert_to_float([],[]).
convert_to_float([H|T],[HH|TT]) :-
    atom_number(H, HH),
    convert_to_float(T,TT). 

% ----------------
% random3points(Points, Point3) :
% This predicate should be true if Point3 is a triplet of points randomly selected from
% the list of points Points. The triplet of points is of the form [[x1,y1,z1],
% [x2,y2,z2], [x3,y3,z3]].
% ----------------

random3points(Points, Point3) :-
    length(Points, Length), % make sure the list of points has at least 3 points 
    Length >= 3, % (will fail either way, but improves readability)
    select([P1X, P1Y, P1Z], Points, Points2), % select the first point from the list, and remove it (using select ensures the points are distinct)
    select([P2X, P2Y, P2Z], Points2, Points3), % select the second point from the list without point 1, and remove the second point
    select([P3X, P3Y, P3Z], Points3, _), % select the third point from the list without points 1 and 2
    Point3 = [[P1X, P1Y, P1Z], [P2X, P2Y, P2Z], [P3X, P3Y, P3Z]]. % bind the 3 points to Point3

% tests for random3points prediacte
test_random3points(random3points, 1) :-
    read_xyz_file('Point_Cloud_1_No_Road_Reduced.xyz', Points),
    random3points(Points, [[-5.1323336, -4.089636333, 0.243960825], [-5.301170142, -3.753989106, 0.056347458], [-7.353630223, -3.802346022, 0.915710966]]).

run_random3points(Point3) :-
    read_xyz_file('Point_Cloud_1_No_Road_Reduced.xyz', Points),
    random3points(Points, Point3).


% ----------------
% plane(Point3 , Plane) :
% This predicate should be true if Plane is the equation of the plane defined by the three
% points of the list Point3. The plane is specified by the list [a,b,c,d] from the
% equation ax+by+cz=d. The list of points is of the form [[x1,y1,z1],
% [x2,y2,z2], [x3,y3,z3]].
% ----------------

plane(Point3, Plane) :-
    Point3 = [[P1X, P1Y, P1Z], [P2X, P2Y, P2Z], [P3X, P3Y, P3Z]],
    X1 is P2X - P1X, % calculate vector 1
    Y1 is P2Y - P1Y,
    Z1 is P2Z - P1Z,
    X2 is P3X - P1X, % calculate vector 2
    Y2 is P3Y - P1Y,
    Z2 is P3Z - P1Z,
    A is Y1 * Z2 - Z1 * Y2, % calculate A
    B is Z1 * X2 - X1 * Z2, % calculate B
    C is X1 * Y2 - Y1 * X2, % calculate C
    D is A * P3X + B * P3Y + C * P3Z, % calculate D
    Plane = [A, B, C, D]. % store results in Plane

%tests for plane predicate
test_plane(plane, 1) :- plane([[1,2,3],[2,1,3],[4,8,9]], [-6, -6, 9, 9]).
test_plane(plane, 2) :- plane([[4,6,2],[4,1,3],[2,8,8]], [-32,-2,-10,-160]).
test_plane(plane, 3) :- plane([[3,2,1],[3,8,2],[2,8,5]], [18, -1, 6, 58]).
test_plane(plane, 4) :- plane([[2,2,1],[3,3,9],[2,4,5]], [-12, -4, 2, -30]).
test_plane(plane, 5) :- plane([[12,20,15],[3,1,12],[12,4,35]], [-428,180,144,624]).

% test_plane(plane, N).

% ----------------
% Distance (Point, Plane, Distance) :
% This predicate should be true if the distance between 
% point Point and plane Plane is Distance. 
% ----------------

distance(Point, Plane, Distance) :- 
    Point = [X, Y, Z], % extract the X, Y, Z values of plane
    Plane = [A, B, C, D], % extract the A, B, C, D values of plane
    Distance is (abs(A*X + B*Y + C*Z - D) / sqrt(A*A + B*B + C*C)). % l = |a*x + b*y + c*z - d| / sqrt(a^2, b^2, c^2)

% tests for distance predicate
test_distance(distance, 1) :- distance([5, 6, 7], [-1, -6, -2, -17], 5.9346029517670305).
test_distance(distance, 2) :- distance([22, 46, 75], [-164, 108, -268, -6460], 36.96113533752).
test_distance(distance, 3) :- distance([1, 2, 3], [-32,-2,-10,-160], 2.7988092706244445).
test_distance(distance, 4) :- distance([4, 5, 6], [18, -1, 6, 58], 2.3684210526315788).
test_distance(distance, 5) :- distance([-1, 0, 1], [-428,180,144,624], 0.10696781006442868).

% test_distance(distance, N).

% ----------------
% support(Plane, Points, Eps, N) :
% This predicate should be true if the support of plane Plane is composed of N points
% from the list of points Point3 when the distance Eps is used.
% ----------------

support(Plane, Points, Eps, N) :-   
   findall(Point, (member(Point, Points), distance(Point, Plane, Distance), Distance < Eps), SupportPoints),
   length(SupportPoints, N).

% tests for support predicate (do not use test_support(support, N), it does not work with the file reader)
test_support(support, 1) :- support([-1, -6, -2, -17], [[1, 2, 3], [4, 5, 6], [-1, 0, 1]], 4, 2).
test_support(support, 2) :- 
    read_xyz_file('Point_Cloud_1_No_Road_Reduced.xyz', Points), 
    support([19.333873023963836, -80.04587121800272, 1106.4108234554967, 146.49993670668204], Points, 0.5, 2372).
test_support(support, 3) :- 
    read_xyz_file('Point_Cloud_1_No_Road_Reduced.xyz', Points), 
    support([-6, -6, 9, 9], Points, 0.5, 144).
test_support(support, 4) :- 
    read_xyz_file('Point_Cloud_2_No_Road_Reduced.xyz', Points),
    support([-32,-2,-10,-160], Points, 1.2, 905).
test_support(support, 5) :- 
    read_xyz_file('Point_Cloud_3_No_Road_Reduced.xyz', Points), 
    support([18, -1, 6, 58], Points, 1.5, 53).

% ----------------
% ransac-number-of-iterations(Confidence, Percentage, N) :
% This predicate should be true if N is the number of iterations required by RANSAC with
% parameters Confidence et Percentage according to the formula given in the
% problem description section.
% ----------------

ransac-number-of-iterations(Confidence, Percentage, N) :-
    P1 is 1 - Confidence, % break down the equation 
    P2 is log10(P1), % log10(1 - Confidence)
    P3 is Percentage ** 3, % Percentage ^ 3
    P4 is 1 - P3, % 1 - (Percentage ^ 3)
    P5 is log10(P4), % log10(1 - (Percentage ^ 3))
    P6 is P2 / P5, % log10(1 - Confidence) / log10(1 - (Percentage ^ 3))
    N is ceiling(P6). % ceiling (log10(1 - Confidence) / log10(1 - (Percentage ^ 3)))

% tests for ransac-number-of-iterations predicate
test_ransac(ransac-number-of-iterations, 1) :- ransac-number-of-iterations(0.99, 0.5, 35).
test_ransac(ransac-number-of-iterations, 2) :- ransac-number-of-iterations(0.6, 0.4, 14).
test_ransac(ransac-number-of-iterations, 3) :- ransac-number-of-iterations(0.8, 0.4, 25).
test_ransac(ransac-number-of-iterations, 4) :- ransac-number-of-iterations(0.2, 0.3, 9).
test_ransac(ransac-number-of-iterations, 5) :- ransac-number-of-iterations(0.94, 0.65, 9).

% test_ransac(ransac-number-of-iterations, N)