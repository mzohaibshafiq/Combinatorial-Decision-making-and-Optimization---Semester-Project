include "globals.mzn";
include "rotate_data.dzn";

% number of rectangles 
int: num_circuits; 

set of int: CIRCUIT_DIM = 1..num_circuits;
% the number of rotations is just 2 times the number of circuits 
set of int: rotations = 1..(num_circuits*2);
array[rotations,1..2] of int: circuits; 
array[CIRCUIT_DIM,1..2] of set of rotations: shape;
int: max_height; 
int: width; 

array[CIRCUIT_DIM] of var 0..width: x;
array[CIRCUIT_DIM] of var 0..max_height: y;
array[CIRCUIT_DIM] of var 1..2: rotation_array;

var 0..max_height: h;


solve minimize h;

constraint forall(i in CIRCUIT_DIM)(forall(r in rotations)
  (r in shape[i,rotation_array[i]] -> 
  (x[i] + circuits[r,1]  <= width /\
   y[i] + circuits[r,2]  <= h)));

constraint forall(i,j in CIRCUIT_DIM where i < j)
  (forall(r1,r2 in rotations)
 (r1 in shape[i,rotation_array[i]] /\ 
  r2 in shape[j,rotation_array[j]] -> 
(x[i] +  circuits[r1,1] <= x[j] 
                   \/
 x[j] +  circuits[r2,1] <= x[i] 
                   \/
 y[i] +  circuits[r1,2] <= y[j] 
                   \/
 y[j] +  circuits[r2,2] <= y[i] 
   )));
   
output["\n--max height = ", show(h)];
output["\n--width =", show(width)];
output["\n--X coordinates ", show(x)];
output["\n--Y coordinates ", show(y)];
output["\n--rotations (1 or 2 for each rect) : ", show(rotation_array)];