(define (analyze-require exp)
  (let ((pproc (analyze 
                (require-predicate exp))))
    (lambda (env succeed fail)
      (pproc env
             (lambda (pred-value fail2)
               (if (false? pred-value)
                   (fail2)
                   (succeed 'ok fail2)))
             fail))))
				
(define (require? exp) 
  (tagged-list? exp 'require))

(define (require-predicate exp) 
  (cadr exp))

;((require? exp) (analyze-require exp))