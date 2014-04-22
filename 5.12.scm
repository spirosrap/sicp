;5.12 e.g. (fib-rec 'list-registers)


(define (make-machine register-names ops controller-text)
  (let ((machine (make-new-machine register-names)))
    (for-each (lambda (register-name)
                ((machine 'allocate-register) register-name))
              register-names)
    (for-each (lambda (register-name)
                ((machine 'allocate-stack) register-name))
              register-names)				  
    ((machine 'install-operations) ops)    
    ((machine 'install-instruction-sequence)
     (assemble controller-text machine))
	((machine 'make-list) controller-text)
	((machine 'make-goto-reg-list) controller-text)
	((machine 'make-savreslist) controller-text)	
	((machine 'make-list-registers) controller-text)			  
    machine))

;
(define (make-new-machine register-names)
  (let ((pc (make-register 'pc))
        (flag (make-register 'flag))
        (stack (make-stack))
        (the-instruction-sequence '())
		(stack-table '())
		(insts '())
		(goto-reglist '())
		(saved-restored '())
		(list-reg-assigned '())
		)
		
    (let ((the-ops
           (list (list 'initialize-stack
                       (lambda () (stack 'initialize)))
                 ;;**next for monitored stack (as in section 5.2.4)
                 ;;  -- comment out if not wanted
                 (list 'print-stack-statistics
                       (lambda () (stack 'print-statistics)))))
          (register-table
           (list (list 'pc pc) (list 'flag flag))))
      (define (allocate-register name)
        (if (assoc name register-table)
            (error "Multiply defined register: " name)
            (set! register-table
                  (cons (list name (make-register name))
                        register-table)))
        'register-allocated)
        (define (allocate-stack name)
          (if (assoc name stack-table)
              (error "Multiply defined stack: " name)
			(let ((stack (make-stack)))
              (begin (set! stack-table
                    (cons (list name stack)
                          stack-table))
					(stack 'initialize)
					  )))
          'stack-allocated)
		  
	  (define (reg-srcs reg text)
	  	(cond ((null? text) '())
	  	  ((not(pair? (car text))) (reg-srcs reg (cdr text)))
	  	  ((and (eq? (caar text) 'assign) (eq? reg (cadar text))) (cons (cddar text) (reg-srcs reg (cdr text))))
	  	  (else (reg-srcs reg (cdr text))))
	  	)

	  (define (lis-registers register-table text)
	     (cond ((null? register-table) '())
			 (else (cons (list (caar register-table) (reg-srcs (caar register-table) text)) (lis-registers (cdr register-table) text) )))	  	
	  )

	  (define (list-registers controller-text)
		  (set! list-reg-assigned (remove-duplicates (lis-registers register-table controller-text)))
	  )
	  
	  (define (remove-duplicates l)
	    (cond ((null? l)
	           '())
	          ((member (car l) (cdr l))
	           (remove-duplicates (cdr l)))
	          (else
	           (cons (car l) (remove-duplicates (cdr l))))))
			   
			   
	  
	  (define (sorted-list-insts controller-text)	  	
		(set! insts (remove-duplicates(sort (list-insts controller-text) 
					(lambda(x y) (string<? (symbol->string (car x)) (symbol->string(car y))))))
	  ))
		
  	  (define (list-insts text)
		  (cond ((null? text) '())
				((symbol? (car text)) (list-insts (cdr text)))
				(else (cons (car text) (list-insts (cdr text))))
			))

	  (define (reg-entry text)
	    (cond ((null? text) '())
	  		((and (pair? (car text)) (eq? (caar text) 'goto))
	  			(if (and (pair? (cadar text)) (register-exp? (cadar text)))
	  				(cons (cadr (cadar  text)) (reg-entry (cdr text)))
	  				(reg-entry (cdr text)))
	  		)
	  		(else (reg-entry (cdr text)))	
	  	))
				
	  (define (goto-regs controller-text)
	  	(set! goto-reglist (remove-duplicates (reg-entry controller-text))))		  

  	  (define (savrest-regs text)
  	    (cond ((null? text) '())
  	  		((and (pair? (car text)) (or (eq? (caar text) 'save) (eq? (caar text) 'restore)))
				(cons (cadar text) (savrest-regs (cdr text)))

  	  		)
  	  		(else (savrest-regs (cdr text)))	
  	  	))
	  (define (savreslist controller-text)
	  	(set! saved-restored (remove-duplicates (savrest-regs controller-text))))		
			
		
      (define (lookup-register name)
        (let ((val (assoc name register-table)))
          (if val
              (cadr val)
              (error "Unknown register:" name))))

      (define (lookup-stack name)
        (let ((val (assoc name stack-table)))
          (if val
              (cadr val)
              (error "Unknown stack:" name))))
	  			  
      (define (execute)
        (let ((insts (get-contents pc)))
          (if (null? insts)
              'done
              (begin
                ((instruction-execution-proc (car insts)))
                (execute)))))
      (define (dispatch message)
        (cond ((eq? message 'start)
               (set-contents! pc the-instruction-sequence)
               (execute))
              ((eq? message 'install-instruction-sequence)
               (lambda (seq) (set! the-instruction-sequence seq)))
              ((eq? message 'allocate-register) allocate-register)
			  ((eq? message 'allocate-stack) allocate-stack)
              ((eq? message 'get-register) lookup-register)
              ((eq? message 'install-operations)
               (lambda (ops) (set! the-ops (append the-ops ops))))
			   
			  ((eq? message 'instructions) insts)
			  ((eq? message 'make-list) sorted-list-insts)
			  ((eq? message 'make-goto-reg-list) goto-regs)
			  ((eq? message 'goto-reglist) goto-reglist)
			  ((eq? message 'make-savreslist) savreslist)
			  ((eq? message 'savreslist) saved-restored)

			  ((eq? message 'make-list-registers) list-registers)			  
			  ((eq? message 'list-registers) list-reg-assigned)			  			  			  
			  
              ((eq? message 'stack) stack-table)
			  
              ((eq? message 'operations) the-ops)
              (else (error "Unknown request -- MACHINE" message))))
      dispatch)))
