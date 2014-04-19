;5.5

;fib(4)

;before entering aftefib-n-1

continue
--------
fib-done
aftefib-n-1
aftefib-n-1

n
--------
4
3
2

val
---------


(val:1,c:after-fib-n-1,n:1)

;after aftefib-n-1 :1st time
continue
--------
fib-done
aftefib-n-1
aftefib-n-1

n
--------
4
3

val
---------
1

(val:1,c:after-fib-n-2,n:0)

;after aftefib-n-1 again
continue
--------
fib-done
aftefib-n-1
aftefib-n-2

n
--------
4

val
---------
1
0
(val:0,c:after-fib-n-2,n:1)

;after aftefib-n-2 
continue
--------
fib-done
aftefib-n-1


n
--------
4

val
---------
1
(val:1,c:after-fib-n-2,n:1)

;after aftefib-n-1 
continue
--------
fib-done
aftefib-n-1


n
--------


val
---------
1
1
(val:1,c:after-fib-n-2,n:2)

;after fib-loop
continue
--------
fib-done
aftefib-n-1
aftefib-n-2

n
--------
2

val
---------
1
1
(val:1,c:after-fib-n-1,n:1)

;after aftefib-n-2

continue
--------
fib-done
aftefib-n-1

n
--------
2

val
---------
1

(val:2,c:after-fib-n-2,n:1)

;after aftefib-n-1
continue
--------
fib-done
aftefib-n-2


n
--------


val
---------
2
1
(val:2,c:after-fib-n-2,n:0)

;after aftefib-n-2

continue
--------
fib-done


n
--------


val
---------
2
1

(val:3,c:after-fib-n-2,n:1)

;done


;(factorial 3)
continue
--------
fact-done
after-fact
after-fact

n
--------
3
2

val
---------

;first after-fact
continue
--------
fact-done
after-fact


n
--------
3


val
---------
2

;second after-fact
continue
--------
fact-done


n
--------



val
---------
6

;done