(define (expt b n)
  (if (= n 0)
      1
      (* b (expt b (- n 1)))))
	
(define expt-rec
  (make-machine
    '(b n val continue)
    `((> ,>) (< ,<) (* ,*) (- ,-) (/ , /) (+ ,+) (= , =))
    '(
      controller
		(assign continue (label expt-done))
      expt-loop
		  (test (op =) (reg n) (const 0))
		  (branch (label base-case))
		  (save continue)
		  (save n)
		  (assign n (op -) (reg n) (const 1))
		  (assign continue (label after-expt))
		  (goto (label expt-loop))
	  after-expt  
		  (restore n)
		  (restore continue)
		  (assign val (op *) (reg b) (reg val))
		  (goto (reg continue))
      base-case
	  	(assign val (const 1))
	  	(goto (reg continue))
	  expt-done
    )))	
	
	
	
(set-register-contents! expt-rec 'b 2)
(set-register-contents! expt-rec 'n 5)

(start expt-rec)
(get-register-contents expt-rec 'val)

;===================================================
(define (expt b n)
  (define (expt-iter counter product)
    (if (= counter 0)
        product
        (expt-iter (- counter 1)
                   (* b product))))
  (expt-iter n 1))
	
(define expt-iter
  (make-machine
    '(b n product)
    `((> ,>) (< ,<) (* ,*) (- ,-) (/ , /) (+ ,+) (= , =))
    '(
      controller
	  	  (assign product (const 1))
      expt-loop
		  (test (op =) (reg n) (const 0))
		  (branch (label expt-done))
		  (assign product (op *) (reg b) (reg product))
		  (assign n (op -) (reg n) (const 1))
		  (goto (label expt-loop))
      expt-done	  	  
    )))	
	
	
	
(set-register-contents! expt-iter 'b 2)
(set-register-contents! expt-iter 'n 5)

(start expt-iter)
(get-register-contents expt-iter 'product)
