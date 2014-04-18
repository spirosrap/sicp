;first version:

(define sqrt-iter
  (make-machine
    '(x guess )
    `((> ,>) (* ,*) (+ ,+) (good-enough? , good-enough?) (improve , improve))
    '(
      init
		(assign guess (const 1.0))
      sqrt
		(test (op good-enough?) (reg guess) (reg x))
		(branch (label sqrt-done))
	  	(assign guess (op improve) (reg guess) (reg x))
		(goto (label sqrt))			  	
      sqrt-done
    )))
	
;second version: good-enough? in terms of arithmetic operations

(define sqrt-iter
  (make-machine
    '(x guess t1 t2)
    `((> ,>) (< ,<) (* ,*) (- ,-)(+ ,+) (good-enough? , good-enough?) (improve , improve))
    '(
      init
		(assign guess (const 1.0))
      sqrt
		;(test (op good-enough?) (reg guess) (reg x))
		(assign t1 (op *) (reg guess) (reg guess))
		(assign t2 (op -) (reg t1) (reg x))
		(test (op >) (reg t2) (const 0))
		(branch (label abs))
		(assign t2 (op *) (reg t2) (const -1))
		abs
		(test (op <) (reg t2) (const 0.001))
		(branch (label sqrt-done))
	  	(assign guess (op improve) (reg guess) (reg x))
		(goto (label sqrt))			  	
      sqrt-done
    )))	
	
;third version: improve in terms of arithmetic operations

(define sqrt-iter
  (make-machine
    '(x guess t1 t2 t3 t4)
    `((> ,>) (< ,<) (* ,*) (- ,-) (/ , /) (+ ,+) (good-enough? , good-enough?) (improve , improve))
    '(
      init
		(assign guess (const 1.0))
      sqrt
		;(test (op good-enough?) (reg guess) (reg x))
		(assign t1 (op *) (reg guess) (reg guess))
		(assign t2 (op -) (reg t1) (reg x))
		(test (op >) (reg t2) (const 0))
		(branch (label abs))
		(assign t2 (op *) (reg t2) (const -1))
		abs
		(test (op <) (reg t2) (const 0.001))
		(branch (label sqrt-done))
	  	;(assign guess (op improve) (reg guess) (reg x))
		(assign t3 (op /) (reg x) (reg guess))
		(assign t4 (op +) (reg guess) (reg t3))
		(assign guess (op /) (reg t4) (const 2))		
		(goto (label sqrt))			  	
      sqrt-done
    )))	