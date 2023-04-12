Name: Brent Palmer
Student Number: 300193610

Status of the project: All code complete and working. 

1 file, Project3.rkt, contains all code. 
4 files, Point_Cloud_1_No_Road_Reduced.xyz, Point_Cloud_2_No_Road_Reduced.xyz
         Point_Cloud_3_No_Road_Reduced.xyz, PointCloud1.xyz
	 store the respective original point clouds. PointCloud1.xyz is used
         to provide a reference point for comparison with projects parts 1 and 2
         to assess accuracy. 
4 files, Point_Cloud_1_No_Road_Reduced_p1.xyz, Point_Cloud_2_No_Road_Reduced_p1.xyz
         Point_Cloud_3_No_Road_Reduced_p1.xyz, PointCloud1_p1.xyz
         include the dominant point clouds of each of the respective point clouds. 
1 file, Part 3.pdf is included for reference to instructions. 

The return values of saveXYZ are outlined here for the four point clouds (this is equivalent to planeRANSAC outputs, as saveXYZ outputs to console the results of planeRANSAC):
Confidence: 0.99 Percentage: 0.5 Eps: 0.5
> (saveXYZ "PointCloud1.xyz" "PointCloud1_p1.xyz" 0.99 0.5 0.5)
(36473 0.03587041764862462 0.04828220825691916 -2.038073884379577 1.7594300423607363)
> (saveXYZ "Point_Cloud_1_No_Road_Reduced.xyz" "Point_Cloud_1_No_Road_Reduced_p1.xyz" 0.99 0.5 0.5)
(2408 0.31283990925063776 2.347644946406792 53.10236780893048 5.295670841318241)
> (saveXYZ "Point_Cloud_2_No_Road_Reduced.xyz" "Point_Cloud_2_No_Road_Reduced_p1.xyz" 0.99 0.5 0.5)
(3304 7.310585101096196 -30.38663845118657 -259.8538814636473 -83.57373222160356)
> (saveXYZ "Point_Cloud_3_No_Road_Reduced.xyz" "Point_Cloud_3_No_Road_Reduced_p1.xyz" 0.99 0.5 0.5)
(3077 28.79040043903982 -7.303585119558877 -392.1713440866432 -270.3190081477919)
> 


NOTE: I implemented an additional function called SaveXYZ that both executes planeRANSAC and 
saves the points to a file. I did not add the saving to planeRANSAC itself, as Scheme
does not overwrite files. Manual deletion is a hassle, so this modularity allows for
quick successive runs of planeRANSAC for testing. 

Link to repo: https://github.com/BrentMRPalmer/Project-3

Test Cases:


Function: readXYZ
(readXYZ "Point_Cloud_1_No_Road_Reduced.xyz")
[outputs a lot of points]

Function: plane
(plane '(1 2 2) '(3 2 1) '(5 1 3))
(-1 -6 -2 -17)
(plane '(15 25 25) '(31 22 14) '(-5 12 32))
(-164 108 -268 -6460)

Function: distance
(distance '(-1 -6 -2 -17) '(5 6 7))
5.9346029517670305
(distance '(-164 108 -268 -6460) '(22 46 75))
36.96113533751999
(distance '(-1 -6 -2 -17) '(1 2 3))
0.31234752377721214
(distance '(-1 -6 -2 -17) '(4 5 6))
4.529039094769575
(distance '(-1 -6 -2 -17) '(-1 0 1))
2.498780190217697

Function: support
(support '(-1 -6 -2 -17) '((1 2 3) (4 5 6) (-1 0 1)) 4)
(2 -1 -6 -2 -17)

Function: ransacNumberOfIteration
(ransacNumberOfIteration 0.99 0.5)
35.0

Function: dominantPlane
(dominantPlane (readXYZ "Point_Cloud_1_No_Road_Reduced.xyz") 35 1.2)
[some equation parameters]

(dominantPlane (readXYZ "PointCloud1.xyz") 35 0.5)
[some equation parameters]

Function: planeRANSAC
(planeRANSAC "PointCloud1.xyz" 0.99 0.5 0.5)
~36k points, [some equation parameters]
(planeRANSAC "Point_Cloud_1_No_Road_Reduced.xyz" 0.99 0.5 0.5)
~2k points, [some equation parameters]
(planeRANSAC "Point_Cloud_2_No_Road_Reduced.xyz" 0.99 0.5 0.5)
~3k points, [some equation parameters]
(planeRANSAC "Point_Cloud_3_No_Road_Reduced.xyz" 0.99 0.5 0.5)
~3k points, [some equation parameters]


Function: saveXYZ
(saveXYZ "PointCloud1.xyz" "PointCloud1_p1.xyz" 0.99 0.5 0.5)
~36k points, [some equation parameters] 
Also writes to a file.
(saveXYZ "Point_Cloud_1_No_Road_Reduced.xyz" "Point_Cloud_1_No_Road_Reduced_p1.xyz" 0.99 0.5 0.5)
~2k points, [some equation parameters]
Also writes to a file.
(saveXYZ "Point_Cloud_2_No_Road_Reduced.xyz" "Point_Cloud_2_No_Road_Reduced_p1.xyz" 0.99 0.5 0.5)
~3k points, [some equation parameters]
Also writes to a file.
(saveXYZ "Point_Cloud_3_No_Road_Reduced.xyz" "Point_Cloud_3_No_Road_Reduced_p1.xyz" 0.99 0.5 0.5)
~3k points, [some equation parameters]
Also writes to a file.



