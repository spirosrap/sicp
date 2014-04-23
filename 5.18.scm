;Exercise 5.18: Modify the make-register procedure of 5.2.1 so that registers can be traced. Registers should ;accept messages that turn tracing on and off. When a register is traced, assigning a value to the register should ;print the name of the register, the old contents of the register, and the new contents being assigned. Extend the ;interface to the machine model to permit you to turn tracing on and off for designated machine registers.

(define (make-register name)
  (let ((contents '*unassigned*) (trace false))
    (define (dispatch message)
      (cond ((eq? message 'get) contents)
            ((eq? message 'set)
             (lambda (value) (set! contents value)))
            ((eq? message 'trace-on)
			(set! trace true))			 
            ((eq? message 'trace-off)
			(set! trace false))
            ((eq? message 'trace)
			trace)			 			
            (else
             (error "Unknown request -- REGISTER" message))))
    dispatch))

(define (make-new-machine)
  (let ((pc (make-register 'pc))
        (flag (make-register 'flag))
        (stack (make-stack))
        (the-instruction-sequence '())
		(inst-count 0)
		(trace false)
		
		)
    (let ((the-ops
           (list (list 'initialize-stack
                       (lambda () (stack 'initialize)))
                 ;;**next for monitored stack (as in section 5.2.4)
                 ;;  -- comment out if not wanted
                 (list 'print-stack-statistics
                       (lambda () (stack 'print-statistics)))		 					   
				    ))
          (register-table
           (list (list 'pc pc) (list 'flag flag))))
      (define (allocate-register name)
        (if (assoc name register-table)
            (error "Multiply defined register: " name)
            (set! register-table
                  (cons (list name (make-register name))
                        register-table)))
        'register-allocated)
	   (define (trace-reg trace)
		   (lambda (name)
			   (let ((val (assoc name register-table)))
            	   (if val
                 	  (cond  ((eq? trace true)((cadr val) 'trace-on))
					  	(else ((cadr val) 'trace-off)))
					   
					 (error "Unknown register:" name)))))
				 
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
  				(if trace 
  				    (begin (display (instruction-text (car insts)))
					(cond ((not (eq? (label-text (car insts)) 'nothing))
						(newline) 	
						(display (car (label-text (car insts))))))
					(newline))
  				(+ 1))  
                ((instruction-execution-proc (car insts)))
	   			 (set! inst-count (+ 1 inst-count)) 
                (execute)				
			))))
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
			  ((eq? message 'print-instruction-counter) (list 'number-of-instructions '= inst-count))
              ((eq? message 'reset-instruction-counter) (set! inst-count 0 ))
			  ((eq? message 'trace-on) (set! trace true))
 			  ((eq? message 'trace-off) (set! trace false))
			  ((eq? message 'trace-register-on) (trace-reg true))
			  ((eq? message 'trace-register-off) (trace-reg false))			  
              (else (error "Unknown request -- MACHINE" message))))
      dispatch)))


(define (make-assign inst machine labels operations pc)
  (let ((target
         (get-register machine (assign-reg-name inst)))
        (value-exp (assign-value-exp inst)))
    (let ((value-proc
           (if (operation-exp? value-exp)
               (make-operation-exp
                value-exp machine labels operations)
               (make-primitive-exp
                (car value-exp) machine labels))))
      (lambda ()                ; execution procedure for assign
		(if (target 'trace)
			(begin 
		  		(newline)
				(display "register:")
		  		(display (assign-reg-name inst))
				  		(newline)
				(display "old contents:")
		  		(display (get-contents target))		  
		        (set-contents! target (value-proc))
				(newline)
				(display "new contents:")
		  		(display (get-contents target))
				(newline)				
			)
			(set-contents! target (value-proc)))   
        (advance-pc pc)))))


