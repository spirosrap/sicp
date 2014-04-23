;5.14

;Number of pushes, maximum stack depth : (n-1)*2


(load "ch5-regsim.scm")

(define fact-rec
  (make-machine
    '(n val continue)
    `((> ,>) (< ,<) (* ,*) (- ,-) (/ , /) (+ ,+) (= , =) (read , read))
    '(controller
		(perform (op initialize-stack))
	    (assign n (op read))   
		(assign continue (label fact-done))   ; set up final return address 
	fact-loop   
		(test (op =) (reg n) (const 1))   
		(branch (label base-case))   
		(save continue)                       ; Set up for the recursive call   
		(save n)                              ; by saving n and continue.   
		(assign n (op -) (reg n) (const 1))   ; Set up continue so that the   
		(assign continue (label after-fact))  ; computation will continue   
		(goto (label fact-loop))              ; at after-fact when the 
	  after-fact                              ; subroutine returns.   
  		(restore n)   
	    (restore continue)   
		(assign val (op *) (reg n) (reg val)) ; val now contains n(n - 1)!   
		(goto (reg continue))                 ; return to caller 
	 base-case   
		(assign val (const 1))                ; base case: 1! = 1   
		(goto (reg continue))                 ; return to caller 
	fact-done
	(perform (op print-stack-statistics)))
))
	
	
;(set-register-contents! fact-rec 'n 10)
(start fact-rec)
3
(get-register-contents fact-rec 'val)

(start fact-rec)
4
(get-register-contents fact-rec 'val)

(start fact-rec)
5
(get-register-contents fact-rec 'val)

(start fact-rec)
6
(get-register-contents fact-rec 'val)

(start fact-rec)
7
(get-register-contents fact-rec 'val)
