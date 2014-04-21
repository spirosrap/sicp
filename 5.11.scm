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


