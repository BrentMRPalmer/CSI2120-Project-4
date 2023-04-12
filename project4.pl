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
% which are stored in the second list Float.
% ----------------

convert_to_float([],[]).
convert_to_float([H|T],[HH|TT]) :-
    atom_number(H, HH),
    convert_to_float(T,TT). 