# kenken-solver

A KenKen solver in Prolog. Given a list of constraints representing an NxN KenKen board, the solver is able to return an NxN board which solves the puzzle. 

For example:

kenken_testcase(
  6,
  [
   +(11, [[1|1], [2|1]]),
   /(2, [1|2], [1|3]),
   *(20, [[1|4], [2|4]]),
   *(6, [[1|5], [1|6], [2|6], [3|6]]),
   -(3, [2|2], [2|3]),
   /(3, [2|5], [3|5]),
   *(240, [[3|1], [3|2], [4|1], [4|2]]),
   *(6, [[3|3], [3|4]]),
   *(6, [[4|3], [5|3]]),
   +(7, [[4|4], [5|4], [5|5]]),
   *(30, [[4|5], [4|6]]),
   *(6, [[5|1], [5|2]]),
   +(9, [[5|6], [6|6]]),
   +(8, [[6|1], [6|2], [6|3]]),
   /(2, [6|4], [6|5])
  ]
).

with this query:

?- fd_set_vector_max(255), kenken_testcase(N,C), kenken(N,C,T).

should return: 

C = [11+[[1|1],[2|1]], /(2,[1|2],[1|3]), 20*[[1|4],[2|4]],
     6*[[1|5],[1|6],[2|6],[3|6]], -(3,[2|2],[2|3]), /(3,[2|5],[3|5]),
     240*[[3|1],[3|2],[4|1],[4|2]], 6*[[3|3],[3|4]], 6*[[4|3],[5|3]],
     7+[[4|4],[5|4],[5|5]], 30*[[4|5],[4|6]], 6*[[5|1],[5|2]],
     9+[[5|6],[6|6]], 8+[[6|1],[6|2],[6|3]], /(2,[6|4],[6|5])]
N = 6
T = [[5,6,3,4,1,2],
     [6,1,4,5,2,3],
     [4,5,2,3,6,1],
     [3,4,1,2,5,6],
     [2,3,6,1,4,5],
     [1,2,5,6,3,4]] ?

where T is the solved board. 

kenken.pl makes use of Prolog's convenient finite domain to speed up calculations. plain_kenken.pl avoids using finite domain at the expense of slower performance.