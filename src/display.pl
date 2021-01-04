% display_board_middle_separator
% displays the board's middle horizontal line separator
display_board_middle_separator(Length) :-
	print('   \x251C\'), %'
	display_board_middle_separator_element(Length).

display_board_middle_separator_element(1) :-
	print('\x2500\\x2500\\x2500\\x2500\\x2524\\n').

display_board_middle_separator_element(N) :-
	N > 1,
	print('\x2500\\x2500\\x2500\\x2500\\x253C\'), %'
	N1 is N-1,
	display_board_middle_separator_element(N1).

% display_board_top_separator
% displays the board's top horizontal border separator
display_board_top_separator([], RowLength) :-
	nl,
    print('   \x250C\'), %'
	display_board_top_separator_element(RowLength),
	nl.
display_board_top_separator([ColNum | ColNumT], RowLength) :-
	print('   '),
    print(ColNum),
	display_board_top_separator(ColNumT, RowLength).

display_board_top_separator_element(1) :-
	print('\x2500\\x2500\\x2500\\x2500\\x2510\ ').
display_board_top_separator_element(N) :-
	N > 1,
	print('\x2500\\x2500\\x2500\\x2500\\x252C\'), %'
	N1 is N-1,
	display_board_top_separator_element(N1).	

% display_board_bottom_separator
% displays the board's bottom horizontal border separator
display_board_bottom_separator(RowLength) :-
	print('   \x2514\'), %'
	display_board_bottom_separator_element(RowLength).

display_board_bottom_separator_element(1) :-
	print('\x2500\\x2500\\x2500\\x2500\\x2518\\n').

display_board_bottom_separator_element(N) :-
	N > 1,
	print('\x2500\\x2500\\x2500\\x2500\\x2534\'), %',
	N1 is N-1,
	display_board_bottom_separator_element(N1).

% display_board_row(+Row, +N)
% displays a board 'Row', including the left digit 'N' that indicates the line coordinate and the pieces that are there
display_board_row([], _N, _RowNumber).
display_board_row([Symbol | T], N, RowNumber) :-
    (N \= -1 -> print(RowNumber); true),  % prints the left digit
    ((RowNumber < 10, N \= -1) -> print(' '); true),
	print(' \x2502\ '),
	print(Symbol),
    print(' '),
	display_board_row(T, -1, RowNumber).


% display_board(+GameBoard, +N)
% displays the whole 'GameBoard'. N is the line counter, from 1 to 9 (including)
display_board([H | []], N, _ColList, [RowNumber | []], RowLength) :-
	display_board_row(H, N, RowNumber),
	print(' \x2502\\n'),
	display_board_bottom_separator(RowLength).

display_board([H | T], N, ColList, [RowNumber | RowList], RowLength) :-
	(N == 1 -> print('  '), display_board_top_separator(ColList, RowLength); true),
	display_board_row(H, N, RowNumber),
	print(' \x2502\\n'),
	display_board_middle_separator(RowLength),
	N1 is N+1,
	display_board(T, N1, ColList, RowList, RowLength).

display_solution(Solution, ColList, RowList) :-
	length(RowList, RowLength),
	convert_solution_to_board(Solution, Board, RowLength),
	length(ColList, RowLength),
    display_board(Board, 1, ColList, RowList, RowLength), !.

make_space(X) :-
	\+ ground(X),
	X = ' '.
make_space(_X).

  
convert_solution_to_board([[Pos, Num] | SolutionT], Converted, RowLength, CurrentRow) :-
	nth1(Pos, CurrentRow, Num),
	maplist(make_space, CurrentRow),
	convert_solution_to_board(SolutionT, Converted, RowLength), !.

convert_solution_to_board([], [], _RowLength).

convert_solution_to_board([[Pos, Num] | SolutionT], [Row | ResT], RowLength) :-
	length(Row, RowLength),
	nth1(Pos, Row, Num),
	convert_solution_to_board(SolutionT, ResT, RowLength, Row), !.


