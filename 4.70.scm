(define (add-assertion! assertion)
  (store-assertion-in-index assertion)
  (let ((old-assertions THE-ASSERTIONS))
    (set! THE-ASSERTIONS
          (cons-stream assertion 
                       old-assertions))
    'ok))

(define (add-rule! rule)
  (store-rule-in-index rule)
  (let ((old-rules THE-RULES))
    (set! THE-RULES
          (cons-stream rule old-rules))
    'ok))

;if we had used the following code:

(define (add-assertion! assertion)
  (store-assertion-in-index assertion)
  (set! THE-ASSERTIONS
        (cons-stream assertion 
                     THE-ASSERTIONS))
  'ok)
  
; Then every element of THE-ASSERTIONS stream would have only one assertion. Because every stream-car or stream-car(stream cdr x) would
; give only one assertion. We avoid this problem by using a let binding.  


