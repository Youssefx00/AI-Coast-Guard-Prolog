:- include('KB.pl').

up(CGx,CGXnew):-
        CGx>0,
        CGXnew is CGx-1.
down(CGx,CGXnew):-
        grid(A,A),
        CGx < A-1, 
        CGXnew is CGx+1.
right(CGy,CGYnew):-
        grid(A,A),
        CGy < A-1, 
        CGYnew is CGy+1.
left(CGY,CGYnew):-
        CGY>0,
        CGYnew is CGY-1.
drop(CGX,CGY, NewCapacity):- 
        station(CGX,CGY),
        NewCapacity is 0.
pickup(CGX,CGY, OldShips, NewShips, OldCapacity, NewCapacity):-
        member([CGX,CGY],OldShips),
        NewCapacity is OldCapacity+1,
        delete(OldShips,[CGX,CGY], NewShips).

goalHelper(CGX,CGY, [], Cap, s0):-
        agent_loc(CGX,CGY),
        capacity(Cap).

goalHelper(CGX,CGY, CurrShips, Capacity, result(Action, S)):-
Action = pickup, pickup(CGX,CGY,CurrShips,NewShips, Capacity, NewCapacity), goalHelper(CGX,CGY, NewShips, NewCapacity, S);
Action = drop, Capacity>0, drop(CGX,CGY, NewCapacity), goalHelper(CGX,CGY, CurrShips, NewCapacity, S);
Action = up, down(CGX,CGXnew), goalHelper(CGXnew,CGY, CurrShips, Capacity, S);
Action = right, left(CGY, CGYnew), goalHelper(CGX,CGYnew, CurrShips, Capacity, S);
Action = down, up(CGX,CGXnew), goalHelper(CGXnew,CGY, CurrShips, Capacity, S);
Action = left, right(CGY, CGYnew), goalHelper(CGX,CGYnew, CurrShips, Capacity, S).

goal2(S):-
        station(CGX,CGY),
        capacity(Cap),
        ships_loc(Ships),
        goalHelper(CGX,CGY,Ships,Cap,S).

goal(S):-  \+var(S), goal2(S).
goal(S):- var(S), ids(S,1).

ids(X,L):-
        (call_with_depth_limit(goal2(X),L,R), number(R));
        (call_with_depth_limit(goal2(X),L,R), R=depth_limit_exceeded,
        L1 is L+1, ids(X,L1)).
