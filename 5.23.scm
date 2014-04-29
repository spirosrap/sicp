;5.23

;cond (additions to the code):

;eceval-operations
(list 'cond->if cond->if)
(list 'cond? cond?) 

;eval-dispatch
(test (op cond?) (reg exp))
(branch (label ev-cond))

ev-cond
  (assign exp (op cond->if) (reg exp))
  (goto (label eval-dispatch))

;let
;add to ch5-syntax.scm
;let for ex. 5.23
(define (let? exp)
  (tagged-list? exp 'let))

(define (extract-parameters pv) 
	(cond ((null? pv) '())
	(else (cons (caar pv) (extract-parameters (cdr pv))))))	
(define (extract-values pv) 
	(cond ((null? pv) '())
     	(else (cons (cadar pv) (extract-parameters (cdr pv))))))	
  
(define (let-body exp) (cddr exp))
(define (let-parameters exp) 
	(extract-parameters (cadr exp)))
(define (let-values exp) 
	(extract-values (cadr exp)))

(define (let->combination exp)
	(cons (make-lambda (let-parameters exp) (let-body exp)) (let-values exp)))


(list 'let->combination let->combination)
(list 'let? let?)

;eval-dispatch
(test (op let?) (reg exp))
(branch (label ev-let))

ev-let
  (assign exp (op let->combination) (reg exp))
  (goto (label eval-dispatch))
