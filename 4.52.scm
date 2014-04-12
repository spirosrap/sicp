(define (analyze-if-fail exp)
  (let ((pproc (analyze (if-fail-predicate exp)))
        (cproc (analyze (if-fail-consequent exp))))
    (lambda (env succeed fail)
      (pproc env
             ;; success continuation for evaluating the predicate
             ;; to obtain pred-value
             (lambda (pred-value fail2)              
                   (pproc env succeed fail2))
             ;; failure continuation for evaluating the predicate
			 (lambda ()
                (cproc env succeed fail))))))			 


(define (if-fail? exp) (tagged-list? exp 'if-fail))
(define (if-fail-predicate exp) (cadr exp))
(define (if-fail-consequent exp) (caddr exp))
;in the ambeval: ((if-fail? exp) (analyze-if-fail exp))