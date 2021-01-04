:-use_module(library(random)).

% rnd_populate(+N, -Cols, -Rows, +LowerBound, +UpperBound)
% Populates Cols and Rows lists with N random values between LowerBound and UpperBound
rnd_populate(0, [], [], _LowerBound, _UpperBound).
rnd_populate(N, [ColH|ColT], [RowH|RowT], LowerBound, UpperBound):-
    N>0,
    random(LowerBound, UpperBound, RandomCol),
    random(LowerBound, UpperBound, RandomRow),
    ColH = RandomCol,
    RowH = RandomRow,
    N1 is N-1, 
    rnd_populate(N1, ColT, RowT, LowerBound, UpperBound).

% generateRandom(+BoardSize, -Problem)
% Random problem generator 
generateRandom(BoardSize, Problem) :-
    BoardSize > 1,
    MaxDomain is BoardSize * 2,
    length(Cols, BoardSize),
    length(Rows, BoardSize),
    UpperBound is MaxDomain * (MaxDomain - 1) + 2,
    % +1 because the number can be in the distance of 1
    % and +1 because the upper bound isn't included
    rnd_populate(BoardSize, Cols, Rows, 2, UpperBound),
    Candidate = [Cols, Rows],
    solve([1, MaxDomain], Candidate, _Result) -> Problem = Candidate ; generateRandom(BoardSize, Problem).

% generateHeuristic(+BoardSize, -Problem)
% Problem generator based on heuristic
generateHeuristic(BoardSize, Problem) :-
    BoardSize > 1,
    MaxDomain is BoardSize * 2,
    length(Vars, MaxDomain),
    UpperBound is MaxDomain * (MaxDomain - 1),

    getMultiplicationValue(BoardSize, UpperBound, MultiplicationValue),

    domain(Vars, 2, UpperBound),
    all_distinct(Vars),

    getProblemFromVars(Vars, BoardSize, [Columns, Rows]),

    orderedRestriction(Columns),
    orderedRestriction(Rows),
    
    multiplyList(Columns, ColMult),
    multiplyList(Rows, RowMult),
    
    ColMult #= MultiplicationValue,
    RowMult #= MultiplicationValue,
    labeling([], Vars),
    
    finalize(Vars, BoardSize, MaxDomain, Problem).

% finalize(+PloblemVars, +BoardSize, +MaxDomain, -FinalColsRows)
% Adds 1 or -1 to each Col/Row value found by the heuristic application
% Verifies if generated problem is possible to solve 
finalize(ProblemVars, BoardSize, MaxDomain, [FinalColumns, FinalRows]) :-
    length(OffsetVars, MaxDomain),
    domain(OffsetVars, -1, 1),
    calculateOffset(OffsetVars),
    labeling([], OffsetVars),

    addOffset(ProblemVars, OffsetVars, ProblemWithOffset),

    getProblemFromVars(ProblemWithOffset, BoardSize, [FinalColumns, FinalRows]),

    solve([1, MaxDomain], [FinalColumns, FinalRows], Res), 
    write('Problem ([Columns, Rows]): '), write([FinalColumns, FinalRows]), nl, 
    write('Solution ([Row, Value], ...): '), write(Res), nl.

% multiplyList(+List, -Res)
% Multiplies all values contained in List
% Unifies result with Res
multiplyList([], 1).
multiplyList([H|T], Res) :-
    multiplyList(T, Intermediate), 
    Res #= Intermediate * H.


% orderedRestriction(+List)
% Applies a restriction to the elements of 'List' so that the list is ordered
orderedRestriction([First, Second|[]]) :- First #< Second.
orderedRestriction([First, Second|T]) :-
    First #< Second,
    ordered([Second|T]).


% getProblemFromVars(+Vars, +BoardSize, -Problem)
% converts the vars, which is a uni-dimensional list into a Problem, 
% wich is a list with two lists inside: the columns and the rows
getProblemFromVars([ VarsH | VarsT ], BoardSize, [ [ ColumnH | ColumnT ], Rows ]) :-
    length(VarsT, VarsLength),
    VarsLength >= BoardSize, !,
    ColumnH = VarsH,
    getProblemFromVars(VarsT, BoardSize, [ ColumnT, Rows ]).

getProblemFromVars(Rows, _BoardSize, [ [], Rows ]).


% addOffset(+List, +Offset, -Out)
% Unifies 'Out' with the sum of each element of List with each offset
addOffset([], [], []).
addOffset([H|T], [OffsetH|OffsetT], [OutH|OutT]) :-
    OutH is H + OffsetH,
    addOffset(T, OffsetT, OutT).


% calculateOffset(List)
% applies restrictions to the elements in List. They can only be either 1 or -1
calculateOffset([]).
calculateOffset([H|T]) :-
    H #= 1 #\/ H #= -1,
    calculateOffset(T).


% getMultiplicationValue(+BoardSize, +UpperBound, -Res)
% Unifies 'Res' with the multiplication value of the current grid size
% This value is the value described in the section 5.2 of the report
getMultiplicationValue(2, _UpperBound, 24) :- !.
getMultiplicationValue(BoardSize, UpperBound, Res) :-
    SmallerBoardSize is BoardSize-1,
    MaxDomain is SmallerBoardSize * 2,
    SmallerUpperBound is MaxDomain * (MaxDomain - 1),
    getMultiplicationValue(SmallerBoardSize, SmallerUpperBound, TempRes),
    Res is TempRes * UpperBound.


