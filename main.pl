%% Nathan Gillette
%% Prolog Main

%% (starting location, top of grid, size of grid, locations of infected, path)
solve([SX,SY], Ending, [GX, GY], Locations, FinalAnswer) :-
	genPath([SX, SY], Ending, [GX, GY], Locations, [[SX,SY]], FinalAnswer).

% base case    
genPath([_, SY], Ending, _, _, Path, FinalAnswer) :- 
    SY is Ending,			%%we've reached the top
    FinalAnswer= Path.		%%set final answer
    
%%recursive call to find path
genPath([SX, SY], Ending, [GX, GY], Locations, Path, FinalAnswer) :-
    SY \= Ending,							%%not in base case
	walk([SX,SY],[HX,HY]),					%%find next possible move
    safe(Locations, [HX,HY]),				%%check if out of range of infected
	valid([GX,GY],[HX,HY]),					%%in bounds?
    \+member([HX,HY], Path),				%%haven't visted spot previous
    append(Path,[[HX,HY]], NewPath),		%%put path at the end of the list 
	genPath([HX,HY],Ending, [GX, GY], Locations, NewPath, FinalAnswer). %%recursive call

%% Moves upward
walk([PX,PY],[HX,HY]) :-
    HX is PX,			%%X stays the same
    HY is PY + 1.		%%Y increases to go up

%% Moves to the left
walk([PX,PY],[HX,HY]) :-
    HX is PX - 1,	%%X decreases to go left
    HY is PY.		%%Y stays the same

%% Moves to the right
walk([PX,PY],[HX,HY]) :-
    HX is PX + 1,	%%X increases to go right
    HY is PY.		%%Y stays the same to go left

%%Bounds Checker
valid([GX,GY],[HX,HY]) :-
    HX =< GX,		%%checks if within upper X limit
    HY =< GY,		%%checks if within upper Y limit
    HX >= 0,		%%checks if within lower X limit
    HY >= 0.		%%checks if within lower Y limit

%%base case, when there is no infected left to check, returns true
safe([], _).

%%recursively checks all infected locations to see closeness, returns true if all safe
safe([[Lx,Ly]|Locations], [HX,HY]) :-
    safeCheck([Lx,Ly],[HX,HY],6),	%%checks distance for current Lx, Ly
	safe(Locations,[HX,HY]).		%%calls itself with tail from locations parameter

%checks distance between current pos and infected, returns true if greater than D
safeCheck([X1,Y1],[X2,Y2],D) :- D < (((X1-X2)^2) + (Y1-Y2)^2)^(1/2).

