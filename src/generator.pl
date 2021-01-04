:-use_module(library(random)).

rnd_populate(0, [], [], _LowerBound, _UpperBound).
rnd_populate(N, [ColH|ColT], [RowH|RowT], LowerBound, UpperBound):-
    N>0,
    random(LowerBound, UpperBound, RandomCol),
    random(LowerBound, UpperBound, RandomRow),
    ColH = RandomCol,
    RowH = RandomRow,
    N1 is N-1, 
    rnd_populate(N1, ColT, RowT, LowerBound, UpperBound).

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


multiplyList([], 1).
multiplyList([H|T], Res) :-
    multiplyList(T, Intermediate), 
    Res #= Intermediate * H.

orderedRestriction([First, Second|[]]) :- First #< Second.
orderedRestriction([First, Second|T]) :-
    First #< Second,
    ordered([Second|T]).

getProblemFromVars([ VarsH | VarsT ], BoardSize, [ [ ColumnH | ColumnT ], Rows ]) :-
    length(VarsT, VarsLength),
    VarsLength >= BoardSize, !,
    ColumnH = VarsH,
    getProblemFromVars(VarsT, BoardSize, [ ColumnT, Rows ]).

getProblemFromVars(Rows, _BoardSize, [ [], Rows ]).

generate(BoardSize, Problem) :-
    BoardSize > 1,
    MaxDomain is BoardSize * 2,
    length(Vars, MaxDomain),
    UpperBound is MaxDomain * (MaxDomain - 1),

    getMultiplicationValue(BoardSize, UpperBound, MultiplicationValue),

    write(MultiplicationValue),

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
    write(Vars),

    % Add +1 or -1 randomly
    %addOffset(Columns, IntermediateCols),
    %addOffset(Rows, IntermediateRows),
    %addOffsetRandomly(Columns, FinalColumns),
    %addOffsetRandomly(Rows, FinalRows),
    %nl,nl,
    %print('### Trying'), write(Vars), nl,
    
    finalize(Vars, BoardSize, MaxDomain), read_line(_A), fail.


finalize(ProblemVars, BoardSize, MaxDomain) :-
    length(OffsetVars, MaxDomain),
    domain(OffsetVars, -1, 1),
    calculateOffset(OffsetVars),
    labeling([], OffsetVars),

    addOffset(ProblemVars, OffsetVars, ProblemWithOffset),

    getProblemFromVars(ProblemWithOffset, BoardSize, [FinalColumns, FinalRows]),

    %nl,
    %write('- '), write([FinalColumns, FinalRows]), nl,

    solve([1, MaxDomain], [FinalColumns, FinalRows], Res), write([FinalColumns, FinalRows]), nl, write(Res).

addOffset([], [], []).
addOffset([H|T], [OffsetH|OffsetT], [OutH|OutT]) :-
    OutH is H + OffsetH,
    addOffset(T, OffsetT, OutT).


calculateOffset([]).
calculateOffset([H|T]) :-
    H #= 1 #\/ H #= -1,
    calculateOffset(T).


addOffsetRandomly([], []).
addOffsetRandomly([H|T], [OutH|OutT]) :-
    random(0, 2, Offset),
    (Offset = 1 -> OutH is H + 1 ; OutH is H - 1),
    addOffsetRandomly(T, OutT).


getMultiplicationValue(2, _UpperBound, 24) :- !.
getMultiplicationValue(BoardSize, UpperBound, Res) :-
    SmallerBoardSize is BoardSize-1,
    MaxDomain is SmallerBoardSize * 2,
    SmallerUpperBound is MaxDomain * (MaxDomain - 1),
    getMultiplicationValue(SmallerBoardSize, SmallerUpperBound, TempRes),
    Res is TempRes * UpperBound.