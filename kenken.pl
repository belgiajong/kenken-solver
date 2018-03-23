% N = dim of game
% C = constraints
% T = list of ints
kenken(N,C,T) :- set(N,Ctr), genboard(N,T,Ctr), fd_set(T,N), solve(C,T), fd_diff(T), transpose(T,X), fd_diff(X), fd_label(T).

plain_kenken(N,C,T) :- set(N,Ctr), genboard(N,T,Ctr), genlist(N,L), maplist(permutation(L),T), transpose(T,X), checkrowwrapper(X), p_solve(C,T).

set(N,N).

checkrowwrapper([]).
checkrowwrapper([Head|Tail]) :- checkrow(Head), checkrowwrapper(Tail).

checkrow([]).
checkrow(List) :- sort(List,N), length(List,L), length(N,X), L#=X.

genlist(N,T) :- findall(X,between(1,N,X),T).

transpose([],[]).
transpose([[Head|Tail] |Tail2], [[Head|RTail] |RTail2]) :- getcol(Tail2, RTail, X), transpose(X,Y), getcol(RTail2, Tail, Y).

getcol([],[],[]).
getcol([[Head|Tail]|Tail2],[Head|Col],[Tail|Row]) :- getcol(Tail2,Col,Row).

fd_set([],_).
fd_set([Head|Tail],N) :- fd_domain(Head,1,N), fd_set(Tail,N).

fd_diff([]).
fd_diff([Head|Tail]) :- fd_all_different(Head), fd_diff(Tail).

fd_label([]).
fd_label([Head|Tail]) :- fd_labeling(Head), fd_label(Tail).

retrieve(T,[R|C],X) :- nth(R,T,L1), nth(C,L1,X).

/(Val,R,L,T) :- retrieve(T,R,X), retrieve(T,L,Y), (X/Y #= Val ; Y/X #= Val).
-(Val,R,L,T) :- retrieve(T,R,X), retrieve(T,L,Y), (X-Y #= Val ; Y-X #= Val).

p_div(Val,R,L,T) :- retrieve(T,R,X), retrieve(T,L,Y), (Val is X div Y ; Val is Y div X).
p_sub(Val,R,L,T) :- retrieve(T,R,X), retrieve(T,L,Y), (Val is X-Y ; Val is Y-X).

p_sum(0,[],_).
p_sum(Val,[Head|Tail],T) :- retrieve(T,Head,X), Val1 is Val-X, sum(Val1,Tail,T).

sum(0,[],_).
sum(Val,[Head|Tail],T) :- retrieve(T,Head,X), Val #= X+Val1, sum(Val1,Tail,T).

mult(1,[],_).
mult(Val,[Head|Tail],T) :- retrieve(T,Head,X), Val #= X*Val1, mult(Val1,Tail,T).

p_mult(1,[],_).
p_mult(Val,[Head|Tail],T) :- retrieve(T,Head,X), Val1 is Val div X, mult(Val1,Tail,T).

solve([],T).
solve([Val+List|Tail],T) :- sum(Val,List,T), solve(Tail,T).
solve([Val*List|Tail],T) :- mult(Val,List,T), solve(Tail,T).
solve([/(Val,C1,C2)|Tail],T) :- /(Val,C1,C2,T), solve(Tail,T).
solve([-(Val,C1,C2)|Tail],T) :- -(Val,C1,C2,T), solve(Tail,T).

p_solve([],T).
p_solve([Val+List|Tail],T) :- p_sum(Val,List,T), p_solve(Tail,T).
p_solve([Val*List|Tail],T) :- p_mult(Val,List,T), p_solve(Tail,T).
p_solve([/(Val,C1,C2)|Tail],T) :- p_div(Val,C1,C2,T), p_solve(Tail,T).
p_solve([-(Val,C1,C2)|Tail],T) :- p_sub(Val,C1,C2,T), p_solve(Tail,T).

genboard(_,[],0).
genboard(N,T,C) :- findall(L,length(L,N),Y),succ(X,C),genboard(N,W,X),append(Y,W,T).
