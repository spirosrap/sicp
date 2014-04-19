;5.6

 afterfib-n-1 ; upon return, val contains Fib(n − 1)
   (restore n)
-->   (restore continue)
   ;; set up to compute Fib(n − 2)
   (assign n (op -) (reg n) (const 2))
-->   (save continue)
   (assign continue (label afterfib-n-2))
   (save val)         ; save Fib(n − 1)
   (goto (label fib-loop))
