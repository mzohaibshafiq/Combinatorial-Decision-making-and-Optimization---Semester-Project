include "globals.mzn";
include "diffn.mzn";
include "all_instances.dzn";

%width of fitting space
int: width;
%number of circuits
int: num_circuits;

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

% Constraints

% boundaries constraint   
constraint
        forall( i in CIRCUIT_DIM ) (
            X[i] + circuitX[i]  <= width
        );
        
        
constraint
        forall( i in CIRCUIT_DIM  ) (
            Y[i] + circuitY[i] <= Height
        );


% global non-overlap constraint
constraint diffn(X,Y,circuitX,circuitY);

        
% simmetry constraint, same blocks  
constraint symmetry_breaking_constraint(forall( i,j in CIRCUIT_DIM where i<j ) (
            not (circuitX[i] == circuitX[j] /\ circuitY[i] == circuitY[j]) \/ (if X[i] == X[j] then Y[i] >= Y[j] else X[i] > X[j] endif)
        ));
        
       

%redundant cumulative constraint
constraint cumulative(
            [ X[i] | i in CIRCUIT_DIM  ],
            [ circuitX[i]  | i in CIRCUIT_DIM ],
            [ circuitY[i]  | i in CIRCUIT_DIM ],
            Height
        );
        
constraint cumulative(
            [ Y[i] | i in CIRCUIT_DIM],
            [ circuitY[i]  | i in CIRCUIT_DIM ],
            [ circuitX[i]  | i in CIRCUIT_DIM  ],
            width
        );
        
% Goal/objective
solve::  
int_search([ Height ]
            ++ [ X[num_circuits] | i in CIRCUIT_DIM ]
            ++ [ Y[num_circuits] | i in CIRCUIT_DIM ],
            dom_w_deg, indomain_split,
            )satisfy;

% output sequence
output["\n--max height = ", show(Height)];
output["\n--width =", show(width)];
output["\n--X coordinates ", show(X)];
output["\n--Y coordinates ", show(Y)];
output["\n--X dimensions ", show(circuitX)];
output["\n--Y dimensions ", show(circuitY)];
