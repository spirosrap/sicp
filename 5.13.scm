;5.13
;of course we could just change lookup-register to allocate a register when it founds it 
;in the source code. My code is kinda sloppy. 

(define (make-machine register-names ops controller-text)
  (let ((machine (make-new-machine)))
    ;(for-each (lambda (register-name)
    ;            ((machine 'allocate-register) register-name))
    ;          register-names)
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
(define (make-assign inst machine labels operations pc)
  ((machine 'allocate-register) (assign-reg-name inst))	
	
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
        (set-contents! target (value-proc))
        (advance-pc pc)))))

(define (make-save inst machine stack pc)
  ((machine 'allocate-register) (stack-inst-reg-name inst))	
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
    (lambda ()
      (push stack (get-contents reg))
      (advance-pc pc))))

(define (make-restore inst machine stack pc)
    ((machine 'allocate-register) (stack-inst-reg-name inst))		
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
    (lambda ()
      (set-contents! reg (pop stack))    
      (advance-pc pc))))

(define (make-primitive-exp exp machine labels)
  (cond ((constant-exp? exp)
         (let ((c (constant-exp-value exp)))
           (lambda () c)))
        ((label-exp? exp)
         (let ((insts
                (lookup-label labels
                              (label-exp-label exp))))
           (lambda () insts)))
        ((register-exp? exp)
         (begin ((machine 'allocate-register) (cadr exp)) 
			 (let ((r (get-register machine
                                (register-exp-reg exp))))
           (lambda () (get-contents r)))) )
        (else
         (error "Unknown expression type -- ASSEMBLE" exp))))
