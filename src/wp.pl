:- use_module(library(clpfd)).
:- use_module(library(lists)).

checkColSum([Col1, Col2, Col3, Col4], [[_, N1], [_, N2], [_, N3], [_, N4], [_, N5], [_, N6], [_, N7], [_, N8]]) :-
    abs(N1 * N2 - Col1) #= 1,
    abs(N3 * N4 - Col2) #= 1,
    abs(N5 * N6 - Col3) #= 1,
    abs(N7 * N8 - Col4) #= 1.

ln2(X) :-
    length(X, 2).

solve([LowerLimit, UpperLimit], [[Col1, Col2, Col3, Col4], [Row1, Row2, Row3, Row4]], Res) :-
    Vars = [
        [Pos1, Num1], [Pos2, Num2],
        [Pos3, Num3], [Pos4, Num4],
        [Pos5, Num5], [Pos6, Num6],
        [Pos7, Num7], [Pos8, Num8]
    ],

    NumList = [Num1, Num2, Num3, Num4, Num5, Num6, Num7, Num8],
    PosList = [Pos1, Pos2, Pos3, Pos4, Pos5, Pos6, Pos7, Pos8],

    domain(NumList, LowerLimit, UpperLimit),
    domain(PosList, 1, 4),
    
    all_distinct(NumList),

    global_cardinality(PosList, [1-2, 2-2, 3-2, 4-2]),

    abs(Num1 * Num2 - Row1) #= 1,
    abs(Num3 * Num4 - Row2) #= 1,
    abs(Num5 * Num6 - Row3) #= 1,
    abs(Num7 * Num8 - Row4) #= 1,

    Pos1 #\= Pos2,
    Pos3 #\= Pos4,
    Pos5 #\= Pos6,
    Pos7 #\= Pos8,
    
    length(Vars, _Len), 
    length(VarsSorted, _Len),
    maplist(ln2, VarsSorted),
    keysorting(Vars, VarsSorted),
    checkColSum([Col1, Col2, Col3, Col4], VarsSorted),

    labeling([], PosList),
    labeling([], NumList),

    Res = Vars, !.
