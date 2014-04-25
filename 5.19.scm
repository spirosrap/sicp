;Exercise 5.19:

(define (set-breakpoint machine label number)
	((machine 'install-breakpoint) label number))

(define (cancel-breakpoint machine label number)
	((machine 'cancel-breakpoint) label number))

(define (cancel-all-breakpoints machine)
	(machine 'cancel-all-breakpoints))
	
(define	(proceed-machine machine)
	(machine 'proceed))
	
(define (make-new-machine)
  (let ((pc (make-register 'pc))
        (flag (make-register 'flag))
        (stack (make-stack))
        (the-instruction-sequence '())
		(the-labels '())
		(the-breakpoints '())
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

	  (define (remove x ls)
	    (if (null? ls)
	        '()
	        (let ((h (car ls)))
	          ((if (equal? x h)
	              (lambda (y) y)
	              (lambda (y) (cons h y)))
	           (remove x (cdr ls))))))
	  	   
	  (define (breakpoints label number)
		  (set! the-breakpoints (cons (list label number) the-breakpoints))
		  (let ((instb (list-ref (lookup-label the-labels label) number)))
			  (set-car! instb (cons (instruction-text instb) (list 'breakpoint label number) ) )
	  ))
	  
	  (define (cancel-breakpoint label number)
		  (let ((instb (list-ref (lookup-label the-labels label) number)))
			  (set-car! instb (cons (instruction-text instb) (list 'nobreakpoint)) )
	  ))
	  
	  (define (cancel-all-breakpoints)
	      (for-each
	       (lambda (labelnumber)
			   (let ((label (car labelnumber)) (number (cadr labelnumber)))
				   (cancel-breakpoint label number)
				   )) the-breakpoints)
			   )
		  
	  (define (update-labels labels)
		 (set! the-labels labels))
			   
      (define (allocate-register name)
        (if (assoc name register-table)
            (error "Multiply defined register: " name)
            (set! register-table
                  (cons (list name (make-register name))
                        register-table)))
        'register-allocated)
      (define (lookup-register name)
        (let ((val (assoc name register-table)))
          (if val
              (cadr val)
              (error "Unknown register:" name))))
			  
      (define (execute)
        (let ((insts (get-contents pc)))
          (if (null? insts)
              'done
              (begin
                ((instruction-execution-proc (car insts)))
				(if (break-point? (car insts))
				   (cddaar insts)
                (execute))))))
				
      (define (dispatch message)
        (cond ((eq? message 'start)
               (set-contents! pc the-instruction-sequence)
               (execute))
              ((eq? message 'install-instruction-sequence)
               (lambda (seq) (set! the-instruction-sequence seq)))
              ((eq? message 'allocate-register) allocate-register)
              ((eq? message 'get-register) lookup-register)
              ((eq? message 'install-operations)
               (lambda (ops) (set! the-ops (append the-ops ops))))
              ((eq? message 'stack) stack)
              ((eq? message 'operations) the-ops)
              ((eq? message 'instruction-sequence) the-instruction-sequence)
              ((eq? message 'install-breakpoint) breakpoints)
			  ((eq? message 'cancel-breakpoint) cancel-breakpoint)
			  ((eq? message 'cancel-all-breakpoints) (cancel-all-breakpoints))			  			  
			  ((eq? message 'update-labels) update-labels)
			  ((eq? message 'proceed) (execute))
			  			  
		  (else (error "Unknown request -- MACHINE" message))))
      dispatch)))

;
(define (assemble controller-text machine)
  (extract-labels controller-text
    (lambda (insts labels)
      (update-insts! insts labels machine)
	  (update-labels! labels machine)
      insts)))

(define (make-instruction text)
  (cons (cons text (list 'nobreakpoint)) '())) ;the extra '() will contain the breakpoint keyword (breakpoint)
  
(define (break-point? inst)
	(cond ((null? (cadar inst)) false)
		  ((eq? (cadar inst) 'nobreakpoint) false) 
		  ((eq? (cadar inst) 'breakpoint) true) 
		  (else (error "instruction doesn't contain proper tagged breakpoint -ASSEMBLER"))))
