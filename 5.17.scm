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
              (else (error "Unknown request -- MACHINE" message))))
      dispatch)))
	  
;
(define (extract-labels text receive)
  (if (null? text)
      (receive '() '())
      (extract-labels (cdr text)
       (lambda (insts labels)
         (let ((next-inst (car text)))
           (if (symbol? next-inst)
			   (begin
				;(cond ((not (null? insts)) (set-car! insts (cons (caar insts) (list next-inst)))))   
			   (cond ((not (null? insts))
				(begin   
					(set! insts (cons (make-inst-label (car insts) next-inst) (cdr insts)))
               (receive insts
                        (cons (make-label-entry next-inst
                                                insts)
                              labels))))
				(else 
	                (receive insts
	                         (cons (make-label-entry next-inst
	                                                 insts)
	                               labels)))					
							   )
			    )
			(begin								  
               (receive (cons (make-instruction next-inst)
                              insts)
                        labels))))))))


(define (make-instruction text)
  (cons (cons text '(nothing)) '() ))

(define (make-inst-label inst label)
		(cons (list (instruction-text inst) (list label)) '() ))
(define (instruction-text inst)
  (caar inst))
(define (label-text inst)
    (cadar inst))
	  
