; Registers will be prefixed with @ and labels will be prefixed with :.
; Numbers will be constants.
;an idea from https://github.com/skanev/playground/tree/master/scheme/sicp/05

(define (starts-with@? exp) (equal? (substring (symbol->string exp) 0 1) "@"))
(define (register-exp? exp) (starts-with@? exp))
(define (register-exp-reg exp)  
	(string->symbol (substring (symbol->string exp) 1 (string-length (symbol->string exp)))))


(define (constant-exp? exp) (or (tagged-list? exp 'const) (number? exp)))
(define (constant-exp-value exp) 
	(cond ((number? exp) exp)
		(else (cadr exp))))


(define (starts-with:? exp) (equal? (substring (symbol->string exp) 0 1) ":"))
(define (label-exp? exp) (starts-with:? exp))
(define (label-exp-label exp)  
	(string->symbol (substring (symbol->string exp) 1 (string-length (symbol->string exp)))))

	(define sqrt-iter
	  (make-machine
	    '(x guess t1 t2 t3 t4)
	    `((> ,>) (< ,<) (* ,*) (- ,-) (/ , /) (+ ,+) (good-enough? , good-enough?) (improve , improve))
	    '(
	      init
			(assign guess 1.0)
	      sqrt
			(assign t1 (op *) @guess @guess)
			(assign t2 (op -) @t1 @x)
			(test (op >) @t2 0)
			(branch :abs)
			(assign t2 (op *) @t2 -1)
			abs
			(test (op <) @t2 0.001)
			(branch :sqrt-done)
			(assign t3 (op /) @x @guess)
			(assign t4 (op +) @guess @t3)
			(assign guess (op /) @t4 2)		
			(goto :sqrt)			  	
	      sqrt-done
	    )))
	;
	(define (expt b n)
	  (define (expt-iter counter product)
	    (if (= counter 0)
	        product
	        (expt-iter (- counter 1)
	                   (* b product))))
	  (expt-iter n 1))
		
	
	
	(set-register-contents! sqrt-iter 'x 2)
	(start sqrt-iter)
	(get-register-contents sqrt-iter 'guess)
	(label-exp-label ':label)  
  

 