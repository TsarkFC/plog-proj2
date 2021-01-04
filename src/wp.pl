:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- consult('generator.pl').
:- consult('display.pl').

% makeLength2(X)
% Succeeds if X is a list with 2 elements
makeLength2(X) :-
    length(X, 2).

% solve(+LimitList, +RowsAndCols, -Res)
% Solves the problem, given the variables domain and the columns and rows header values
% Unifies result with Res
solve([LowerLimit, UpperLimit], [Columns, Rows], Res) :-
    generateVars(Columns, Rows, Vars),
    generateNumPosList(Vars, NumList, PosList),

    domain(NumList, LowerLimit, UpperLimit),
    length(Columns, ColNum),
    domain(PosList, 1, ColNum),
    
    all_distinct(NumList),

    generateCardinalityList(ColNum, CardinalityList),
    global_cardinality(PosList, CardinalityList),

    checkRowSum(Rows, Vars),

    distinctColumnPosition(PosList),
    
    length(Vars, _Len), 
    length(VarsSorted, _Len),
    maplist(makeLength2, VarsSorted),

    keysorting(Vars, VarsSorted),

    checkColSum(Columns, VarsSorted),

    labeling([], PosList),
    labeling([], NumList),

    Res = Vars, !,
    display_solution(Res, Columns, Rows).

% generateVars(+Columns, +Row, -Vars)
% Creates the list of control variables, unified in Vars
generateVars(Columns, Rows, Vars) :-
    length(Columns, ColumnsLength),
    length(Rows, RowsLength),
    ColumnsLength == RowsLength,
    Size is RowsLength * 2,
    length(Vars, Size),
    maplist(makeLength2, Vars).

% checkColSum(+ColList, +VarsSorted)
% VarsSorted is sorted by column. Makes sure that, for each VarsSorted element pair, which is for sure 
% in the same column, their values are according to the game's column restrictions.
checkColSum([], []).
checkColSum([ CurrentCol | Columns ], [ [_, Value1], [_, Value2] | VarsSortedT ]) :-
    abs(Value1 * Value2 - CurrentCol) #= 1,
    checkColSum(Columns, VarsSortedT).

% checkRowSum(+ColList, +Vars)
% Vars is in an order such that each pair of consecutive elements is in the same row.
% Makes sure that all of those pairs are according to the problem's row restrictions.
checkRowSum([], []).
checkRowSum([ CurrenRow | Rows ], [ [_, Value1], [_, Value2] | VarsT ]) :-
    abs(Value1 * Value2 - CurrenRow) #= 1,
    checkRowSum(Rows, VarsT).

% generateCardinalityList(+N, -Output)
% Generates a list with the column cardinality restrictions (only two elements in each column)
generateCardinalityList(0, []).
generateCardinalityList(N, [ H | T ]) :-
    H = N-2,
    N1 is N - 1,
    generateCardinalityList(N1, T), !.

% generateNumPosList(+Vars, -NumList, -PosList)
% Gets separate lists for number values and column positions from Vars
generateNumPosList([], [], []).
generateNumPosList([[Pos, Num] | VarsT], [NumListH | NumListT], [PosListH | PosListT]) :-
    NumListH = Num,
    PosListH = Pos,
    generateNumPosList(VarsT, NumListT, PosListT).


% distinctColumnPosition(+PosList)
% Verifies if there are no two distinct elements in the same row with the same column number
distinctColumnPosition([]).
distinctColumnPosition([Pos1, Pos2 | T]) :-
    Pos1 #\= Pos2,
    distinctColumnPosition(T).