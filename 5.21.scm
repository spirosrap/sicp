;5.21

;a
(define count-leaves-rec
  (make-machine
    '(tree temp continue val)
    `((> ,>) (< ,<) (* ,*) (- ,-) (/ , /) (+ ,+) (= , =) (null?  , null?) (notpair?  , (lambda (x) ( not (pair? x)))) (car , car) (cdr ,cdr)) 
    '(controller
        (assign continue (label done))
      count-loop
	    (test (op null?) (reg tree)) 	 
        (branch (label immediate-answer1))
	    (test (op notpair?) (reg tree)) 	 
        (branch (label immediate-answer2))
	    (save continue)
		(assign continue (label after-count-1))
		(save tree)
		(assign tree (op cdr) (reg tree))
		(goto (label count-loop))
	  after-count-1
	    (restore tree)
		(restore continue)
		(assign tree (op car) (reg tree))
		(save continue)
		(assign continue (label after-count-2))
		(save val)
		(goto (label count-loop))
	  after-count-2
	    (assign temp (reg val))
		(restore val)
		(restore continue)
		(assign val (op +) (reg val) (reg temp))
		(goto (reg continue))	
	  immediate-answer1
	  	(assign val (const 0))
		(goto (reg continue))
  	  immediate-answer2
  	  	(assign val (const 1))
  		(goto (reg continue))		
	  done
     )
))

;b
(define count-leaves-rec-expl
    (make-machine
      '(tree n temp continue val)
      `((> ,>) (< ,<) (* ,*) (- ,-) (/ , /) (+ ,+) (= , =) (null?  , null?) (notpair?  , (lambda (x) ( not (pair? x)))) (car , car) (cdr ,cdr)) 
      '(
	  controller
		  (assign n (const 0))
          (assign continue (label done))
      count-loop
  	    (test (op null?) (reg tree)) 	 
          (branch (label immediate-answer1))
  	    (test (op notpair?) (reg tree)) 	 
          (branch (label immediate-answer2))
  	    (save continue)
  		(assign continue (label after-count-1))
  		(save tree)
  		(assign tree (op car) (reg tree))
  		(goto (label count-loop))
  	  after-count-1
  	    (restore tree)
  		(restore continue)
  		(assign tree (op cdr) (reg tree))
		(save n)
  		(save continue)
  		(assign continue (label after-count-2))
  		(goto (label count-loop))
  	  after-count-2
  	    (assign temp (reg n))
  		(restore continue)
		(assign val (reg n))
		(restore n)
		(assign n (reg val))		
  		(goto (reg continue))
  	  immediate-answer1
  		(goto (reg continue)) ;answer in in n
      immediate-answer2
    	(assign n (op +) (reg n)(const 1))
        (goto (reg continue))
  	  done
       )
   )
)

