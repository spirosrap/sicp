;5.11b

(define (make-register name)
  (let ((contents '*unassigned*))
    (define (dispatch message)
      (cond ((eq? message 'get) contents)
            ((eq? message 'set)
             (lambda (value) (set! contents value)))
			((eq? message 'name) name) 
            (else
             (error "Unknown request -- REGISTER" message))))
    dispatch))

(define (get-reg-name register)
	(register 'name))


(define (make-save inst machine stack pc)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
    (lambda ()
      (push stack (cons (get-reg-name reg) (get-contents reg)))
      (advance-pc pc))))


(define (make-restore inst machine stack pc)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
    (lambda ()
		(let ((register (pop stack)))
			(if (equal? (car register) (get-reg-name reg))
				(begin (set-contents! reg (cdr register))
					   (advance-pc pc))
				(error "Saved from another variable - ASSEMBLER")	   
	  	  	)))
  ))

;5.11c

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
    machine))


;
(define (make-new-machine register-names)
  (let ((pc (make-register 'pc))
        (flag (make-register 'flag))
        (stack (make-stack))
        (the-instruction-sequence '())
		(stack-table '()))
		
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
			   
              ((eq? message 'stack) stack-table)
			  
              ((eq? message 'operations) the-ops)
              (else (error "Unknown request -- MACHINE" message))))
      dispatch)))

;
(define (update-insts! insts labels machine)
  (let ((pc (get-register machine 'pc))
        (flag (get-register machine 'flag))
        (stack-table (machine 'stack))
        (ops (machine 'operations)))
    (for-each
     (lambda (inst)
       (set-instruction-execution-proc! 
        inst
        (make-execution-procedure
         (instruction-text inst) labels machine
         pc flag stack-table ops)))
     insts)))

;
(define (make-execution-procedure inst labels machine
                                  pc flag stack-table ops)
  (cond ((eq? (car inst) 'assign)
         (make-assign inst machine labels ops pc))
        ((eq? (car inst) 'test)
         (make-test inst machine labels ops flag pc))
        ((eq? (car inst) 'branch)
         (make-branch inst machine labels flag pc))
        ((eq? (car inst) 'goto)
         (make-goto inst machine labels pc))
		 
        ((eq? (car inst) 'save)
		 (let ((stack (assoc (cadr inst) stack-table)))	
         (make-save inst machine (cadr stack) pc) ))
		 
        ((eq? (car inst) 'restore)
   		 (let ((stack (assoc (cadr inst) stack-table)))	
            (make-restore inst machine (cadr stack) pc)))
        ((eq? (car inst) 'perform)
         (make-perform inst machine labels ops pc))
        (else (error "Unknown instruction type -- ASSEMBLE"
                     inst))))

