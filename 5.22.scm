;5.22
(define append
    (make-machine
      '(x y temp continue val)
      `((> ,>) (< ,<) (* ,*) (- ,-) (/ , /) (+ ,+) (= , =) (null?  , null?) (car , car) (cdr ,cdr) (cons , cons)) 
      '(
	  controller
          (assign continue (label done))
      append-loop
  	    (test (op null?) (reg x)) 	 
          (branch (label immediate-answer))
  	    (save continue)
  		(assign continue (label after-append-1))
  		(save x)
  		(assign x (op cdr) (reg x))
  		(goto (label append-loop))
  	  after-append-1
  	    (restore x)
  		(restore continue)
		(assign temp (op car) (reg x))
  		(assign val (op cons) (reg temp) (reg val))
  		(goto (reg continue))
  	  immediate-answer
		(assign val (reg y))
  		(goto (reg continue))
  	  done
       )
   )
)

(define append!
    (make-machine
      '(x y temp continue val)
      `((> ,>) (< ,<) (* ,*) (- ,-) (/ , /) (+ ,+) (= , =) (null?  , null?) (car , car) (cdr ,cdr) (cons , cons) (set-cdr! , set-cdr!)) 
      '(
	  controller
          (assign continue (label done))
		  (assign temp (reg x))
      last-pair-loop
		(assign temp (op cdr) (reg temp))
  	    (test (op null?) (reg temp)) 	 
          (branch (label immediate-answer))
  		(save temp)
  		(goto (label last-pair-loop))
  	  immediate-answer
		(restore temp)
  		(perform (op set-cdr!) (reg temp) (reg y));answer is in x
  	  done
       )
   )
)
