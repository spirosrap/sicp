(define (remove x lst)
  (cond
    ((null? lst) '())
    ((= x (car lst)) (remove x (cdr lst)))
    (else (cons (car lst) (remove x (cdr lst))))))
(define (permute lst)
  (cond
    ((= (length lst) 1) (list lst))
    (else (apply append (map (lambda (i) (map (lambda (j) (cons i j)) (permute (remove i lst)))) lst)))))

(permute '(1 2 3 4 5))



(define multiple-dwelling 
 (let ((permutations (permute '(1 2 3 4 5)) ))
	 (define (result perms)
	 	 (if (null? perms) 
			 '()
			 (let* ((check (car permutations))
			         (baker (car check))
				 	 (cooper (cadr check))
					 (fletcher (caddr check))
					 (miller (cadddr check))
					 (smith (car (cddddr check)))) 
				 (if (and (not (= baker 5)) (not (= cooper 1)) (not (= fletcher 5)) (not (= fletcher 1)) 
				           (not (> miller cooper))  (not (= (abs (- smith fletcher)) 1))  (not (= (abs (- fletcher cooper)) 1)) )
						   (cons (car perms) (result (cdr perms)))
						   (result (cdr perms))
						   	
				 )
 
))) (result permutations) ) )
(multiple-dwelling)