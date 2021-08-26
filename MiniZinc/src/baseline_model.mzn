include "globals.mzn";
include "diffn.mzn";
include "all_instances.dzn";

%width of fitting space
int: width;
%number of circuits
int: num_circuits;

%Set of sqaures that we would fit 1..n
set of int: CIRCUIT_DIM = 1..num_circuits;

array[CIRCUIT_DIM] of int: circuitX;
array[CIRCUIT_DIM] of int: circuitY;

% Lower bound for the height
int: min_height = max(circuitY);
% Upper bound for the height
int: max_height   = sum(circuitY);

array [ CIRCUIT_DIM ] of var 0..width : X;
array [ CIRCUIT_DIM ] of var 0..max_height: Y;
    
%Optimal/Minimum height that we are to find
var min_height..max_height: Height;

% Constraints.


% global non-overlap constraint
constraint
    forall( i, j in CIRCUIT_DIM where i < j ) (
        X[i] + circuitX[i] <= X[j] 
    \/  X[j] + circuitX[j] <= X[i] 
    \/  Y[i] + circuitY[i] <= Y[j]
    \/  Y[j] + circuitY[j] <= Y[i]
    );
        

% all rows width must be lower than max width
constraint
        forall( i in CIRCUIT_DIM ) (
            X[i] + circuitX[i]  <= width
        );
        

% all coloumns height must be lower than max height
constraint
        forall( i in CIRCUIT_DIM  ) (
            Y[i] + circuitY[i] <= Height
        );

% Goal/objective
solve::  
int_search([ Height ]
            ++ [ X[num_circuits] | i in CIRCUIT_DIM ]
            ++ [ Y[num_circuits] | i in CIRCUIT_DIM ],
            input_order, indomain_split, first_fail
            )satisfy;
            
% output sequence
output["\n--max height = ", show(Height)];
output["\n--width =", show(width)];
output["\n--X coordinates ", show(X)];
output["\n--Y coordinates ", show(Y)];
output["\n--X dimensions ", show(circuitX)];
output["\n--Y dimensions ", show(circuitY)];
